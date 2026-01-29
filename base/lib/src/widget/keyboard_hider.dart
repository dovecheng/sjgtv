import 'package:base/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 隐藏键盘方式
enum KeyboardHideMode {
  /// 取消焦点
  unfocus,

  /// 仅隐藏键盘
  hideTextInput,
}

/// 点击空白区域隐藏键盘
class KeyboardHider extends StatelessWidget {
  final KeyboardHideMode mode;
  final Widget child;

  /// 点击空白区域隐藏键盘
  const KeyboardHider({
    super.key,
    required this.child,
    this.mode = KeyboardHideMode.unfocus,
  });

  @override
  Widget build(BuildContext context) {
    // return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        log.v(() => 'onTap: Removes focus in ${mode.name} mode');
        switch (mode) {
          case KeyboardHideMode.unfocus:
            return unfocus();
          case KeyboardHideMode.hideTextInput:
            return hideTextInput();
        }
      },
      child: child,
    );
  }

  /// 取消焦点方式隐藏键盘
  static void unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  /// 保留焦点方式隐藏键盘
  static Future<void> hideTextInput() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');
}
