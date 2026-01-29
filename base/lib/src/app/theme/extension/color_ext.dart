import 'dart:ui';

export 'package:flutter_colorpicker/flutter_colorpicker.dart'
    show ColorExtension1, ColorExtension2;

extension ColorLuminanceExt on Color {
  /// 计算颜色是否偏暗
  bool get isDark => computeLuminance() < 0.5;

  /// 计算颜色是否偏亮
  bool get isLight => computeLuminance() >= 0.5;

  /// 根据当前颜色的明暗返回对比色
  /// onDark: 当当前颜色偏暗时返回的前景色（默认白色）
  /// onLight: 当当前颜色偏亮时返回的前景色（默认 black87）
  Color getOnColor({
    Color onDarkColor = const Color(0xFFFFFFFF),
    Color onLightColor = const Color(0xDD000000), // 等价于 Colors.black87
  }) {
    return isDark ? onDarkColor : onLightColor;
  }
}
