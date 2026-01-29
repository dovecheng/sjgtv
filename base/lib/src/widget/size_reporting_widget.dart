import 'package:flutter/material.dart';

/// 计算widget宽高
///
/// 源码:https://github.com/Limbou/expandable_page_view/blob/main/lib/src/size_reporting_widget.dart
class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  SizeReportingWidgetState createState() => SizeReportingWidgetState();
}

class SizeReportingWidgetState extends State<SizeReportingWidget> {
  final GlobalKey<State<StatefulWidget>> _widgetKey = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(key: _widgetKey, child: widget.child),
      ),
    );
  }

  void _notifySize() {
    BuildContext? context = _widgetKey.currentContext;
    if (context == null) return;
    Size? size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size!);
    }
  }
}
