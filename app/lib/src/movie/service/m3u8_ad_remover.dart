import 'package:base/log.dart';
import 'package:http/http.dart' as http;

/// M3U8 广告移除器配置
class M3U8AdRemoverConfig {
  const M3U8AdRemoverConfig({
    this.similarityThreshold = 5,
    this.enableUrlSimilarity = true,
    this.enableDurationBasedDetection = true,
    this.enableSizeBasedDetection = true,
    this.maxAdDuration = 60,
    this.minContentDuration = 120,
    this.enableWhitelist = false,
    this.whitelist = const [],
    this.enableBlacklist = false,
    this.blacklist = const [],
    this.enableCache = true,
    this.cacheExpiry = const Duration(hours: 1),
  });

  /// URL 相似度阈值（低于此值判定为广告）
  final int similarityThreshold;

  /// 启用 URL 相似度检测
  final bool enableUrlSimilarity;

  /// 启用基于时长的广告检测
  final bool enableDurationBasedDetection;

  /// 启用基于大小的广告检测
  final bool enableSizeBasedDetection;

  /// 最大广告时长（秒）
  final int maxAdDuration;

  /// 最小正片时长（秒）
  final int minContentDuration;

  /// 启用白名单
  final bool enableWhitelist;

  /// 白名单 URL 模式
  final List<String> whitelist;

  /// 启用黑名单
  final bool enableBlacklist;

  /// 黑名单 URL 模式
  final List<String> blacklist;

  /// 启用缓存
  final bool enableCache;

  /// 缓存过期时间
  final Duration cacheExpiry;
}

/// M3U8 广告检测结果
class M3U8AdRemoverResult {
  const M3U8AdRemoverResult({
    required this.originalUrl,
    required this.cleanedUrl,
    required this.adSegments,
    required this.contentSegments,
    required this.processingTime,
    required this.totalSegments,
    required this.adCount,
    required this.contentCount,
    this.error,
  });

  final String originalUrl;
  final String cleanedUrl;
  final List<String> adSegments;
  final List<String> contentSegments;
  final int processingTime;
  final int totalSegments;
  final int adCount;
  final int contentCount;
  final String? error;

  double get adRatio => totalSegments > 0 ? adCount / totalSegments : 0;

  Map<String, dynamic> toJson() {
    return {
      'originalUrl': originalUrl,
      'cleanedUrl': cleanedUrl,
      'adSegments': adSegments,
      'contentSegments': contentSegments,
      'processingTime': processingTime,
      'totalSegments': totalSegments,
      'adCount': adCount,
      'contentCount': contentCount,
      'adRatio': adRatio,
      'error': error,
    };
  }
}

/// M3U8 片段信息
class M3U8Segment {
  const M3U8Segment({
    required this.url,
    this.duration,
    this.size,
    this.byterange,
    this.isAd = false,
    this.confidence = 0.0,
  });

  final String url;
  final double? duration;
  final int? size;
  final String? byterange;
  final bool isAd;
  final double confidence;

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'duration': duration,
      'size': size,
      'byterange': byterange,
      'isAd': isAd,
      'confidence': confidence,
    };
  }
}

/// M3U8 广告移除器
///
/// 通过多种策略识别和移除 M3U8 播放列表中的广告片段：
/// 1. URL 相似度分析
/// 2. 片段时长分析
/// 3. 片段大小分析
/// 4. 白名单/黑名单过滤
abstract final class M3U8AdRemover {
  static final Log _log = Log('M3U8AdRemover');

  /// 缓存：URL → 清理后的内容
  static final Map<String, _CacheEntry> _cache = {};

  /// 默认配置
  static const M3U8AdRemoverConfig defaultConfig = M3U8AdRemoverConfig();

