import 'package:base/log.dart';
import 'package:http/http.dart' as http;

class M3U8AdRemover {
  static final _log = Log('M3U8AdRemover');

  static Future<String> fixAdM3u8Ai(
    String m3u8Url, [
    Map<String, String>? headers,
  ]) async {
    final int startTime = DateTime.now().millisecondsSinceEpoch;
    headers ??= {};

    _log.d(() => '处理地址: $m3u8Url');

    // Helper functions
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
      final http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.body.trim();
      }
      throw Exception('Failed to fetch M3U8: ${response.statusCode}');
    }

    String urljoin(String fromPath, String nowPath) {
      fromPath = fromPath;
      nowPath = nowPath;

      try {
        final Uri baseUri = Uri.parse(fromPath);
        final Uri resolvedUri = baseUri.resolve(nowPath);
        return resolvedUri.toString();
      } catch (e) {
        // Fallback for invalid URIs
        if (nowPath.startsWith('http://') || nowPath.startsWith('https://')) {
          return nowPath;
        }
        if (fromPath.isEmpty) return nowPath;

        final String separator = fromPath.endsWith('/') || nowPath.startsWith('/')
            ? ''
            : '/';
        return '$fromPath$separator$nowPath';
      }
    }

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

    // Handle nested M3U8
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

    // Find ad segments
    Map<String, dynamic> findAdSegments(List<String> segments, String baseUrl) {
      final List<String> cleanSegments = List<String>.from(segments);
      String firstStr = "";
      String secondStr = "";
      int maxSimilarity = 0;
      int primaryCount = 1;
      int secondaryCount = 0;

      // First pass: determine firstStr
      for (final String segment in cleanSegments) {
        if (!segment.startsWith("#")) {
          if (firstStr.isEmpty) {
            firstStr = segment;
          } else {
            final int similarity = compareSameLen(firstStr, segment);
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
      if (secondaryCount > primaryCount) firstStr = secondStr;

      final int firstStrLen = firstStr.length;
      final int halfLength = (cleanSegments.length ~/ 2).toString().length;

      // Second pass: find lastStr
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

      // Third pass: process segments
      for (int i = 0; i < cleanSegments.length; i++) {
        final String segment = cleanSegments[i];
        if (segment.startsWith("#")) {
          if (segment.contains("URI=")) {
            final RegExpMatch? uriMatch = RegExp(r'URI="([^"]*)"').firstMatch(segment);
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
          if (compareSameLen(firstStr, segment) < maxSimilarity) {
            adSegments.add(segment);
            // Skip the next segment (EXTINF) if it exists
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
    _log.d(() => '处理耗时: ${DateTime.now().millisecondsSinceEpoch - startTime} ms');
    return cleanSegments.join('\n');
  }
}
