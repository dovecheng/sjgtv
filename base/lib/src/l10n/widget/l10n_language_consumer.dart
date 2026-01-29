import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base/l10n.dart';

typedef L10nLanguageConsumerBuilder =
    Widget Function(
      BuildContext context,
      WidgetRef ref,
      (L10nLanguageModel, Set<L10nLanguageModel>)? languages,
      Widget? child,
    );

/// 国际化语言控件
class L10nLanguageConsumer extends ConsumerWidget {
  final L10nLanguageConsumerBuilder? builder;
  final Widget? child;

  const L10nLanguageConsumer({
    super.key,
    required L10nLanguageConsumerBuilder this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => builder != null
      ? builder!(context, ref, ref.watch(l10nLanguageProvider).value, child)
      : child!;
}
