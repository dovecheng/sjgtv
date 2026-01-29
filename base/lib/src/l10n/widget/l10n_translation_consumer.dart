import 'package:base/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef L10nTranslationConsumerBuilder =
    Widget Function(
      BuildContext context,
      WidgetRef ref,
      L10nTranslationModel? translation,
      Widget? child,
    );

/// 国际化翻译控件
class L10nTranslationConsumer extends ConsumerWidget {
  final L10nTranslationConsumerBuilder? builder;
  final Widget? child;

  const L10nTranslationConsumer({
    super.key,
    required L10nTranslationConsumerBuilder this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => builder != null
      ? builder!(context, ref, ref.watch(l10nTranslationProvider).value, child)
      : child!;
}
