import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sjgtv/core/log/log.dart';
import 'package:sjgtv/main.dart' as app;

final class IntegrationHarness {
  IntegrationHarness._();

  static final Log log = Log('integration_harness');
  static final String _runId =
      Platform.environment['IT_RUN_ID'] ??
      DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');
  static final bool _enableStepScreenshot =
      (Platform.environment['IT_ENABLE_SCREENSHOT'] ?? '1') == '1';
  static bool _isSurfaceConverted = false;

  static void init() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> launchApp(WidgetTester tester) async {
    app.main();
    await settle(tester, const Duration(seconds: 2));
    await pumpUntil(
      tester,
      find.byType(MaterialApp),
      timeout: const Duration(seconds: 15),
      reason: '应用未成功启动到 MaterialApp',
    );
  }

  static Future<void> settle(WidgetTester tester, Duration duration) async {
    await tester.pumpAndSettle(duration);
  }

  static Future<void> pumpUntil(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 20),
    Duration step = const Duration(milliseconds: 300),
    String? reason,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      await tester.pump(step);
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    expect(finder, findsWidgets, reason: reason ?? '超时未找到目标元素');
  }

  static Future<void> openSearchPage(WidgetTester tester) async {
    final Finder searchButton = find.byKey(
      const ValueKey<String>('app_bar_search'),
    );
    await pumpUntil(tester, searchButton, reason: '首页未找到搜索按钮');
    await tester.tap(searchButton);
    await settle(tester, const Duration(seconds: 1));
    await pumpUntil(
      tester,
      find.text('搜索'),
      timeout: const Duration(seconds: 8),
      reason: '未进入搜索页',
    );
  }

  static Future<void> openSourceManagePage(WidgetTester tester) async {
    final Finder sourceButton = find.byKey(
      const ValueKey<String>('app_bar_source'),
    );
    await pumpUntil(tester, sourceButton, reason: '首页未找到源管理按钮');
    await tester.tap(sourceButton);
    await settle(tester, const Duration(seconds: 1));
    await pumpUntil(
      tester,
      find.text('源管理'),
      timeout: const Duration(seconds: 10),
      reason: '未进入源管理页',
    );
  }

  static Future<void> openRouteByGoRouter(
    WidgetTester tester,
    String route,
  ) async {
    final Finder materialApp = find.byType(MaterialApp);
    await pumpUntil(tester, materialApp, reason: '未找到 MaterialApp');
    final BuildContext context = tester.element(materialApp);
    // ignore: use_build_context_synchronously
    GoRouter.of(context).go(route);
    await settle(tester, const Duration(seconds: 1));
  }

  static Future<void> pushPage(WidgetTester tester, Widget page) async {
    final Finder scaffold = find.byType(Scaffold);
    await pumpUntil(tester, scaffold, reason: '未找到可用 Scaffold');
    final BuildContext context = tester.element(scaffold.first);
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
    await settle(tester, const Duration(seconds: 1));
  }

  static Future<void> sendKey(
    WidgetTester tester,
    LogicalKeyboardKey key,
  ) async {
    await tester.sendKeyDownEvent(key);
    await tester.sendKeyUpEvent(key);
    await tester.pump(const Duration(milliseconds: 200));
  }

  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await pumpUntil(tester, finder, reason: '输入框未就绪');
    await tester.tap(finder);
    await tester.enterText(finder, text);
    await tester.pump(const Duration(milliseconds: 300));
  }

  static Future<void> ensureHomeLoaded(WidgetTester tester) async {
    await pumpUntil(
      tester,
      find.byKey(const ValueKey<String>('app_bar_search')),
      timeout: const Duration(seconds: 20),
      reason: '首页顶部按钮未加载',
    );
  }

  static Future<void> back(WidgetTester tester) async {
    await sendKey(tester, LogicalKeyboardKey.escape);
    await settle(tester, const Duration(milliseconds: 800));
  }

  static String _sanitizeLabel(String input) {
    return input
        .replaceAll(RegExp(r'[^\w\u4e00-\u9fa5-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  static Future<void> takeStepScreenshot(
    WidgetTester tester, {
    required String testName,
    required int step,
    required String stepName,
  }) async {
    if (!_enableStepScreenshot) {
      return;
    }
    final IntegrationTestWidgetsFlutterBinding binding =
        IntegrationTestWidgetsFlutterBinding.instance;
    if (!_isSurfaceConverted) {
      try {
        await binding
            .convertFlutterSurfaceToImage()
            .timeout(const Duration(seconds: 3));
        _isSurfaceConverted = true;
      } catch (error, stackTrace) {
        log.w(() => '初始化截图环境失败，跳过截图: $error', stackTrace);
        return;
      }
    }
    final String safeTestName = _sanitizeLabel(testName);
    final String safeStepName = _sanitizeLabel(stepName);
    final String screenshotName =
        '$_runId'
        '__${safeTestName}__${step.toString().padLeft(2, '0')}_$safeStepName';
    try {
      await binding
          .takeScreenshot(screenshotName)
          .timeout(const Duration(seconds: 5));
    } catch (error, stackTrace) {
      log.w(() => '步骤截图失败，已忽略: $error', stackTrace);
    }
  }

  static String uniqueName(String prefix) {
    return '$prefix-${DateTime.now().millisecondsSinceEpoch}';
  }

  static Map<String, dynamic> fakeMovie({
    String id = 'it-movie-1',
    String name = '集成测试电影',
    String pic = '',
    String year = '2026',
    String playUrl = '',
  }) {
    return <String, dynamic>{
      'vod_id': id,
      'vod_name': name,
      'vod_pic': pic,
      'vod_year': year,
      'vod_actor': '测试演员',
      'vod_director': '测试导演',
      'vod_content': '测试剧情',
      'vod_blurb': '测试简介',
      'url': playUrl,
    };
  }

  static Map<String, dynamic> fakeSource({
    required String sourceName,
    required String playUrl,
  }) {
    return <String, dynamic>{
      'source': <String, dynamic>{'name': sourceName},
      'vod_name': '测试源影片',
      'vod_pic': '',
      'vod_play_url': playUrl,
    };
  }
}
