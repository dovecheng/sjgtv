import 'package:sjgtv/core/log/log.dart';

/// URL 验证器
///
/// 验证和清理外部 URL，确保安全性
class UrlValidator {
  final Log log = (UrlValidator).log;

  /// 允许的协议
  static const List<String> _allowedSchemes = ['http', 'https'];

  /// URL 黑名单
  static const List<String> _blacklist = ['malicious.com', 'phishing.net'];

  /// 验证 URL 格式
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);

      // 检查协议
      if (!_allowedSchemes.contains(uri.scheme)) {
        return false;
      }

      // 检查主机
      if (uri.host.isEmpty) {
        return false;
      }

      // 检查黑名单
      if (_isBlacklisted(uri.host)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 检查主机是否在黑名单中
  static bool _isBlacklisted(String host) {
    final lowerHost = host.toLowerCase();
    for (final blacklisted in _blacklist) {
      if (lowerHost == blacklisted || lowerHost.endsWith('.$blacklisted')) {
        return true;
      }
    }
    return false;
  }

  /// 清理 URL
  static String sanitizeUrl(String url) {
    if (!isValidUrl(url)) {
      return '';
    }

    try {
      final uri = Uri.parse(url);

      // 移除可能的危险参数
      final safeUri = uri.replace(
        queryParameters: _sanitizeQueryParams(uri.queryParameters),
      );

      return safeUri.toString();
    } catch (e) {
      return '';
    }
  }

  /// 清理查询参数
  static Map<String, String> _sanitizeQueryParams(Map<String, String> params) {
    final sanitized = <String, String>{};

    // 允许的查询参数白名单
    const allowedParams = {'v', 'id', 'page', 'limit', 'q', 'sort'};

    for (final entry in params.entries) {
      if (allowedParams.contains(entry.key)) {
        sanitized[entry.key] = entry.value;
      }
    }

    return sanitized;
  }

  /// 验证图片 URL
  static bool isValidImageUrl(String url) {
    if (!isValidUrl(url)) return false;

    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();

      // 检查是否是常见的图片格式
      const imageExtensions = [
        '.jpg',
        '.jpeg',
        '.png',
        '.gif',
        '.webp',
        '.svg',
      ];
      return imageExtensions.any((ext) => path.endsWith(ext));
    } catch (e) {
      return false;
    }
  }
}
