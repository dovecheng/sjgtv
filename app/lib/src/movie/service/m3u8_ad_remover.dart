import 'package:base/log.dart';
import 'package:http/http.dart' as http;

/// M3U8 广告移除器
///
/// 通过分析 HLS 播放列表中片段 URL 的相似度，识别并移除广告片段。
/// 原理：正片片段的 URL 通常具有相似的命名规则（如递增序号），
/// 而广告片段的 URL 来自不同的 CDN，命名规则不同，相似度低。
abstract final class M3U8AdRemover {
  static final Log _log = Log('M3U8AdRemover');

  /// 处理 M3U8 播放列表，移除广告片段
  ///
  /// [m3u8Url] 播放列表地址
  /// [headers] 可选的请求头
  /// 返回处理后的 M3U8 内容（已移除广告片段）
  static Future<String> fixAdM3u8Ai(
    String m3u8Url, [
    Map<String, String>? headers,
  ]) async {
    final int startTime = DateTime.now().millisecondsSinceEpoch;
    headers ??= {};

    _log.d(() => '处理地址: $m3u8Url');

    /// 计算两个字符串从头开始的相同字符数
    int compareSameLen(String s1, String s2) {
      int length = 0;
      while (length < s1.length &&
          length < s2.length &&
          s1[length] == s2[length]) {
        length++;
      }
      return length;
    }

    String reverseString(String str) =>
        String.fromCharCodes(str.runes.toList().reversed);

    Future<String> fetchM3u8(String url) async {
      final http.Response response =
          await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.body.trim();
      }
      throw Exception('Failed to fetch M3U8: ${response.statusCode}');
    }

    /// 拼接相对路径和基础 URL
    String urljoin(String fromPath, String nowPath) {
      fromPath = fromPath;
      nowPath = nowPath;

      try {
        final Uri baseUri = Uri.parse(fromPath);
        final Uri resolvedUri = baseUri.resolve(nowPath);
        return resolvedUri.toString();
      } catch (e) {
        if (nowPath.startsWith('http://') || nowPath.startsWith('https://')) {
          return nowPath;
        }
        if (fromPath.isEmpty) return nowPath;

        final String separator =
            fromPath.endsWith('/') || nowPath.startsWith('/') ? '' : '/';
        return '$fromPath$separator$nowPath';
      }
    }

    /// 将相对路径转换为绝对路径
    List<String> resolveUrls(List<String> lines, String baseUrl) {
      return lines.map((line) {
        if (!line.startsWith('#') &&
            !line.startsWith('http://') &&
            !line.startsWith('https://')) {
          return urljoin(baseUrl, line);
        }
        return line;
      }).toList();
    }

    /// 压缩连续空行为单行
    List<String> compressEmptyLines(List<String> lines) {
      final List<String> result = <String>[];
      bool lastLineWasEmpty = false;

      for (final String line in lines) {
        final bool isEmpty = line.trim().isEmpty;
        if (!isEmpty || !lastLineWasEmpty) {
          result.add(line);
        }
        lastLineWasEmpty = isEmpty;
      }

      return result;
    }

    Future<List<String>> parseM3u8ToArray(String url) async {
      String content = await fetchM3u8(url);
      List<String> lines = content.split('\n');
      lines = resolveUrls(lines, m3u8Url);
      lines = compressEmptyLines(lines);
      return lines;
    }

    List<String> lines = await parseM3u8ToArray(m3u8Url);

    // 处理嵌套 M3U8（主播放列表 → 子播放列表）
    String lastUrl = lines.isNotEmpty ? lines.last : '';
    if (lastUrl.length < 5 && lines.length > 1) {
      lastUrl = lines[lines.length - 2];
    }
    if (lastUrl.contains('.m3u8') && lastUrl != m3u8Url) {
      m3u8Url = lastUrl;
      if (!lastUrl.startsWith('http://') && !lastUrl.startsWith('https://')) {
        m3u8Url = urljoin(m3u8Url, lastUrl);
      }
      _log.d(() => '嵌套地址: $m3u8Url');
      lines = await parseM3u8ToArray(m3u8Url);
    }