  /// 处理 M3U8 播放列表，移除广告片段
  ///
  /// [m3u8Url] 播放列表地址
  /// [headers] 可选的请求头
  /// [config] 自定义配置
  /// 返回处理结果
  static Future<M3U8AdRemoverResult> removeAds(
    String m3u8Url, [
    Map<String, String>? headers,
    M3U8AdRemoverConfig? config,
  ]) async {
    final int startTime = DateTime.now().millisecondsSinceEpoch;
    config ??= defaultConfig;
    headers ??= {};

    _log.d(() => '开始处理: $m3u8Url');

    try {
      // 检查缓存
      if (config.enableCache && _cache.containsKey(m3u8Url)) {
        final _CacheEntry entry = _cache[m3u8Url]!;
        if (!entry.isExpired(config.cacheExpiry)) {
          _log.d(() => '使用缓存结果');
          return entry.result.copyWith(
            processingTime: DateTime.now().millisecondsSinceEpoch - startTime,
          );
        }
        _cache.remove(m3u8Url);
      }

      // 获取 M3U8 内容
      String m3u8Content = await _fetchM3u8(m3u8Url, headers);

      // 处理嵌套 M3U8
      if (_hasNestedM3u8(m3u8Content)) {
        final String nestedUrl = _extractNestedM3u8Url(m3u8Content, m3u8Url);
        if (nestedUrl != m3u8Url) {
          _log.d(() => '发现嵌套 M3U8: $nestedUrl');
          return await removeAds(nestedUrl, headers, config);
        }
      }

      // 解析 M3U8
      final List<M3U8Segment> segments = await _parseM3u8(
        m3u8Content,
        m3u8Url,
        headers,
      );

      // 识别广告片段
      final List<M3U8Segment> processedSegments = await _identifyAds(
        segments,
        config,
      );

      // 过滤广告片段
      final List<M3U8Segment> contentSegments = processedSegments
          .where((segment) => !segment.isAd)
          .toList();

      final List<M3U8Segment> adSegments = processedSegments
          .where((segment) => segment.isAd)
          .toList();

      // 生成清理后的 M3U8
      final String cleanedContent = _generateCleanedM3u8(
        m3u8Content,
        contentSegments,
      );

      final int processingTime = DateTime.now().millisecondsSinceEpoch - startTime;

      final M3U8AdRemoverResult result = M3U8AdRemoverResult(
        originalUrl: m3u8Url,
        cleanedUrl: m3u8Url, // 返回原 URL，实际清理在内存中
        adSegments: adSegments.map((s) => s.url).toList(),
        contentSegments: contentSegments.map((s) => s.url).toList(),
        processingTime: processingTime,
        totalSegments: segments.length,
        adCount: adSegments.length,
        contentCount: contentSegments.length,
      );

      // 缓存结果
      if (config.enableCache) {
        _cache[m3u8Url] = _CacheEntry(
          result: result,
          cleanedContent: cleanedContent,
          timestamp: DateTime.now(),
        );
      }

      _log.d(() => '处理完成: 总片段=${segments.length}, '
          '广告=${adSegments.length}, 正片=${contentSegments.length}, '
          '耗时=${processingTime}ms');

      return result;
    } catch (e, s) {
      _log.e(() => '处理失败', e, s);
      return M3U8AdRemoverResult(
        originalUrl: m3u8Url,
        cleanedUrl: m3u8Url,
        adSegments: [],
        contentSegments: [],
        processingTime: DateTime.now().millisecondsSinceEpoch - startTime,
        totalSegments: 0,
        adCount: 0,
        contentCount: 0,
        error: e.toString(),
      );
    }
  }

  /// 获取清理后的 M3U8 内容
  static Future<String?> getCleanedContent(String m3u8Url) async {
    final _CacheEntry? entry = _cache[m3u8Url];
    return entry?.cleanedContent;
  }

  /// 清除缓存
  static void clearCache() {
    _cache.clear();
    _log.d(() => '缓存已清除');
  }

  /// 获取缓存统计
  static Map<String, dynamic> getCacheStats() {
    return {
      'size': _cache.length,
      'entries': _cache.keys.toList(),
    };
  }

  // 私有方法

