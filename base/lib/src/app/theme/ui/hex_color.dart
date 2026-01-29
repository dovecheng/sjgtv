import 'package:base/log.dart';
import 'package:flutter/painting.dart';

/// 十六进制颜色代码格式的Color
///
/// ARGB自动补位, 自动处理`#`符号
class HexColor extends Color {
  static final RegExp _hexColorRE = RegExp(r'^#?[\da-fA-F]{1,8}$');

  /// 字符串颜色代码
  ///
  /// * HexColor('#FFDDCCBB') to 0xFFDDCCBB
  /// * HexColor('#ADDCCBB')  to 0xAADDCCBB
  /// * HexColor('#DDCCBB')   to 0xFFDDCCBB
  /// * HexColor('#AFDCB')    to 0xAFDDCCBB
  /// * HexColor('#ADCB')     to 0xAADDCCBB
  /// * HexColor('#A80')      to 0xFFAA8800
  /// * HexColor('#A8')       to 0xFFA8A8A8
  /// * HexColor('#8')        to 0xFF888888
  factory HexColor(
    String? hex, {
    String? defHex,
    int? defValue,
    Color? defColor,
  }) {
    // 去掉空格
    hex = hex?.trim();

    // 格式校验
    if (hex == null || !_hexColorRE.hasMatch(hex)) {
      if (defHex != null) {
        return HexColor(defHex, defValue: defValue, defColor: defColor);
      } else if (defValue != null) {
        return HexColor._(defValue);
      } else if (defColor != null) {
        return HexColor._(defColor.toARGB32());
      }
      Log('HexColor').w(
        () =>
            'HexColor: 颜色代码错误 hex=$hex defHex=$defHex defValue=${defValue?.toRadixString(16)} defColor=$defColor',
        null,
        StackTrace.current,
      );
      return HexColor._(0xFFFF0000);
    }

    // 去掉#号
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }

    // 补充位数
    switch (hex.length) {
      case 1:
        hex = 'FF'.padRight(8, hex);
        break;
      case 2:
        hex = 'FF${hex[0]}${hex[1]}${hex[0]}${hex[1]}${hex[0]}${hex[1]}';
        break;
      case 3:
        hex = 'FF${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
        break;
      case 4:
        hex =
            '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}';
        break;
      case 5:
        hex =
            '${hex[0]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}${hex[4]}${hex[4]}';
        break;
      case 6:
        hex = 'FF$hex';
        break;
      case 7:
        hex =
            '${hex[0]}${hex[0]}${hex[1]}${hex[2]}${hex[3]}${hex[4]}${hex[5]}${hex[6]}';
        break;
    }

    // 转16进制int值
    int value = int.parse(hex, radix: 16);

    return HexColor._(value);
  }

  HexColor._(super.value);
}
