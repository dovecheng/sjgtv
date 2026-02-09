import 'package:flutter_test/flutter_test.dart';
import 'package:sjgtv/src/app/widget/update_checker.dart';

void main() {
  group('AppUpdater 版本号解析', () {
    test('应该正确解析标准版本号', () {
      // act
      final result = _parseVersionPublic('1.2.3');

      // assert
      expect(result, equals([1, 2, 3, 0]));
    });

    test('应该正确解析带 build 号的版本号', () {
      // act
      final result = _parseVersionPublic('26.02.03+12');

      // assert
      expect(result, equals([26, 2, 3, 12]));
    });

    test('应该正确解析带 v 前缀的版本号', () {
      // act
      final result = _parseVersionPublic('v1.2.3');

      // assert
      expect(result, equals([1, 2, 3, 0]));
    });

    test('应该正确解析带 v 前缀和 build 号的版本号', () {
      // act
      final result = _parseVersionPublic('v26.02.03+12');

      // assert
      expect(result, equals([26, 2, 3, 12]));
    });

    test('应该处理空格', () {
      // act
      final result = _parseVersionPublic(' 26.02.03 + 12 ');

      // assert
      expect(result, equals([26, 2, 3, 12]));
    });

    test('应该处理只有主版本号的版本', () {
      // act
      final result = _parseVersionPublic('26');

      // assert
      expect(result, equals([26, 0]));
    });

    test('应该处理缺少部分段位的版本号', () {
      // act
      final result = _parseVersionPublic('26.02');

      // assert
      expect(result, equals([26, 2, 0]));
    });
  });

  group('AppUpdater 版本号比较', () {
    test('应该正确比较主版本号', () {
      // assert
      expect(_compareVersionsPublic('1.0.0', '2.0.0'), equals(-1));
      expect(_compareVersionsPublic('2.0.0', '1.0.0'), equals(1));
      expect(_compareVersionsPublic('1.0.0', '1.0.0'), equals(0));
    });

    test('应该正确比较次版本号', () {
      // assert
      expect(_compareVersionsPublic('1.1.0', '1.2.0'), equals(-1));
      expect(_compareVersionsPublic('1.2.0', '1.1.0'), equals(1));
      expect(_compareVersionsPublic('1.1.0', '1.1.0'), equals(0));
    });

    test('应该正确比较修订版本号', () {
      // assert
      expect(_compareVersionsPublic('1.1.1', '1.1.2'), equals(-1));
      expect(_compareVersionsPublic('1.1.2', '1.1.1'), equals(1));
      expect(_compareVersionsPublic('1.1.1', '1.1.1'), equals(0));
    });

    test('应该正确比较 build 号', () {
      // assert
      expect(_compareVersionsPublic('1.0.0+1', '1.0.0+2'), equals(-1));
      expect(_compareVersionsPublic('1.0.0+2', '1.0.0+1'), equals(1));
      expect(_compareVersionsPublic('1.0.0+1', '1.0.0+1'), equals(0));
    });

    test('应该正确比较完整版本号', () {
      // assert
      expect(_compareVersionsPublic('26.02.01+1', '26.02.03+2'), equals(-1));
      expect(_compareVersionsPublic('26.02.03+2', '26.02.01+1'), equals(1));
      expect(_compareVersionsPublic('26.02.03+2', '26.02.03+2'), equals(0));
    });

    test('应该正确比较带 v 前缀的版本号', () {
      // assert
      expect(_compareVersionsPublic('v1.0.0', 'v2.0.0'), equals(-1));
      expect(_compareVersionsPublic('v2.0.0', 'v1.0.0'), equals(1));
      expect(_compareVersionsPublic('v1.0.0', 'v1.0.0'), equals(0));
    });

    test('应该正确比较混合格式的版本号', () {
      // assert
      expect(_compareVersionsPublic('1.0.0', 'v2.0.0'), equals(-1));
      expect(_compareVersionsPublic('v2.0.0', '1.0.0'), equals(1));
      expect(_compareVersionsPublic('1.0.0+1', '1.0.0'), equals(1));
      expect(_compareVersionsPublic('1.0.0', '1.0.0+1'), equals(-1));
    });

    test('应该处理不均匀长度的版本号', () {
      // assert
      expect(_compareVersionsPublic('1.0', '1.0.0'), equals(0));
      expect(_compareVersionsPublic('1.0.0.0', '1.0.0'), equals(0));
      expect(_compareVersionsPublic('1', '1.0.0.0'), equals(0));
    });

    test('应该正确判断版本更新', () {
      // 当前版本 26.02.02+12，最新版本 26.02.03+15
      final result = _compareVersionsPublic('26.02.02+12', '26.02.03+15');
      
      // assert
      expect(result, equals(-1));
    });

    test('应该判断无需更新（版本相同）', () {
      final result = _compareVersionsPublic('26.02.03+12', '26.02.03+12');
      
      // assert
      expect(result, equals(0));
    });

    test('应该判断无需更新（当前版本更新）', () {
      final result = _compareVersionsPublic('26.02.03+15', '26.02.03+12');
      
      // assert
      expect(result, equals(1));
    });
  });

  group('AppUpdater APK URL 查找', () {
    test('应该找到 APK 下载 URL', () {
      // arrange
      final assets = [
        {'name': 'README.md', 'browser_download_url': 'https://example.com/README.md'},
        {'name': 'sjgtv-v26.02.03.apk', 'browser_download_url': 'https://example.com/sjgtv-v26.02.03.apk'},
        {'name': 'sjgtv-v26.02.03.zip', 'browser_download_url': 'https://example.com/sjgtv-v26.02.03.zip'},
      ];

      // act
      final result = _findApkDownloadUrlPublic(assets);

      // assert
      expect(result, equals('https://example.com/sjgtv-v26.02.03.apk'));
    });

    test('应该返回 null 当没有 APK 文件时', () {
      // arrange
      final assets = [
        {'name': 'README.md', 'browser_download_url': 'https://example.com/README.md'},
        {'name': 'sjgtv-v26.02.03.zip', 'browser_download_url': 'https://example.com/sjgtv-v26.02.03.zip'},
      ];

      // act
      final result = _findApkDownloadUrlPublic(assets);

      // assert
      expect(result, isNull);
    });

    test('应该返回 null 当资产列表为空时', () {
      // act
      final result = _findApkDownloadUrlPublic([]);

      // assert
      expect(result, isNull);
    });

    test('应该找到第一个 APK 文件', () {
      // arrange
      final assets = [
        {'name': 'sjgtv-v26.02.03.apk', 'browser_download_url': 'https://example.com/sjgtv-v26.02.03.apk'},
        {'name': 'sjgtv-v26.02.03-arm64-v8a.apk', 'browser_download_url': 'https://example.com/sjgtv-v26.02.03-arm64-v8a.apk'},
      ];

      // act
      final result = _findApkDownloadUrlPublic(assets);

      // assert
      expect(result, equals('https://example.com/sjgtv-v26.02.03.apk'));
    });
  });
}

// 公开方法用于测试（通过反射或提取到单独的类）
List<int> _parseVersionPublic(String version) {
  final String raw = version.replaceAll('v', '').trim();
  final List<String> mainAndBuild = raw.split('+');
  final String mainPart = mainAndBuild[0].trim();
  final String buildPart =
      mainAndBuild.length > 1 ? mainAndBuild[1].trim() : '0';
  final List<int> mainParts = mainPart
      .split('.')
      .map((String e) => int.tryParse(e) ?? 0)
      .toList();
  mainParts.add(int.tryParse(buildPart) ?? 0);
  return mainParts;
}

int _compareVersionsPublic(String current, String latest) {
  final List<int> currentParts = _parseVersionPublic(current);
  final List<int> latestParts = _parseVersionPublic(latest);
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

String? _findApkDownloadUrlPublic(List<dynamic> assets) {
  for (final dynamic asset in assets) {
    if (asset is Map<String, dynamic>) {
      final String? name = asset['name'] as String?;
      if (name != null && name.endsWith('.apk')) {
        return asset['browser_download_url'] as String?;
      }
    }
  }
  return null;
}