import 'dart:math';

import 'package:flutter/material.dart';
import 'package:base/base.dart';

/// copy自 https://github.com/LanarsInc/top-snackbar-flutter/blob/main/lib/custom_snack_bar.dart
///
/// Popup widget that you can use by default to show some information
class CustomSnackBar extends StatefulWidget {
  /// 消息
  final String message;

  /// 消息的Key提示
  final String? messageKey;

  final Widget icon;

  final Color backgroundColor;

  final TextStyle textStyle;

  final int iconRotationAngle;

  const CustomSnackBar.error({
    super.key,
    required this.message,
    this.messageKey,
    this.icon = const Icon(
      Icons.error_outline,
      color: Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.backgroundColor = const Color(0xffff5252),
  });

  const CustomSnackBar.info({
    super.key,
    required this.message,
    this.messageKey,
    this.icon = const Icon(
      Icons.sentiment_neutral,
      color: Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.backgroundColor = const Color(0xff2196F3),
  });

  const CustomSnackBar.success({
    super.key,
    required this.message,
    this.messageKey,
    this.icon = const Icon(
      Icons.sentiment_very_satisfied,
      color: Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.backgroundColor = const Color(0xff00E676),
  });

  @override
  State<CustomSnackBar> createState() => CustomSnackBarState();
}

class CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = context.themeData;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 8),
            spreadRadius: 1,
            blurRadius: 30,
          ),
        ],
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: -10,
            left: -8,
            child: ClipRRect(
              child: SizedBox(
                height: 95,
                child: Transform.rotate(
                  angle: widget.iconRotationAngle * pi / 180,
                  child: widget.icon,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: L10nKeyTips(
                keyTips: widget.messageKey,
                child: Text(
                  widget.message,
                  style: theme.textTheme.bodyMedium?.merge(widget.textStyle),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
