import 'package:base/app.dart';
import 'package:base/log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_scale_provider.g.dart';

/// 字体缩放因子 [textScaleProvider]
///
/// ```dart
/// // get text scale
/// double textScale = $ref.read(textScaleProvider);
///
/// // change text scale
/// $ref.read(textScaleProvider.notifier).saveOrUpdate(1.5);
/// ```
@Riverpod(keepAlive: true, dependencies: [AppConfigProvider])
class TextScaleProvider extends _$TextScaleProvider {
  @override
  double build() => ref.read(appConfigProvider('textScale')).value ?? 1.0;

  /// 改变字体缩放
  Future<void> saveOrUpdate(double object, {bool isDebug = false}) async {
    if (!isDebug) {
      await ref
          .read(appConfigProvider('textScale').notifier)
          .saveOrUpdate(object);
      log.d(() => object);
    }
    state = object;
  }
}
