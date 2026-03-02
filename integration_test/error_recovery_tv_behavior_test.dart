import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sjgtv/src/app/router/app_routes.dart';
import 'package:sjgtv/src/movie/page/full_screen_player_page.dart';

import 'test_helpers.dart';

void main() {
  IntegrationHarness.init();

  // 旧编号 -> 新场景名（仅保留一次映射，正文统一使用中文可读名）
  // P2_01 -> 搜索页_关键词搜索_空结果提示可见
  // P2_02 -> 搜索页_返回键处理_有输入先清空再回首页
  // P2_03 -> 路由页_设置入口_占位页可达
  // P2_04 -> 播放页_空剧集数据_提示当前源无有效剧集
  // P2_05 -> 播放页_播放错误态_可见重试按钮
  // P2_06 -> 播放页_返回键处理_可退出到首页
  // P2_07 -> 播放页_菜单键处理_可打开换源面板
  // P2_08 -> 播放页_方向键交互_可触发控制层提示
  // P2_09 -> 搜索页_结果焦点下移_首个卡片出现焦点放大
  group('异常与韧性场景', () {
    testWidgets('搜索页_关键词搜索_空结果提示可见', (WidgetTester tester) async {
      const String testName = '搜索页_关键词搜索_空结果提示可见';
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '启动应用后首页',
      );
      await IntegrationHarness.openSearchPage(tester);
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 2,
        stepName: '进入搜索页',
      );

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        'it-nothing-zzz-123456789',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 3));
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 3,
        stepName: '搜索后结果态',
      );
      expect(find.text('没有找到相关内容'), findsOneWidget);
    });

    testWidgets('搜索页_返回键处理_有输入先清空再回首页', (WidgetTester tester) async {
      const String testName = '搜索页_返回键处理_有输入先清空再回首页';
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '进入搜索页',
      );

      final Finder input = find.byType(TextField).first;
      await IntegrationHarness.enterText(tester, input, '流浪地球');
      expect(find.text('流浪地球'), findsOneWidget);

      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.escape);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 500),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 2,
        stepName: '首次返回后',
      );
      expect(find.text('流浪地球'), findsNothing);
      expect(find.text('输入电影或电视剧名称'), findsOneWidget);

      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.escape);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 500),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 3,
        stepName: '二次返回后首页',
      );
      expect(
        find.byKey(const ValueKey<String>('app_bar_search')),
        findsOneWidget,
      );
    });

    testWidgets('搜索页_结果焦点下移_首个卡片出现焦点放大', (WidgetTester tester) async {
      const String testName = '搜索页_结果焦点下移_首个卡片出现焦点放大';
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      final Finder input = find.byType(TextField).first;
      await IntegrationHarness.enterText(tester, input, '流浪地球');
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 4));
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '搜索后等待结果',
      );

      if (find.text('没有找到相关内容').evaluate().isNotEmpty) {
        IntegrationHarness.log.w(() => '当前环境未返回搜索结果，跳过焦点放大断言');
        return;
      }

      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.arrowDown);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 600),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 2,
        stepName: '按下后首项焦点',
      );

      final Iterable<AnimatedScale> animatedScales = find
          .byType(AnimatedScale)
          .evaluate()
          .map((Element element) => element.widget)
          .whereType<AnimatedScale>();
      final bool hasFocusedScale = animatedScales.any(
        (AnimatedScale scaleWidget) => scaleWidget.scale > 1.001,
      );
      expect(hasFocusedScale, isTrue, reason: '有结果时按下方向键后应有焦点放大效果');
    });

    testWidgets('路由页_设置入口_占位页可达', (WidgetTester tester) async {
      const String testName = '路由页_设置入口_占位页可达';
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openRouteByGoRouter(tester, AppRoutes.settings);
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '进入设置占位页',
      );

      expect(find.text('设置'), findsOneWidget);
      expect(find.text('设置功能开发中'), findsOneWidget);
    });

    testWidgets('播放页_空剧集数据_提示当前源无有效剧集', (WidgetTester tester) async {
      const String testName = '播放页_空剧集数据_提示当前源无有效剧集';
      await IntegrationHarness.launchApp(tester);
      final Map<String, dynamic> movie = IntegrationHarness.fakeMovie(
        playUrl: '',
      );
      await IntegrationHarness.pushPage(
        tester,
        FullScreenPlayerPage(
          movie: movie,
          episodes: const <Map<String, String>>[],
          initialIndex: 0,
        ),
      );

      await IntegrationHarness.pumpUntil(
        tester,
        find.text('当前源无有效剧集'),
        timeout: const Duration(seconds: 8),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '空剧集错误提示',
      );
      expect(find.text('当前源无有效剧集'), findsOneWidget);
    });

    testWidgets('播放页_播放错误态_可见重试按钮', (WidgetTester tester) async {
      const String testName = '播放页_播放错误态_可见重试按钮';
      await IntegrationHarness.launchApp(tester);
      final Map<String, dynamic> movie = IntegrationHarness.fakeMovie(
        playUrl: '正片\$invalid://broken-url',
      );
      await IntegrationHarness.pushPage(
        tester,
        FullScreenPlayerPage(
          movie: movie,
          episodes: const <Map<String, String>>[
            <String, String>{'title': '正片', 'url': 'invalid://broken-url'},
          ],
          initialIndex: 0,
        ),
      );

      await IntegrationHarness.pumpUntil(
        tester,
        find.byType(ElevatedButton),
        timeout: const Duration(seconds: 15),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '播放错误重试按钮',
      );
      expect(find.text('重试'), findsOneWidget);
    });

    testWidgets('播放页_返回键处理_可退出到首页', (WidgetTester tester) async {
      const String testName = '播放页_返回键处理_可退出到首页';
      await IntegrationHarness.launchApp(tester);
      final Map<String, dynamic> movie = IntegrationHarness.fakeMovie(
        playUrl: '',
      );
      await IntegrationHarness.pushPage(
        tester,
        FullScreenPlayerPage(
          movie: movie,
          episodes: const <Map<String, String>>[],
          initialIndex: 0,
        ),
      );
      await IntegrationHarness.pumpUntil(tester, find.text('当前源无有效剧集'));

      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.escape);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 800),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '返回后首页状态',
      );
      expect(find.text('当前源无有效剧集'), findsNothing);
      expect(
        find.byKey(const ValueKey<String>('app_bar_search')),
        findsOneWidget,
      );
    });

    testWidgets('播放页_菜单键处理_可打开换源面板', (WidgetTester tester) async {
      const String testName = '播放页_菜单键处理_可打开换源面板';
      await IntegrationHarness.launchApp(tester);
      final Map<String, dynamic> movie = IntegrationHarness.fakeMovie(
        playUrl: '正片\$invalid://broken-url',
      );
      final List<Map<String, dynamic>> sources = <Map<String, dynamic>>[
        IntegrationHarness.fakeSource(
          sourceName: '源A',
          playUrl: '正片\$invalid://a',
        ),
        IntegrationHarness.fakeSource(
          sourceName: '源B',
          playUrl: '正片\$invalid://b',
        ),
      ];
      await IntegrationHarness.pushPage(
        tester,
        FullScreenPlayerPage(
          movie: movie,
          episodes: const <Map<String, String>>[
            <String, String>{'title': '正片', 'url': 'invalid://broken-url'},
          ],
          initialIndex: 0,
          sources: sources,
          currentSourceIndex: 0,
        ),
      );

      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.contextMenu);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 800),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '换源面板展开',
      );
      expect(find.text('换源'), findsOneWidget);
      expect(find.text('源A'), findsOneWidget);
      expect(find.text('源B'), findsOneWidget);
    });

    testWidgets('播放页_方向键交互_可触发控制层提示', (WidgetTester tester) async {
      const String testName = '播放页_方向键交互_可触发控制层提示';
      await IntegrationHarness.launchApp(tester);
      final Map<String, dynamic> movie = IntegrationHarness.fakeMovie(
        playUrl: '正片\$invalid://broken-url',
      );
      await IntegrationHarness.pushPage(
        tester,
        FullScreenPlayerPage(
          movie: movie,
          episodes: const <Map<String, String>>[
            <String, String>{'title': '正片', 'url': 'invalid://broken-url'},
          ],
          initialIndex: 0,
        ),
      );

      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.arrowRight);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 500),
      );
      await IntegrationHarness.takeStepScreenshot(
        tester,
        testName: testName,
        step: 1,
        stepName: '方向键触发控制层',
      );
      final bool hasFastForwardIcon = find
          .byIcon(Icons.fast_forward)
          .evaluate()
          .isNotEmpty;
      final bool hasGuideText = find
          .text('长按左右方向键可快进/快退')
          .evaluate()
          .isNotEmpty;
      expect(hasFastForwardIcon || hasGuideText, isTrue);
    });
  });
}
