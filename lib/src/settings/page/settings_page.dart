import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/core/core.dart';
import 'package:sjgtv/domain/entities/settings.dart';
import 'package:sjgtv/l10n_gen/app_localizations.dart';
import 'package:sjgtv/src/settings/provider/settings_provider.dart';

/// 设置页面
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 播放设置
              _buildSectionHeader(l10n.playbackSettings),
              _buildVolumeTile(context, ref, settings, l10n),
              _buildPlaybackSpeedTile(context, ref, settings, l10n),
              _buildAutoPlayNextTile(context, ref, settings, l10n),

              const SizedBox(height: 24),

              // 显示设置
              _buildSectionHeader(l10n.displaySettings),
              _buildThemeModeTile(context, ref, settings, l10n),
              _buildLanguageTile(context, ref, settings, l10n),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text('加载失败', style: textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildVolumeTile(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    AppLocalizations l10n,
  ) {
    return ListTile(
      leading: const Icon(Icons.volume_up),
      title: Text(l10n.defaultVolume),
      subtitle: Slider(
        value: settings.defaultVolume,
        min: 0,
        max: 100,
        divisions: 10,
        label: '${settings.defaultVolume.toInt()}%',
        onChanged: (value) {
          ref.read(settingsProvider.notifier).updateDefaultVolume(value);
        },
      ),
      trailing: Text(
        '${settings.defaultVolume.toInt()}%',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildPlaybackSpeedTile(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    AppLocalizations l10n,
  ) {
    return ListTile(
      leading: const Icon(Icons.speed),
      title: Text(l10n.defaultPlaybackSpeed),
      subtitle: Slider(
        value: settings.defaultPlaybackSpeed,
        min: 0.5,
        max: 2.0,
        divisions: 3,
        label: '${settings.defaultPlaybackSpeed}x',
        onChanged: (value) {
          ref.read(settingsProvider.notifier).updateDefaultPlaybackSpeed(value);
        },
      ),
      trailing: Text(
        '${settings.defaultPlaybackSpeed}x',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildAutoPlayNextTile(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    AppLocalizations l10n,
  ) {
    return SwitchListTile(
      secondary: const Icon(Icons.play_circle_outline),
      title: Text(l10n.autoPlayNext),
      subtitle: Text(l10n.autoPlayNextDescription),
      value: settings.autoPlayNext,
      onChanged: (value) {
        ref.read(settingsProvider.notifier).toggleAutoPlayNext();
      },
    );
  }

  Widget _buildThemeModeTile(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    AppLocalizations l10n,
  ) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: Text(l10n.themeMode),
      subtitle: Text(_getThemeModeText(settings.themeMode, l10n)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeModeDialog(context, ref, settings, l10n),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    AppLocalizations l10n,
  ) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(_getLanguageText(settings.language, l10n)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageDialog(context, ref, settings, l10n),
    );
  }

  String _getThemeModeText(AppThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case AppThemeMode.light:
        return l10n.themeLight;
      case AppThemeMode.dark:
        return l10n.themeDark;
      case AppThemeMode.system:
        return l10n.themeSystem;
    }
  }

  String _getLanguageText(String language, AppLocalizations l10n) {
    switch (language) {
      case 'zh_CN':
        return '简体中文';
      case 'en':
        return 'English';
      case 'zh_HK':
        return '繁體中文';
      default:
        return language;
    }
  }

  void _showThemeModeDialog(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.themeMode),
          content: RadioGroup<AppThemeMode>(
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).updateThemeMode(value);
                Navigator.pop(context);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppThemeMode.values.map((mode) {
                return ListTile(
                  title: Text(_getThemeModeText(mode, l10n)),
                  leading: Radio<AppThemeMode>(value: mode),
                  onTap: () {
                    ref.read(settingsProvider.notifier).updateThemeMode(mode);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    AppLocalizations l10n,
  ) {
    final languages = [
      {'code': 'zh_CN', 'name': '简体中文'},
      {'code': 'en', 'name': 'English'},
      {'code': 'zh_HK', 'name': '繁體中文'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.language),
          content: RadioGroup<String>(
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).updateLanguage(value);
                Navigator.pop(context);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                return ListTile(
                  title: Text(lang['name']!),
                  leading: Radio<String>(value: lang['code']!),
                  onTap: () {
                    ref
                        .read(settingsProvider.notifier)
                        .updateLanguage(lang['code']!);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}
