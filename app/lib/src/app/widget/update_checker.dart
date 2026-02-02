import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:base/base.dart';
import 'package:dio/dio.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sjgtv/src/app/widget/l10n/update_checker_l10n.gen.dart';
import 'package:url_launcher/url_launcher.dart';

/// 应用更新检查器（单例，混入 [UpdateCheckerL10nMixin] 使用 l10n）
///
/// 功能：
/// - 从 GitHub Releases 检查最新版本
/// - 比较当前版本与最新版本（支持 26.02.02+2 主版本+build 号）
/// - 显示更新对话框（含更新说明）
/// - 支持自动下载 APK 并安装（Android）
/// - 支持手动跳转到 GitHub tag 发布页
class AppUpdater with UpdateCheckerL10nMixin implements UpdateCheckerL10n {
  AppUpdater._();

  static final AppUpdater instance = AppUpdater._();

  final Dio _dio = Dio();
  static const String _githubReleasesUrl =
      'https://api.github.com/repos/dovecheng/sjgtv/releases/latest';
  static const String _githubReleasesTagBase =
      'https://github.com/dovecheng/sjgtv/releases/tag/';

  bool _isDownloading = false;
  double _downloadProgress = 0;
  CancelToken? _cancelToken;

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // PackageInfo.version 不含 + 后内容，需与 buildNumber 拼接后再与远程 tag（如 26.02.02+2）比较
      final String currentVersion = packageInfo.buildNumber.isNotEmpty
          ? '${packageInfo.version}+${packageInfo.buildNumber}'
          : packageInfo.version;

      final Response<dynamic> response =
          await _dio.get<dynamic>(_githubReleasesUrl);
      final dynamic latestRelease = response.data;

      if (latestRelease == null || latestRelease['tag_name'] == null) {
        log.d(() => '检查更新: 无有效的发布版本');
        return;
      }

      final String tagName = latestRelease['tag_name'] as String;
      final String latestVersion = tagName.replaceAll('v', '').trim();
      final String releaseUrl = '$_githubReleasesTagBase$tagName';
      final String? releaseNotes = latestRelease['body'] as String?;
      final String? apkUrl = _findApkDownloadUrl(latestRelease['assets'] ?? []);

      final bool hasUpdate = _isNewerVersion(latestVersion, currentVersion);
      if (hasUpdate && context.mounted) {
        _showUpdateDialog(
          context,
          releaseUrl,
          latestVersion,
          releaseNotes ?? '',
          apkUrl: apkUrl,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        log.d(() => '检查更新: 仓库暂无发布版本');
        return;
      }
      log.e(() => '检查更新失败', e);
    } catch (e) {
      log.e(() => '检查更新失败', e);
    }
  }

  /// 比较版本字符串（支持 26.02.02+4 格式），返回 [latestVersion] 是否比 [currentVersion] 新。
  /// 显式解析主版本与 build 号，避免依赖 pub_semver 对 build 的排序差异。
  bool _isNewerVersion(String latestVersion, String currentVersion) {
    final List<String> curParts = currentVersion.split('+');
    final List<String> latParts = latestVersion.split('+');
    final String curBase = curParts[0].trim();
    final String latBase = latParts[0].trim();
    final int curBuild = curParts.length > 1 ? int.tryParse(curParts[1].trim()) ?? 0 : 0;
    final int latBuild = latParts.length > 1 ? int.tryParse(latParts[1].trim()) ?? 0 : 0;

    final Version curV = Version.parse(curBase);
    final Version latV = Version.parse(latBase);
    if (curV.compareTo(latV) != 0) {
      return curV.compareTo(latV) < 0;
    }
    return curBuild < latBuild;
  }

  String? _findApkDownloadUrl(List<dynamic> assets) {
    for (final dynamic asset in assets) {
      if (asset['name']?.toString().endsWith('.apk') ?? false) {
        return asset['browser_download_url'];
      }
    }
    return null;
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
          final ThemeData theme = Theme.of(context);
          final ColorScheme colorScheme = theme.colorScheme;
          final TextTheme textTheme = theme.textTheme;
          return AlertDialog(
            title: Text(
              '$newVersionTitleL10n v$version',
              style: textTheme.titleLarge,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(updateContentL10n, style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text(
                    notes.isNotEmpty ? notes : noNotesL10n,
                    style: textTheme.bodyMedium,
                  ),
                  if (_isDownloading) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$downloadingL10n: ${(_downloadProgress * 100).toStringAsFixed(1)}%',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              if (!_isDownloading) ...[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(laterL10n),
                ),
                if ($platform.isAndroidNative && apkUrl != null)
                  TextButton(
                    onPressed: () =>
                        _downloadAndInstallApk(context, apkUrl, setState),
                    child: Text(autoUpdateL10n),
                  ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(manualUpdateL10n),
                ),
              ] else ...[
                TextButton(
                  onPressed: _cancelDownload,
                  child: Text(cancelDownloadL10n),
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
      final PermissionStatus status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(storageRequiredL10n)),
          );
        }
        return;
      }

      if ($platform.isAndroidNative) {
        if (!await Permission.requestInstallPackages.isGranted) {
          await Permission.requestInstallPackages.request();
          if (!await Permission.requestInstallPackages.isGranted) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(installPermissionRequiredL10n)),
              );
            }
            return;
          }
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
        'https://proxy.aini.us.kg/$apkUrl',
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
        Navigator.pop(context);
      }

      if ($platform.isAndroidNative) {
        if (!await Permission.requestInstallPackages.isGranted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(installPermissionRequiredL10n)),
            );
          }
          return;
        }
        if (context.mounted) {
          await _installApk(context, savePath);
        }
      }
    } catch (e) {
      log.e(() => '下载失败', e);
      setState(() {
        _isDownloading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$downloadFailL10n: ${e.toString()}')),
        );
      }
    }
  }

  /// 安装 APK。Android 7+ 必须通过 FileProvider 提供 content URI，不能使用 file://，
  /// 故优先使用 [OpenFile.open]（内部使用 FileProvider），失败时再尝试 [AndroidIntent]。
  Future<void> _installApk(BuildContext? context, String apkPath) async {
    if (!await File(apkPath).exists()) return;
    if (!$platform.isAndroidNative) return;
    try {
      final OpenResult result = await OpenFile.open(apkPath);
      if (result.type != ResultType.done &&
          context != null &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.message.isEmpty ? installFailL10n : result.message,
            ),
          ),
        );
      }
    } catch (e) {
      log.e(() => '安装失败', e);
      try {
        final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          type: 'application/vnd.android.package-archive',
          data: Uri.file(apkPath).toString(),
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      } catch (e2) {
        log.e(() => '安装失败（备用 intent）', e2);
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$installFailL10n: ${e.toString()}')),
          );
        }
      }
    }
  }

  void _cancelDownload() {
    _cancelToken?.cancel(userCancelDownloadL10n);
    _isDownloading = false;
    _downloadProgress = 0;
  }
}
