import 'dart:async';

import 'package:base/base.dart';
import 'package:flutter/foundation.dart';
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
    ?debug?.let((DebugProvider it) => debugProvider.overrideWith(() => it)),
    ?isar?.let((IsarProvider it) => isarProvider.overrideWith(() => it)),
    ?jsonAdapter?.let(
      (JsonAdapterProvider it) => jsonAdapterProvider.overrideWith(() => it),
    ),
    ?l10nLanguage?.let(
      (L10nLanguageProvider it) => l10nLanguageProvider.overrideWith(() => it),
    ),
    ?l10nTranslation?.let(
      (L10nTranslationProvider it) =>
          l10nTranslationProvider.overrideWith(() => it),
    ),
  ];

  /// 接口客户端
  @protected
  ApiClientProvider? get apiClient => null;

  /// 调试配置
  @protected
  DebugProvider? get debug => null;

  /// 渲染错误
  @protected
  ErrorWidgetBuilder? get errorBuilder => null;

  /// isar存储
  @protected
  IsarProvider? get isar => null;

  /// json转换
  @protected
  JsonAdapterProvider? get jsonAdapter => null;

  /// 国际化语言
  @protected
  L10nLanguageProvider? get l10nLanguage => null;

  /// 国际化翻译
  @protected
  L10nTranslationProvider? get l10nTranslation => null;

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
    // 监听器过滤指定提供者
    BaseProviderObserver().updateFilter.addAll({
      textScaleProvider,
    });

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
    // Json解析方法, 在调用接口前, 需要先初始化
    $ref.read(jsonAdapterProvider);
    // 调试/环境配置, 在调用接口前, 需要先初始化
    await $ref.read(debugProvider.future);

    // 国际化翻译
    $ref.read(l10nTranslationProvider);
    // 国际化语言
    $ref.read(l10nLanguageProvider);
    // 相对日期
    $ref.listen(l10nTimeagoProvider, (previous, next) {});

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
