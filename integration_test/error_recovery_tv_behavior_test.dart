import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sjgtv/src/app/router/app_routes.dart';
import 'package:sjgtv/src/movie/page/full_screen_player_page.dart';

import 'test_helpers.dart';

void main() {
  IntegrationHarness.init();

  group('P2 异常与韧性（8条）', () {
    testWidgets('P2_01_搜索随机词_进入空结果态', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        'it-nothing-zzz-123456789',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 3));
      expect(find.text('没有找到相关内容'), findsOneWidget);
    });

    testWidgets('P2_02_搜索页返回键_优先清空输入', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      final Finder input = find.byType(TextField).first;
      await IntegrationHarness.enterText(tester, input, '测试返回行为');
      expect(find.text('测试返回行为'), findsOneWidget);

      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.escape);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 500),
      );
      expect(find.text('测试返回行为'), findsNothing);
      expect(find.text('输入电影或电视剧名称'), findsOneWidget);
    });

    testWidgets('P2_03_路由设置页_占位页面可达', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openRouteByGoRouter(tester, AppRoutes.settings);

      expect(find.text('设置'), findsOneWidget);
      expect(find.text('设置功能开发中'), findsOneWidget);
    });

    testWidgets('P2_04_播放器空剧集_显示无有效剧集', (WidgetTester tester) async {
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
      expect(find.text('当前源无有效剧集'), findsOneWidget);
    });

    testWidgets('P2_05_播放器错误态_展示重试按钮', (WidgetTester tester) async {
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
      expect(find.text('重试'), findsOneWidget);
    });

    testWidgets('P2_06_播放器返回键_可以退出播放页', (WidgetTester tester) async {
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
      expect(find.text('当前源无有效剧集'), findsNothing);
      expect(
        find.byKey(const ValueKey<String>('app_bar_search')),
        findsOneWidget,
      );
    });

    testWidgets('P2_07_播放器菜单键_可打开换源面板', (WidgetTester tester) async {
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
      expect(find.text('换源'), findsOneWidget);
      expect(find.text('源A'), findsOneWidget);
      expect(find.text('源B'), findsOneWidget);
    });

    testWidgets('P2_08_播放器方向键_可触发控制层提示', (WidgetTester tester) async {
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