  static Future<String> _fetchM3u8(
    String url,
    Map<String, String> headers,
  ) async {
    final http.Response response =
        await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return response.body.trim();
    }
    throw Exception('Failed to fetch M3U8: ${response.statusCode}');
  }

  static bool _hasNestedM3u8(String content) {
    return content.contains('.m3u8') &&
        content.split('\n').where((line) => line.trim().endsWith('.m3u8')).length <
            10;
  }

  static String _extractNestedM3u8Url(String content, String baseUrl) {
    final List<String> lines = content.split('\n');
    for (final String line in lines) {
      final String trimmedLine = line.trim();
      if (trimmedLine.endsWith('.m3u8') && !trimmedLine.startsWith('#')) {
        return _resolveUrl(baseUrl, trimmedLine);
      }
    }
    return baseUrl;
  }

  static String _resolveUrl(String fromPath, String nowPath) {
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

  static Future<List<M3U8Segment>> _parseM3u8(
    String content,
    String baseUrl,
    Map<String, String> headers,
  ) async {
    final List<String> lines = content.split('\n');
    final List<M3U8Segment> segments = [];
    double? currentDuration;
    String? currentByteRange;

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i].trim();

      if (line.startsWith('#EXTINF:')) {
        currentDuration = _parseDuration(line);
      } else if (line.startsWith('#EXT-X-BYTERANGE:')) {
        currentByteRange = line.split(':')[1];
      } else if (!line.startsWith('#') && line.isNotEmpty) {
        final String segmentUrl = _resolveUrl(baseUrl, line);
        
        // 获取片段大小（如果启用大小检测）
        int? segmentSize;
        // 这里可以添加获取片段大小的逻辑

        segments.add(M3U8Segment(
          url: segmentUrl,
          duration: currentDuration,
          size: segmentSize,
          byterange: currentByteRange,
        ));

        currentDuration = null;
        currentByteRange = null;
      }
    }

    return segments;
  }

  static double? _parseDuration(String extinfLine) {
    try {
      final RegExp regex = RegExp(r'#EXTINF:([\d.]+)');
      final RegExpMatch? match = regex.firstMatch(extinfLine);
      if (match != null) {
        return double.parse(match.group(1)!);
      }
    } catch (e) {
      _log.w(() => '解析时长失败: $extinfLine');
    }
    return null;
  }

  static Future<List<M3U8Segment>> _identifyAds(
    List<M3U8Segment> segments,
    M3U8AdRemoverConfig config,
  ) async {
    if (segments.isEmpty) return segments;

    // 白名单过滤
    if (config.enableWhitelist) {
      for (int i = 0; i < segments.length; i++) {
        segments[i] = segments[i].copyWith(
          isAd: !_matchesWhitelist(segments[i].url, config.whitelist),
          confidence: _matchesWhitelist(segments[i].url, config.whitelist) ? 1.0 : 0.0,
        );
      }
    }

    // 黑名单过滤
    if (config.enableBlacklist) {
      for (int i = 0; i < segments.length; i++) {
        if (_matchesBlacklist(segments[i].url, config.blacklist)) {
          segments[i] = segments[i].copyWith(
            isAd: true,
            confidence: 1.0,
          );
        }
      }
    }

    // URL 相似度分析
    if (config.enableUrlSimilarity) {
      segments = _identifyAdsByUrlSimilarity(
        segments,
        config.similarityThreshold,
      );
    }

    // 时长分析
    if (config.enableDurationBasedDetection) {
      segments = _identifyAdsByDuration(
        segments,
        config.maxAdDuration,
        config.minContentDuration,
      );
    }

    // 大小分析
    if (config.enableSizeBasedDetection) {
      segments = await _identifyAdsBySize(segments);
    }

    return segments;
  }

  static bool _matchesWhitelist(String url, List<String> patterns) {
    for (final String pattern in patterns) {
      if (url.contains(pattern)) return true;
    }
    return false;
  }

  static bool _matchesBlacklist(String url, List<String> patterns) {
    for (final String pattern in patterns) {
      if (url.contains(pattern)) return true;
    }
    return false;
  }

  static List<M3U8Segment> _identifyAdsByUrlSimilarity(
    List<M3U8Segment> segments,
    int threshold,
  ) {
    if (segments.length < 5) return segments;

    // 找到主特征（最相似的片段 URL）
    String primaryFeature = '';
    int maxSimilarity = 0;

    for (int i = 0; i < segments.length && i < 20; i++) {
      for (int j = i + 1; j < segments.length && j < i + 20; j++) {
        final int similarity = _calculateSimilarity(
          segments[i].url,
          segments[j].url,
        );
        if (similarity > maxSimilarity) {
          maxSimilarity = similarity;
          primaryFeature = segments[i].url;
        }
      }
    }

    if (primaryFeature.isEmpty) return segments;

    // 根据相似度标记广告
    for (int i = 0; i < segments.length; i++) {
      final int similarity = _calculateSimilarity(
        primaryFeature,
        segments[i].url,
      );
      
      if (similarity < threshold) {
        final double confidence = 1.0 - (similarity / maxSimilarity);
        segments[i] = segments[i].copyWith(
          isAd: true,
          confidence: confidence,
        );
      }
    }

    return segments;
  }

  static int _calculateSimilarity(String s1, String s2) {
    int length = 0;
    while (length < s1.length &&
        length < s2.length &&
        s1[length] == s2[length]) {
      length++;
    }
    return length;
  }

  static List<M3U8Segment> _identifyAdsByDuration(
    List<M3U8Segment> segments,
    int maxAdDuration,
    int minContentDuration,
  ) {
    // 计算平均时长
    final List<double> durations = segments
        .where((s) => s.duration != null)
        .map((s) => s.duration!)
        .toList();

    if (durations.isEmpty) return segments;

    final double avgDuration = durations.reduce((a, b) => a + b) / durations.length;

    for (int i = 0; i < segments.length; i++) {
      final double? duration = segments[i].duration;
      if (duration != null) {
        // 短片段可能是广告
        if (duration < maxAdDuration && duration < avgDuration * 0.5) {
          segments[i] = segments[i].copyWith(
            isAd: true,
            confidence: 0.7,
          );
        }
      }
    }

    return segments;
  }

  static Future<List<M3U8Segment>> _identifyAdsBySize(
    List<M3U8Segment> segments,
  ) async {
    // 这里可以添加基于片段大小的广告检测逻辑
    // 需要实际获取片段大小，可能需要额外的 HTTP 请求
    return segments;
  }

  static String _generateCleanedM3u8(
    String originalContent,
    List<M3U8Segment> contentSegments,
  ) {
    final List<String> lines = originalContent.split('\n');
    final List<String> cleanedLines = [];
    final Set<String> contentUrls = contentSegments.map((s) => s.url).toSet();

    for (final String line in lines) {
      if (line.startsWith('#')) {
        cleanedLines.add(line);
      } else if (line.trim().isEmpty) {
        cleanedLines.add(line);
      } else {
        // 检查是否为内容片段
        bool isContent = false;
        for (final String contentUrl in contentUrls) {
          if (line.contains(contentUrl) || contentUrl.contains(line)) {
            isContent = true;
            break;
          }
        }
        if (isContent) {
          cleanedLines.add(line);
        }
      }
    }

    return cleanedLines.join('\n');
  }
}

