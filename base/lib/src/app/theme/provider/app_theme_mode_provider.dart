import 'package:base/app.dart';
import 'package:base/converter.dart';
import 'package:base/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme_mode_provider.g.dart';

/// 切换主题服务 [appThemeModeProvider]
@Riverpod(keepAlive: true, dependencies: [AppConfigProvider])
class AppThemeModeProvider extends _$AppThemeModeProvider
    with WidgetsBindingObserver {
  /// 状态栏模式
  SystemUiOverlayMode _systemUiOverlayMode = SystemUiOverlayMode.theme;

  /// 获取状态栏模式
  SystemUiOverlayMode get systemUiOverlayMode => _systemUiOverlayMode;

  @override
  Future<ThemeMode> build() async {
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });

    // 监听设备系统层面的主题模式变化
    WidgetsFlutterBinding.ensureInitialized().addObserver(this);

    // 禁用自动调整系统UI覆盖样式
    for (RenderView renderView in RendererBinding.instance.renderViews) {
      renderView.automaticSystemUiAdjustment = false;
    }

    // 初始化主题模式
    String? themeModeName =
        await ref.read(appConfigProvider('themeMode').future) as String?;

    ThemeMode themeMode =
        ThemeMode.values.byNameOrNull(themeModeName) ?? ThemeMode.system;

    setThemeMode(themeMode);

    return themeMode;
  }

  @override
  void didChangePlatformBrightness() {
    log.v(
      () =>
          'PlatformDispatcher.instance.platformBrightness=${PlatformDispatcher.instance.platformBrightness}',
    );
    // 监听设备在系统层面修改主题模式
    ThemeMode? themeMode = state.value;
    if (themeMode != null && themeMode == ThemeMode.system) {
      setThemeMode(themeMode);
    }
  }

  /// 改变系统UI覆盖样式
  Future<void> setSystemUiOverlayMode(
    SystemUiOverlayMode systemUiOverlayMode,
  ) async {
    log.v(() => '_systemUiOverlayMode=$systemUiOverlayMode');

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayMode.toStyle());

    if (_systemUiOverlayMode != systemUiOverlayMode) {
      _systemUiOverlayMode = systemUiOverlayMode;
      ref.notifyListeners();
    }
  }

  /// 改变主题模式
  Future<void> setThemeMode(ThemeMode themeMode) async {
    log.v(() => 'themeMode=${themeMode.toBrightness()}');

    state = const AsyncLoading();

    // 改变系统UI覆盖样式
    if (_systemUiOverlayMode == SystemUiOverlayMode.theme) {
      setSystemUiOverlayMode(_systemUiOverlayMode);
    }

    // 保存主题模式
    await ref
        .read(appConfigProvider('themeMode').notifier)
        .saveOrUpdate(themeMode.name);

    state = AsyncData(themeMode);
  }
}
