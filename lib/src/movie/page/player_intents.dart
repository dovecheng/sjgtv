import 'package:flutter/widgets.dart';

/// 播放器键盘导航 Intent 定义
///
/// 用于 TV 遥控器和键盘控制视频播放器

/// 向上导航
class UpIntent extends Intent {
  const UpIntent();
}

/// 向下导航
class DownIntent extends Intent {
  const DownIntent();
}

/// 向左导航 / 快退
class LeftIntent extends Intent {
  const LeftIntent();
}

/// 向右导航 / 快进
class RightIntent extends Intent {
  const RightIntent();
}

/// 返回
class BackIntent extends Intent {
  const BackIntent();
}

/// 播放 / 暂停
class PlayPauseIntent extends Intent {
  const PlayPauseIntent();
}
