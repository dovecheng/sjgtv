import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:base/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// 应用更新检查器
///
/// 功能：
/// - 从 GitHub Releases 检查最新版本
/// - 比较当前版本与最新版本
/// - 显示更新对话框（含更新说明）
/// - 支持自动下载 APK 并安装（Android）
/// - 支持手动跳转到 GitHub 下载页
abstract final class AppUpdater {
  static final Log _log = Log('AppUpdater');
  static final Dio _dio = Dio();
  static const String _githubReleasesUrl =
      'https://api.github.com/repos/dovecheng/sjgtv/releases/latest';

  static bool _isDownloading = false;
  static double _downloadProgress = 0;
  static CancelToken? _cancelToken;

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      final Response<dynamic> response = await _dio.get<dynamic>(_githubReleasesUrl);
      final dynamic latestRelease = response.data;

      // 检查响应是否有效
      if (latestRelease == null || latestRelease['tag_name'] == null) {
        _log.d(() => '检查更新: 无有效的发布版本');
        return;
      }

      final String latestVersion = latestRelease['tag_name'].replaceAll('v', '');
      final String releaseUrl = latestRelease['html_url'];
      final String? releaseNotes = latestRelease['body'];
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

  static String? _findApkDownloadUrl(List<dynamic> assets) {
    for (final dynamic asset in assets) {
      if (asset['name'].toString().endsWith('.apk')) {
        return asset['browser_download_url'];
      }
    }
    return null;
  }

  static int _compareVersions(String current, String latest) {
    final List<int> currentParts = current.split('.').map(int.parse).toList();
    final List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (var i = 0; i < 3; i++) {
      final int currentPart = i < currentParts.length ? currentParts[i] : 0;
      final int latestPart = i < latestParts.length ? latestParts[i] : 0;

      if (currentPart < latestPart) return -1;
      if (currentPart > latestPart) return 1;
    }
    return 0;
  }

  static void _showUpdateDialog(
    BuildContext context,
    String url,
    String version,
    String notes, {
    String? apkUrl,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('发现新版本 v$version'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('更新内容:'),
                  const SizedBox(height: 8),
                  Text(notes.isNotEmpty ? notes : '暂无更新说明'),
                  if (_isDownloading) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '下载中: ${(_downloadProgress * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              if (!_isDownloading) ...[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('稍后再说'),
                ),
                if (apkUrl != null)
                  TextButton(
                    onPressed: () =>
                        _downloadAndInstallApk(context, apkUrl, setState),
                    child: const Text('自动更新'),
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
                  child: const Text('手动更新'),
                ),
              ] else ...[
                TextButton(
                  onPressed: _cancelDownload,
                  child: const Text('取消下载'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  static Future<void> _downloadAndInstallApk(
    BuildContext context,
    String apkUrl,
    StateSetter setState,
  ) async {
    try {
      // 请求存储权限
      final PermissionStatus status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('需要存储权限才能下载更新')));
        }
        return;
      }

      // 请求安装未知来源应用的权限
      if (Platform.isAndroid) {
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
        Navigator.pop(context);
      }

      // 安装APK
      if (Platform.isAndroid) {
        await _installApk(savePath);
      }
    } catch (e) {
      _log.e(() => '下载失败', e);
      setState(() {
        _isDownloading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('下载失败: ${e.toString()}')));
      }
    }
  }

  static Future<void> _installApk(String apkPath) async {
    if (await File(apkPath).exists()) {
      try {
        if (Platform.isAndroid) {
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

  static void _cancelDownload() {
    _cancelToken?.cancel('用户取消下载');
    _isDownloading = false;
    _downloadProgress = 0;
  }
}
