import 'package:base/api.dart';
import 'package:base/app.dart';
import 'package:base/converter.dart';
import 'package:base/debug.dart';
import 'package:base/env.dart';
import 'package:base/extension.dart';
import 'package:base/log.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'debug_provider.g.dart';

/// 调试配置 [debugProvider]
@Riverpod(
  keepAlive: true,
  dependencies: [AppConfigProvider],
)
class DebugProvider extends _$DebugProvider {
  /// 进入调试页面的密码
  final String debugAuthCode;

  /// 调试配置 [debugProvider]
  ///
  /// * [debugAuthCode] 进入调试页面的密码
  DebugProvider({this.debugAuthCode = '28612282'});

  /// 预设
  DebugModel get preset => DebugModel(
    enable: !kReleaseMode,
    keepScreenOn: $platform.isIOSNative && !kReleaseMode,
    translateKeyTips: !kReleaseMode,
    demoMode: !kReleaseMode,
  );

  @override
  Future<DebugModel> build() async {
    // 监听自身变化启动定时器
    listenSelf((AsyncValue<DebugModel>? previous, AsyncValue<DebugModel> next) {
      log.d(() => 'listenSelf: $next');
      DebugModel? model = next.value;
      if (model != null) {
        // 请求代理地址+端口
        ref.read(apiClientProvider.notifier).proxy = model.proxy;

        // 切换屏幕常亮
        WakelockPlus.toggle(enable: model.keepScreenOn);

        // 设置动画慢放
        timeDilation = model.timeDilation;
      }
    });

    // 获取持久化保存的配置
    Map<String, dynamic>? json =
        await ref.read(appConfigProvider('debug').future)
            as Map<String, dynamic>?;
    DebugModel? model = json?.let(DebugModel.fromJson);
    model ??= preset;

    log.d(() => 'model=${JSONConverter.toJsonStringify(model)}');

    return model;
  }

  /// 重置配置
  Future<void> reset() async {
    state = const AsyncLoading();

    // 删除配置
    await ref.read(appConfigProvider('debug').notifier).saveOrUpdate(null);

    // 使用预设刷新状态
    state = AsyncData(preset);

    log.d(() => '重置');
  }

  /// 保存配置
  Future<void> saveOrUpdate(DebugModel object) async {
    state = const AsyncLoading();

    // 保存调试配置
    await ref
        .read(appConfigProvider('debug').notifier)
        .saveOrUpdate(object.toJson());

    // 刷新状态
    state = AsyncData(object);

    log.d(() => '保存');
  }

}
