import 'dart:convert';

import 'package:quiver/strings.dart' as quiver;

extension StringEqualsIgnoreCaseExt on String? {
  bool equalsIgnoreCase(String? value) => quiver.equalsIgnoreCase(this, value);
}

extension StringCompareIgnoreCaseExt on String {
  int compareIgnoreCase(String value) => quiver.compareIgnoreCase(this, value);
}

extension StringTrimExt on String {
  /// 缩进到所有行的最小缩进量
  ///
  /// 参考 https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/trim-indent.html
  String trimIndent() {
    Iterable<String> lines = LineSplitter.split(this);
    int minIndent = -1;
    for (String line in lines) {
      for (int i = 0; i < line.length; i++) {
        String char = line[i];
        if (char != ' ' && char != '\t') {
          if (i == 0) {
            return this;
          } else if (minIndent == -1 || i < minIndent) {
            minIndent = i;
          }
          break;
        }
      }
    }
    return lines.map((String line) => line.substring(minIndent)).join('\n');
  }

  /// 缩进到匹配符位置
  ///
  /// 参考 https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/trim-margin.html
  String trimMargin([String marginPrefix = '|']) {
    assert(
      marginPrefix.length == 1 && marginPrefix != ' ' && marginPrefix != '\t',
    );
    return LineSplitter.split(this)
        .map((String line) {
          for (int i = 0; i < line.length; i++) {
            String char = line[i];
            if (char != ' ' && char != '\t') {
              return char == marginPrefix ? line.substring(i + 1) : line;
            }
          }
          return line;
        })
        .join('\n');
  }
}

extension StringRemovePrefixExt on String {
  String removePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    } else {
      return this;
    }
  }
}

extension StringRemoveSuffixExt on String {
  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    } else {
      return this;
    }
  }
}

extension StringBlankExtension on String {
  /// 判断是否是空白字符
  bool get isBlank {
    if (length == 0) {
      return true;
    }
    for (int value in runes) {
      if (!_isWhitespace(value)) {
        return false;
      }
    }
    return true;
  }

  /// 判断是否不是空白字符
  bool get isNotBlank => !isBlank;

  /// 判断是否是空白字符
  bool _isWhitespace(int rune) =>
      /// 制表符、换行符等控制字符（0x0009到0x000D）
      (rune >= 0x0009 && rune <= 0x000D) ||
      /// 空格（0x0020）
      rune == 0x0020 ||
      /// 下一行（0x0085）
      rune == 0x0085 ||
      /// 不间断空格（0x00A0）
      rune == 0x00A0 ||
      /// Ogham空格标记（0x1680）
      rune == 0x1680 ||
      /// 蒙古文元音分隔符（0x180E）
      rune == 0x180E ||
      /// 一系列通用空格字符（0x2000到0x200A）
      (rune >= 0x2000 && rune <= 0x200A) ||
      /// 行分隔符（0x2028）
      rune == 0x2028 ||
      /// 段分隔符（0x2029）
      rune == 0x2029 ||
      /// 窄不间断空格（0x202F）
      rune == 0x202F ||
      /// 中间数学空格（0x205F）
      rune == 0x205F ||
      /// 中文全角空格（0x3000）
      rune == 0x3000 ||
      /// 零宽不换行空格（0xFEFF）
      rune == 0xFEFF;

  /// 字符串填充
  String fillChar(String value, String char) {
    int offset = value.length - length;
    String newVal = this;
    if (offset > 0) {
      for (int i = 0; i < offset; i++) {
        newVal = char + newVal;
      }
    }
    return newVal;
  }
}