/// 缓存条目
class _CacheEntry {
  const _CacheEntry({
    required this.result,
    required this.cleanedContent,
    required this.timestamp,
  });

  final M3U8AdRemoverResult result;
  final String cleanedContent;
  final DateTime timestamp;

  bool isExpired(Duration expiry) {
    return DateTime.now().difference(timestamp) > expiry;
  }
}

/// M3U8Segment 扩展方法
extension M3U8SegmentExtension on M3U8Segment {
  M3U8Segment copyWith({
    String? url,
    double? duration,
    int? size,
    String? byterange,
    bool? isAd,
    double? confidence,
  }) {
    return M3U8Segment(
      url: url ?? this.url,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      byterange: byterange ?? this.byterange,
      isAd: isAd ?? this.isAd,
      confidence: confidence ?? this.confidence,
    );
  }
}

/// M3U8AdRemoverResult 扩展方法
extension M3U8AdRemoverResultExtension on M3U8AdRemoverResult {
  M3U8AdRemoverResult copyWith({
    String? originalUrl,
    String? cleanedUrl,
    List<String>? adSegments,
    List<String>? contentSegments,
    int? processingTime,
    int? totalSegments,
    int? adCount,
    int? contentCount,
    String? error,
  }) {
    return M3U8AdRemoverResult(
      originalUrl: originalUrl ?? this.originalUrl,
      cleanedUrl: cleanedUrl ?? this.cleanedUrl,
      adSegments: adSegments ?? this.adSegments,
      contentSegments: contentSegments ?? this.contentSegments,
      processingTime: processingTime ?? this.processingTime,
      totalSegments: totalSegments ?? this.totalSegments,
      adCount: adCount ?? this.adCount,
      contentCount: contentCount ?? this.contentCount,
      error: error ?? this.error,
    );
  }
}