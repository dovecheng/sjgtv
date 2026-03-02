import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sjgtv/core/log/log.dart';
import 'package:sjgtv/src/movie/widget/hero_section.dart';
import 'package:sjgtv/src/movie/widget/youtube_tv_category_bar.dart';

import 'test_helpers.dart';

void main() {
  IntegrationHarness.init();
  final LogBinding logBinding = LogBinding();

  group('P0 主链路（12条）', () {
    testWidgets('P0_01_应用启动_首页按钮可见', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.ensureHomeLoaded(tester);

      expect(
        find.byKey(const ValueKey<String>('app_bar_search')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('app_bar_source')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('app_bar_settings')),
        findsOneWidget,
      );
      logBinding.log('P0_01 通过');
    });

    testWidgets('P0_02_首页分类栏_成功渲染', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.ensureHomeLoaded(tester);

      await IntegrationHarness.pumpUntil(
        tester,
        find.byType(YouTubeTVCategoryBar),
        timeout: const Duration(seconds: 12),
      );
      expect(find.byType(YouTubeTVCategoryBar), findsOneWidget);
    });

    testWidgets('P0_03_首页Hero区_可见', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.ensureHomeLoaded(tester);

      await IntegrationHarness.pumpUntil(
        tester,
        find.byType(HeroSection),
        timeout: const Duration(seconds: 20),
      );
      expect(find.byType(HeroSection), findsOneWidget);
    });

    testWidgets('P0_04_点击Hero_进入搜索页', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.ensureHomeLoaded(tester);
      await IntegrationHarness.pumpUntil(
        tester,
        find.byType(HeroSection),
        timeout: const Duration(seconds: 20),
      );

      await tester.tap(find.byType(HeroSection));
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));
      await IntegrationHarness.pumpUntil(
        tester,
        find.text('搜索'),
        timeout: const Duration(seconds: 12),
      );
      expect(find.text('搜索'), findsWidgets);
    });

    testWidgets('P0_05_点击搜索图标_进入搜索页', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      expect(find.text('搜索'), findsWidgets);
      expect(find.text('搜索电影、电视剧...'), findsOneWidget);
    });

    testWidgets('P0_06_搜索页初始态_展示引导文案', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      expect(find.text('输入电影或电视剧名称'), findsOneWidget);
      expect(find.text('使用遥控器方向键导航，确认键选择'), findsOneWidget);
    });

    testWidgets('P0_07_搜索关键词_进入加载或结果态', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        '海贼王',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 2));

      final bool hasLoading = find.text('正在搜索中...').evaluate().isNotEmpty;
      final bool hasResult = find.textContaining('搜索结果').evaluate().isNotEmpty;
      final bool hasEmpty = find.text('没有找到相关内容').evaluate().isNotEmpty;
      expect(
        hasLoading || hasResult || hasEmpty,
        isTrue,
        reason: '搜索后应进入可观测状态',
      );
    });

    testWidgets('P0_08_搜索结果_可识别结果卡片或空态', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        '变形金刚',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 5));

      final Finder resultCards = find.byWidgetPredicate((Widget widget) {
        final Key? key = widget.key;
        return key is ValueKey<String> &&
            key.value.startsWith('search_result_');
      });
      final bool hasCards = resultCards.evaluate().isNotEmpty;
      final bool hasEmpty = find.text('没有找到相关内容').evaluate().isNotEmpty;
      expect(hasCards || hasEmpty, isTrue, reason: '应出现搜索结果卡片或空态');
    });

    testWidgets('P0_09_结果进入详情_详情基础模块可见', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        '速度与激情',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 5));

      final Finder resultCards = find.byWidgetPredicate((Widget widget) {
        final Key? key = widget.key;
        return key is ValueKey<String> &&
            key.value.startsWith('search_result_');
      });
      if (resultCards.evaluate().isEmpty) {
        expect(find.text('没有找到相关内容'), findsOneWidget);
        return;
      }

      await tester.tap(resultCards.first);
      await IntegrationHarness.settle(tester, const Duration(seconds: 3));
      expect(find.text('剧情简介'), findsOneWidget);
    });

    testWidgets('P0_10_详情返回_回到搜索页', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        '速度与激情',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 5));

      final Finder resultCards = find.byWidgetPredicate((Widget widget) {
        final Key? key = widget.key;
        return key is ValueKey<String> &&
            key.value.startsWith('search_result_');
      });
      if (resultCards.evaluate().isEmpty) {
        expect(find.text('没有找到相关内容'), findsOneWidget);
        return;
      }

      await tester.tap(resultCards.first);
      await IntegrationHarness.settle(tester, const Duration(seconds: 2));
      expect(find.text('剧情简介'), findsOneWidget);

      await IntegrationHarness.back(tester);
      await IntegrationHarness.pumpUntil(
        tester,
        find.text('搜索'),
        timeout: const Duration(seconds: 5),
      );
      expect(find.text('搜索'), findsWidgets);
    });

    testWidgets('P0_11_详情选集区域_可识别', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        '速度与激情',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 5));

      final Finder resultCards = find.byWidgetPredicate((Widget widget) {
        final Key? key = widget.key;
        return key is ValueKey<String> &&
            key.value.startsWith('search_result_');
      });
      if (resultCards.evaluate().isEmpty) {
        expect(find.text('没有找到相关内容'), findsOneWidget);
        return;
      }

      await tester.tap(resultCards.first);
      await IntegrationHarness.settle(tester, const Duration(seconds: 2));
      final bool hasEpisodes = find.text('选集').evaluate().isNotEmpty;
      final bool hasNoEpisodeState = find.text('暂无简介').evaluate().isNotEmpty;
      expect(hasEpisodes || hasNoEpisodeState, isTrue);
    });

    testWidgets('P0_12_详情到播放_进入播放器或明确错误态', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSearchPage(tester);

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        '速度与激情',
      );
      await IntegrationHarness.sendKey(tester, LogicalKeyboardKey.enter);
      await IntegrationHarness.settle(tester, const Duration(seconds: 5));

      final Finder resultCards = find.byWidgetPredicate((Widget widget) {
        final Key? key = widget.key;
        return key is ValueKey<String> &&
            key.value.startsWith('search_result_');
      });
      if (resultCards.evaluate().isEmpty) {
        expect(find.text('没有找到相关内容'), findsOneWidget);
        return;
      }

      await tester.tap(resultCards.first);
      await IntegrationHarness.settle(tester, const Duration(seconds: 2));

      final Finder episodeButton = find.byType(FilledButton).first;
      if (episodeButton.evaluate().isNotEmpty) {
        await tester.tap(episodeButton);
        await IntegrationHarness.settle(tester, const Duration(seconds: 3));
      }

      final bool inPlayer = find.text('长按左右方向键可快进/快退').evaluate().isNotEmpty;
      final bool hasError =
          find.textContaining('播放失败').evaluate().isNotEmpty ||
          find.text('当前源无有效剧集').evaluate().isNotEmpty;
      expect(inPlayer || hasError, isTrue, reason: '应进入播放器或进入可观测错误态');
    });
  });
}

final class LogBinding {
  final Log _log = Log('p0_core_flow_test');

  void log(String message) {
    _log.d(() => message);
  }
}
