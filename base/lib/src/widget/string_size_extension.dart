import 'package:flutter/material.dart';

extension StringSizeExtension on String {
  /// 获取文字宽高
  Size sizeForStyle(
    BuildContext context, {
    required TextStyle style,
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
    String? ellipsis,
    TextAlign textAlign = TextAlign.start,
  }) {
    if (isEmpty) {
      return Size.zero;
    }

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: Localizations.localeOf(context),
      text: TextSpan(text: this, style: style),
      maxLines: maxLines,
      textScaler: MediaQuery.textScalerOf(context),
      ellipsis: ellipsis,
      textAlign: textAlign,
    )..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  /// 计算文本是否超出[maxLines]
  bool didExceedMaxLines(
    BuildContext context, {
    required TextStyle textStyle,
    required int maxLines,
    required double maxWidth,
    String? ellipsis,
    TextAlign textAlign = TextAlign.start,
  }) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: Localizations.localeOf(context),
      text: TextSpan(text: this, style: textStyle),
      maxLines: maxLines,
      textScaler: MediaQuery.textScalerOf(context),
      ellipsis: ellipsis,
      textAlign: textAlign,
    )..layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}
