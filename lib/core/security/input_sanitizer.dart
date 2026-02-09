import 'package:sjgtv/core/log/log.dart';

/// 输入清理器
///
/// 清理用户输入，防止 XSS 攻击和其他安全问题
class InputSanitizer {
  final Log log = (InputSanitizer).log;

  /// 危险的 HTML 标签和属性
  static const List<String> _dangerousTags = [
    'script',
    'iframe',
    'object',
    'embed',
    'form',
    'input',
    'button',
    'link',
    'style',
    'meta',
  ];

  static const List<String> _dangerousAttributes = [
    'onclick',
    'onerror',
    'onload',
    'onmouseover',
    'onmouseout',
    'onfocus',
    'onblur',
    'javascript:',
    'data:',
  ];

  /// 清理文本输入
  static String sanitizeText(String input) {
    if (input.isEmpty) return '';

    // 移除危险的 HTML 标签
    String sanitized = input;

    for (final tag in _dangerousTags) {
      final pattern = RegExp(
        '<$tag[^>]*>.*?</$tag>',
        caseSensitive: false,
        dotAll: true,
      );
      sanitized = sanitized.replaceAll(pattern, '');

      final pattern2 = RegExp('<$tag[^>]*/?>', caseSensitive: false);
      sanitized = sanitized.replaceAll(pattern2, '');
    }

    // 移除危险的属性
    for (final attr in _dangerousAttributes) {
      final pattern = RegExp(
        '\\s+$attr\\s*=\\s*["\'][^"\']*["\']',
        caseSensitive: false,
        multiLine: true,
      );
      sanitized = sanitized.replaceAll(pattern, '');
    }

    // 移除 JavaScript 伪协议
    final jsPattern = RegExp(
      r'javascript:\s*',
      caseSensitive: false,
    );
    sanitized = sanitized.replaceAll(jsPattern, '');

    return sanitized.trim();
  }

  /// 清理搜索关键词
  static String sanitizeSearchQuery(String query) {
    if (query.isEmpty) return '';

    // 移除特殊字符
    final cleaned = query.replaceAll(
      RegExp(r'[<>"]'),
      '',
    );

    // 限制长度
    const maxLength = 100;
    return cleaned.length > maxLength
        ? cleaned.substring(0, maxLength)
        : cleaned;
  }

  /// 验证 JSON 输入
  static bool isValidJson(String input) {
    if (input.isEmpty) return false;

    try {
      // 简单验证 JSON 结构
      final trimmed = input.trim();
      if (!(trimmed.startsWith('{') && trimmed.endsWith('}')) &&
          !(trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        return false;
      }

      // 尝试解析 JSON
      // 这里不实际解析，只是验证基本结构
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 清理 JSON 输入
  static String sanitizeJson(String input) {
    if (!isValidJson(input)) return '{}';

    // 移除危险的 JavaScript 代码
    final sanitized = input.replaceAll(
      RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, dotAll: true),
      '',
    );

    return sanitized;
  }

  /// 转义 HTML 特殊字符
  static String escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }

  /// 验证文件名
  static bool isValidFileName(String filename) {
    if (filename.isEmpty) return false;

    // 检查路径遍历攻击
    if (filename.contains('..') || filename.contains('/') || filename.contains('\\')) {
      return false;
    }

    // 检查特殊字符
    final pattern = RegExp(r'[<>:"|?*\x00-\x1F]');
    if (pattern.hasMatch(filename)) {
      return false;
    }

    return true;
  }

  /// 清理文件名
  static String sanitizeFileName(String filename) {
    if (!isValidFileName(filename)) return '';

    // 移除特殊字符
    return filename.replaceAll(
      RegExp(r'[<>:"|?*\x00-\x1F]'),
      '_',
    );
  }
}
