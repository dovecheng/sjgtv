import 'package:base/text_scale.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef TextScaleConsumerBuilder =
    Widget Function(BuildContext context, double textScale, Widget? child);

/// 字体缩放控件
class TextScaleConsumer extends ConsumerWidget {
  final double minimumScale;

  final double maximumScale;

  final TextScaleConsumerBuilder? builder;

  final Widget? child;

  const TextScaleConsumer({
    super.key,
    this.builder,
    this.minimumScale = 1.0,
    this.maximumScale = 1.5,
    this.child,
  }) : assert(builder != null || child != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double textScale = ref.watch(textScaleProvider);
    textScale = textScale.clamp(minimumScale, maximumScale);
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: builder != null ? builder!(context, textScale, child) : child!,
    );
  }
}