    /// 识别广告片段
    ///
    /// 算法：
    /// 1. 第一遍：确定正片片段的 URL 特征（firstStr），统计相似/不相似片段数量
    /// 2. 第二遍：从尾部找到最后一个正片片段（lastStr）
    /// 3. 第三遍：根据相似度阈值过滤广告片段
    Map<String, dynamic> findAdSegments(List<String> segments, String baseUrl) {
      final List<String> cleanSegments = List<String>.from(segments);
      String firstStr = "";
      String secondStr = "";
      int maxSimilarity = 0;
      int primaryCount = 1;
      int secondaryCount = 0;

      // 第一遍：确定正片 URL 特征
      for (final String segment in cleanSegments) {
        if (!segment.startsWith("#")) {
          if (firstStr.isEmpty) {
            firstStr = segment;
          } else {
            final int similarity = compareSameLen(firstStr, segment);
            // 相似度骤降说明可能是广告
            if (maxSimilarity > similarity + 1) {
              if (secondStr.length < 5) secondStr = segment;
              secondaryCount++;
            } else {
              maxSimilarity = similarity;
              primaryCount++;
            }
          }
          if (secondaryCount + primaryCount >= 30) break;
        }
      }
      // 如果不相似的片段更多，说明开头是广告
      if (secondaryCount > primaryCount) firstStr = secondStr;

      final int firstStrLen = firstStr.length;
      final int halfLength = (cleanSegments.length ~/ 2).toString().length;

      // 第二遍：从尾部找正片片段（用于验证）
      int maxc = 0;
      String? lastStr;
      for (final String segment in cleanSegments.reversed) {
        if (!segment.startsWith("#")) {
          final String reversedFirstStr = reverseString(firstStr);
          final String reversedX = reverseString(segment);
          final int similarity = compareSameLen(reversedFirstStr, reversedX);
          maxSimilarity = compareSameLen(firstStr, segment);
          maxc++;
          if (firstStrLen - maxSimilarity <= halfLength + similarity ||
              maxc > 10) {
            lastStr = segment;
            break;
          }
        }
      }

      _log.d(() => '最后切片: $lastStr');

      final List<String> adSegments = <String>[];
      final List<String> cleanedSegments = <String>[];

      // 第三遍：过滤广告片段
      for (int i = 0; i < cleanSegments.length; i++) {
        final String segment = cleanSegments[i];
        if (segment.startsWith("#")) {
          // 处理 #EXT-X-KEY 等包含 URI 的标签
          if (segment.contains("URI=")) {
            final RegExpMatch? uriMatch =
                RegExp(r'URI="([^"]*)"').firstMatch(segment);
            if (uriMatch != null) {
              final String updatedUri = urljoin(baseUrl, uriMatch.group(1)!);
              cleanedSegments.add(
                segment.replaceFirst(
                  RegExp(r'URI="([^"]*)"'),
                  'URI="$updatedUri"',
                ),
              );
            } else {
              cleanedSegments.add(segment);
            }
          } else {
            cleanedSegments.add(segment);
          }
        } else {
          // 相似度低于阈值的判定为广告
          if (compareSameLen(firstStr, segment) < maxSimilarity) {
            adSegments.add(segment);
            // 跳过广告片段对应的 #EXTINF 行
            if (i + 1 < cleanSegments.length &&
                cleanSegments[i + 1].startsWith("#EXTINF")) {
              i++;
            }
          } else {
            cleanedSegments.add(urljoin(baseUrl, segment));
          }
        }
      }

      return {'adSegments': adSegments, 'cleanSegments': cleanedSegments};
    }

    final Map<String, dynamic> result = findAdSegments(lines, m3u8Url);
    final List<String> cleanSegments = result['cleanSegments'] as List<String>;
    final List<String> adSegments = result['adSegments'] as List<String>;

    _log.d(() => '广告分片: $adSegments');
    _log.d(
        () => '处理耗时: ${DateTime.now().millisecondsSinceEpoch - startTime} ms');
    return cleanSegments.join('\n');
  }
}
