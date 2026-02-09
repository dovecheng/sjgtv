import 'dart:math' as math;

/// 字节数格式化（用于日志等，不依赖 l10n）
const List<String> _sizeSuffixes = [
  'B',
  'KB',
  'MB',
  'GB',
  'TB',
  'PB',
  'EB',
  'ZB',
  'YB',
];

/// 将字节数格式化为带单位的字符串
String formatBytesSize(int bytes, [int decimals = 2]) {
  if (bytes <= 0) {
    return '0 B';
  }
  final int i = (math.log(bytes) / math.log(1024)).floor().clamp(
    0,
    _sizeSuffixes.length - 1,
  );
  return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${_sizeSuffixes[i]}';
}
