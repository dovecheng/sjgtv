import 'dart:async';

import 'package:sjgtv/core/core.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// 应用启动和初始化配置
abstract base class AppRunner {
  /// 覆盖提供者
  late final List<Override> _overrides = <Override>[
    ?apiClient?.let(
      (ApiClientProvider it) => apiClientProvider.overrideWith(() => it),
    ),
    ?isar?.let((IsarProvider it) => isarProvider.overrideWith(() => it)),
  ];

  /// 接口客户端
  @protected
  ApiClientProvider? get apiClient => null;

  /// 渲染错误
  @protected
  ErrorWidgetBuilder? get errorBuilder => null;

  /// isar存储
  @protected
  IsarProvider? get isar => null;

  /// 预设屏幕方向
  List<DeviceOrientation> get preferredOrientations => const [
    DeviceOrientation.portraitUp,
  ];

  @protected
  FutureOr<Widget> buildApp();

  @protected
  @mustCallSuper
  Future<void> init() async {
    initFlutter();
    await initProvider();
  }

  @protected
  @mustCallSuper
  void initFlutter() {
    log.d(() => 'start');
    // 平台通道需要预初始化
    WidgetsFlutterBinding.ensureInitialized();

    // 强制竖屏
    SystemChrome.setPreferredOrientations(preferredOrientations);

    // 异常捕获输出日志
    ErrorWidgetBuilder? builder = errorBuilder;
    if (builder != null) {
      ErrorWidget.builder = builder;
    }
    FlutterError.onError = onError;
    log.d(() => 'end');
  }

  /// 初始化提供者
  @protected
  @mustCallSuper
  Future<void> initProvider() async {
    log.d(() => 'start');

    // 覆盖提供者
    log.d(() => 'overrides start');
    configRef(overrides: _overrides);
    log.d(() => 'overrides ${_overrides.length}');
    log.d(() => 'overrides end');

    // 不支持Web平台的提供者
    if (!kIsWeb) {
      // 本地数据库, 在读取配置前, 需要先初始化
      await $ref.read(isarProvider.future);
    }

    // 接口请求配置, 在调用接口前, 需要先初始化
    $ref.read(apiClientProvider);
    // timeago 文案语言, 在 formatTimeAgo 前需要先初始化
    $ref.read(l10nTimeagoProvider);

    log.d(() => 'end');
  }

  Future<void> launchApp() async {
    await init();

    runApp(UncontrolledProviderScope(container: $ref, child: await buildApp()));
  }

  @protected
  /// Flutter异常
  void onError(FlutterErrorDetails details) =>
      log.e(() => '$details', details.exception, details.stack);
}
