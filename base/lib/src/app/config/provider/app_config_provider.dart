import 'dart:async';

import 'package:base/app.dart';
import 'package:base/converter.dart';
import 'package:base/log.dart';
import 'package:base/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_provider.g.dart';

/// 应用配置提供者 [appConfigProvider]
@Riverpod(keepAlive: true)
class AppConfigProvider extends _$AppConfigProvider {
  @override
  Future<dynamic> build(String key) => $isar.appConfig
      .getByKey(key)
      .then((AppConfigModel? model) => model?.value);

  /// 保存/更新配置
  Future<void> saveOrUpdate(Object? object) async {
    if (state.value == object) {
      log.d(() => 'skipped $key');
      return;
    }
    state = const AsyncLoading();
    try {
      await $isar.writeTxn(() async {
        if (object != null) {
          await $isar.appConfig.putByKey(AppConfigModel(key, object));
        } else {
          await $isar.appConfig.deleteByKey(key);
        }
        log.d(() => '$key=${JSONConverter.toJsonStringify(object)}');
      });
    } catch (e, s) {
      log.e(null, e, s);
    }
    state = AsyncData(object);
  }
}
