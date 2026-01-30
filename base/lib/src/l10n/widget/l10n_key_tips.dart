import 'package:base/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO(wy): 2024-07-17 开启【translateKeyTips】并切【L10nKeyTips】下面包含输入框的情况下，输入框的焦点有问题

/// 国际化Key提示控件
class L10nKeyTips extends ConsumerStatefulWidget {
  @visibleForTesting
  static final Log log = (L10nKeyTips).log;

  final String? keyTips;

  final Widget child;

  static L10nKeyTipsState of(BuildContext context) => maybeOf(context)!;

  static L10nKeyTipsState? maybeOf(BuildContext context) {
    L10nKeyTipsState? state = context
        .findAncestorStateOfType<L10nKeyTipsState>();
    log.d(() => state);
    return state;
  }

  const L10nKeyTips({super.key, required this.keyTips, required this.child});

  factory L10nKeyTips.multiline({
    Key? key,
    required Iterable<String> keyTips,
    required Widget child,
  }) => L10nKeyTips(
    key: key,
    keyTips: keyTips.isNotEmpty ? keyTips.join('\n') : null,
    child: child,
  );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => L10nKeyTipsState();
}

class L10nKeyTipsState extends ConsumerState<L10nKeyTips> {
  final GlobalKey<TooltipState> tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool enable = widget.keyTips?.isNotEmpty == true;
    if (!enable) {
      return widget.child;
    }
    return GestureDetector(
      onLongPress: ensureTooltipVisible,
      onDoubleTap: ensureTooltipVisible,
      child: Tooltip(
        key: tooltipKey,
        triggerMode: TooltipTriggerMode.manual,
        message: widget.keyTips!,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.white38),
        ),
        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
        child: widget.child,
      ),
    );
  }

  Future<void> ensureTooltipVisible([bool copy = true]) async {
    if (copy) {
      await Clipboard.setData(ClipboardData(text: widget.keyTips!));
    }
    tooltipKey.currentState?.ensureTooltipVisible();
  }
}
