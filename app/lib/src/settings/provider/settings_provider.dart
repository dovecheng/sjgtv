import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/domain/usecases/get_settings_usecase.dart';
import 'package:sjgtv/domain/usecases/save_settings_usecase.dart';
import 'package:sjgtv/domain/entities/settings.dart';
import 'package:sjgtv/di/domain_di.dart';

part 'settings_provider.g.dart';

/// 设置提供者
@Riverpod(keepAlive: true)
class SettingsProvider extends _$SettingsProvider {
  @override
  Future<Settings> build() async {
    final result = await ref.read(getSettingsUseCaseProvider).call();
    return result.fold(
      (failure) => Settings(
        uuid: 'default',
        defaultVolume: 100.0,
        defaultPlaybackSpeed: 1.0,
        autoPlayNext: true,
        themeMode: AppThemeMode.system,
        language: 'zh_CN',
      ),
      (settings) => settings,
    );
  }

  /// 保存设置
  Future<void> saveSettings(Settings settings) async {
    final result = await ref.read(saveSettingsUseCaseProvider).call(settings);
    result.fold(
      (failure) {},
      (savedSettings) => state = AsyncValue.data(savedSettings),
    );
  }

  /// 更新默认音量
  Future<void> updateDefaultVolume(double volume) async {
    final currentSettings = state.value ?? Settings(
      uuid: 'default',
      defaultVolume: 100.0,
      defaultPlaybackSpeed: 1.0,
      autoPlayNext: true,
      themeMode: AppThemeMode.system,
      language: 'zh_CN',
    );
    final updated = currentSettings.copyWith(
      defaultVolume: volume.clamp(0.0, 100.0),
    );
    await saveSettings(updated);
  }

  /// 更新默认播放速度
  Future<void> updateDefaultPlaybackSpeed(double speed) async {
    final currentSettings = state.value ?? Settings(
      uuid: 'default',
      defaultVolume: 100.0,
      defaultPlaybackSpeed: 1.0,
      autoPlayNext: true,
      themeMode: AppThemeMode.system,
      language: 'zh_CN',
    );
    final updated = currentSettings.copyWith(
      defaultPlaybackSpeed: speed.clamp(0.5, 2.0),
    );
    await saveSettings(updated);
  }

  /// 切换自动播放下一集
  Future<void> toggleAutoPlayNext() async {
    final currentSettings = state.value ?? Settings(
      uuid: 'default',
      defaultVolume: 100.0,
      defaultPlaybackSpeed: 1.0,
      autoPlayNext: true,
      themeMode: AppThemeMode.system,
      language: 'zh_CN',
    );
    final updated = currentSettings.copyWith(
      autoPlayNext: !currentSettings.autoPlayNext,
    );
    await saveSettings(updated);
  }

  /// 更新主题模式
  Future<void> updateThemeMode(AppThemeMode mode) async {
    final currentSettings = state.value ?? Settings(
      uuid: 'default',
      defaultVolume: 100.0,
      defaultPlaybackSpeed: 1.0,
      autoPlayNext: true,
      themeMode: AppThemeMode.system,
      language: 'zh_CN',
    );
    final updated = currentSettings.copyWith(
      themeMode: mode,
    );
    await saveSettings(updated);
  }

  /// 更新语言
  Future<void> updateLanguage(String language) async {
    final currentSettings = state.value ?? Settings(
      uuid: 'default',
      defaultVolume: 100.0,
      defaultPlaybackSpeed: 1.0,
      autoPlayNext: true,
      themeMode: AppThemeMode.system,
      language: 'zh_CN',
    );
    final updated = currentSettings.copyWith(
      language: language,
    );
    await saveSettings(updated);
  }
}