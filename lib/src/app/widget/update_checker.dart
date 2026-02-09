import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:sjgtv/core/converter/converter.dart';
import 'package:sjgtv/core/extension/extension.dart';
import 'package:sjgtv/core/log/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sjgtv/l10n_gen/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// 应用更新检查器（单例）
///
/// 功能：
/// - 从 GitHub Releases 检查最新版本
/// - 比较当前版本与最新版本（支持 26.02.02+2 主版本+build 号）
/// - 显示更新对话框（含更新说明）
/// - 支持自动下载 APK 并安装（Android）
/// - 支持手动跳转到 GitHub 发布页
class AppUpdater {
  AppUpdater._();

  static final AppUpdater instance = AppUpdater._();

  final Log _log = Log('AppUpdater');
  final Dio _dio = Dio();
  static const String _githubReleasesUrl =
      'https://api.github.com/repos/dovecheng/sjgtv/releases/latest';

  bool _isDownloading = false;
  double _downloadProgress = 0;
  CancelToken? _cancelToken;

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.buildNumber.isNotEmpty
          ? '${packageInfo.version}+${packageInfo.buildNumber}'
          : packageInfo.version;

      final Response<dynamic> response = await _dio.get<dynamic>(_githubReleasesUrl);
      final dynamic latestRelease = response.data;

      // 检查响应是否有效
      if (latestRelease == null || latestRelease['tag_name'] == null) {
        _log.d(() => '检查更新: 无有效的发布版本');
        return;
      }

      final String tagName = latestRelease['tag_name'] as String;
      final String latestVersion = tagName.replaceAll('v', '').trim();
      final String releaseUrl = latestRelease['html_url'] as String;
      final String? releaseNotes = latestRelease['body'] as String?;
      final String? apkUrl = _findApkDownloadUrl(latestRelease['assets'] ?? []);

      if (_compareVersions(currentVersion, latestVersion) < 0 &&
          context.mounted) {
        _showUpdateDialog(
          context,
          releaseUrl,
          latestVersion,
          releaseNotes ?? '',
          apkUrl: apkUrl,
        );
      }
    } on DioException catch (e) {
      // 404 表示没有发布版本，静默处理
      if (e.response?.statusCode == 404) {
        _log.d(() => '检查更新: 仓库暂无发布版本');
        return;
      }
      _log.e(() => '检查更新失败', e);
    } catch (e) {
      _log.e(() => '检查更新失败', e);
    }
  }

  String? _findApkDownloadUrl(List<dynamic> assets) {
    for (final dynamic asset in assets) {
      if (asset['name']?.toString().endsWith('.apk') ?? false) {
        return asset['browser_download_url'] as String?;
      }
    }
    return null;
  }

  /// 解析版本号，支持 26.02.02+2 格式（主版本 + build 号）
  List<int> _parseVersion(String version) {
    final String raw = version.replaceAll('v', '').trim();
    final List<String> mainAndBuild = raw.split('+');
    final String mainPart = mainAndBuild[0].trim();
    final String buildPart =
        mainAndBuild.length > 1 ? mainAndBuild[1].trim() : '0';
    final List<int> mainParts = mainPart
        .split('.')
        .map((String e) => IntConverter.toIntOrZero(e))
        .toList();
    mainParts.add(IntConverter.toIntOrZero(buildPart));
    return mainParts;
  }

  int _compareVersions(String current, String latest) {
    final List<int> currentParts = _parseVersion(current);
    final List<int> latestParts = _parseVersion(latest);
    final int maxLen = currentParts.length > latestParts.length
        ? currentParts.length
        : latestParts.length;

    for (var i = 0; i < maxLen; i++) {
      final int currentPart = i < currentParts.length ? currentParts[i] : 0;
      final int latestPart = i < latestParts.length ? latestParts[i] : 0;

      if (currentPart < latestPart) return -1;
      if (currentPart > latestPart) return 1;
  }
    return 0;
  }

  void _showUpdateDialog(
    BuildContext context,
    String url,
    String version,
    String notes, {
    String? apkUrl,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          final AppLocalizations l10n = AppLocalizations.of(context);
          final ThemeData theme = Theme.of(context);
          final ColorScheme colorScheme = theme.colorScheme;
          final TextTheme textTheme = theme.textTheme;
          return AlertDialog(
            title: Text(
              '${l10n.updateCheckerNewVersionTitle} v$version',
              style: textTheme.titleLarge,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.updateCheckerUpdateContent, style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text(
                    notes.isNotEmpty ? notes : l10n.updateCheckerNoNotes,
                    style: textTheme.bodyMedium,
                  ),
                  if (_isDownloading) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.updateCheckerDownloading}: ${(_downloadProgress * 100).toStringAsFixed(1)}%',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              if (!_isDownloading) ...[
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.updateCheckerLater),
                ),
                if ($platform.isAndroidNative && apkUrl != null)
                  TextButton(
                    onPressed: () =>
                        _downloadAndInstallApk(context, apkUrl, setState),
                    child: Text(l10n.updateCheckerAutoUpdate),
                  ),
                TextButton(
                  onPressed: () async {
                    context.pop();
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(l10n.updateCheckerManualUpdate),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => _cancelDownload(l10n.updateCheckerUserCancelDownload),
                  child: Text(l10n.updateCheckerCancelDownload),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _downloadAndInstallApk(
    BuildContext context,
    String apkUrl,
    StateSetter setState,
  ) async {
    if (!$platform.isAndroidNative) return;
    try {
      // 请求存储权限
      final PermissionStatus status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          final String msg = AppLocalizations.of(context).updateCheckerStorageRequired;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
        return;
      }

      // 请求安装未知来源应用的权限
      if ($platform.isAndroidNative) {
        if (!await Permission.requestInstallPackages.isGranted) {
          await Permission.requestInstallPackages.request();
        }
      }

      setState(() {
        _isDownloading = true;
        _downloadProgress = 0;
      });

      _cancelToken = CancelToken();
      final Directory dir = await getTemporaryDirectory();
      final String savePath =
          '${dir.path}/update_${DateTime.now().millisecondsSinceEpoch}.apk';

      await _dio.download(
        "https://proxy.aini.us.kg/$apkUrl",
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        _isDownloading = false;
      });

      if (context.mounted) {
        context.pop();
      }

      // 安装APK
      if ($platform.isAndroidNative) {
        await _installApk(savePath);
      }
    } catch (e) {
      _log.e(() => '下载失败', e);
      setState(() {
        _isDownloading = false;
      });

      if (context.mounted) {
        final String msg = AppLocalizations.of(context).updateCheckerDownloadFail;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$msg: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _installApk(String apkPath) async {
    if (await File(apkPath).exists()) {
      try {
        if ($platform.isAndroidNative) {
          final AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            type: 'application/vnd.android.package-archive',
            data: Uri.file(apkPath).toString(), // 使用 Uri.file 替代 Uri.fromFile
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();
        }
      } catch (e) {
        _log.e(() => '安装失败', e);
        // 如果使用intent失败，尝试使用open_file
        await OpenFile.open(apkPath);
      }
    }
  }

  void _cancelDownload(String message) {
    _cancelToken?.cancel(message);
    _isDownloading = false;
    _downloadProgress = 0;
  }
}
