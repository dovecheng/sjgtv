import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sjgtv/src/favorite/page/favorites_page.dart';
import 'package:sjgtv/src/movie/page/movie_detail_page.dart';
import 'package:sjgtv/src/settings/page/settings_page.dart';
import 'package:sjgtv/src/watch_history/page/watch_history_page.dart';

import 'test_helpers.dart';

void main() {
  IntegrationHarness.init();

  group('P1 收藏/历史/设置（5条）', () {
    testWidgets('P1_FHS_01_收藏页_可正常渲染', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.pushPage(tester, const FavoritesPage());

      await IntegrationHarness.pumpUntil(
        tester,
        find.text('收藏'),
        timeout: const Duration(seconds: 8),
      );
      final bool hasEmpty = find.text('暂无收藏').evaluate().isNotEmpty;
      final bool hasGrid = find.byType(GridView).evaluate().isNotEmpty;
      expect(hasEmpty || hasGrid, isTrue);
    });

    testWidgets('P1_FHS_02_历史页_可正常渲染', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.pushPage(tester, const WatchHistoryPage());

      await IntegrationHarness.pumpUntil(
        tester,
        find.text('观看历史'),
        timeout: const Duration(seconds: 8),
      );
      final bool hasEmpty = find.text('暂无观看历史').evaluate().isNotEmpty;
      final bool hasList = find.byType(ListView).evaluate().isNotEmpty;
      expect(hasEmpty || hasList, isTrue);
    });

    testWidgets('P1_FHS_03_设置页_核心分组可见', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.pushPage(tester, const SettingsPage());

      await IntegrationHarness.pumpUntil(
        tester,
        find.text('设置'),
        timeout: const Duration(seconds: 8),
      );
      expect(find.text('播放设置'), findsOneWidget);
      expect(find.text('显示设置'), findsOneWidget);
      expect(find.text('自动播放下一集'), findsOneWidget);
    });

    testWidgets('P1_FHS_04_设置切换_自动播放状态可持久', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.pushPage(tester, const SettingsPage());
      await IntegrationHarness.pumpUntil(tester, find.text('自动播放下一集'));

      final Finder autoPlaySwitch = find.byType(Switch).first;
      final bool before = (tester.widget<Switch>(autoPlaySwitch)).value;
      await tester.tap(autoPlaySwitch);
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));
      final bool afterToggle = (tester.widget<Switch>(autoPlaySwitch)).value;
      expect(afterToggle, isNot(equals(before)));

      await IntegrationHarness.back(tester);
      await IntegrationHarness.pushPage(tester, const SettingsPage());
      await IntegrationHarness.pumpUntil(tester, find.text('自动播放下一集'));
      final bool reopened = (tester.widget<Switch>(
        find.byType(Switch).first,
      )).value;
      expect(reopened, equals(afterToggle));
    });

    testWidgets('P1_FHS_05_详情页收藏按钮_状态可切换', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      final Map<String, dynamic> movie = IntegrationHarness.fakeMovie(
        id: IntegrationHarness.uniqueName('movie-id'),
        name: '收藏测试电影',
        playUrl: '正片\$https://example.com/video.mp4',
      );
      await IntegrationHarness.pushPage(tester, MovieDetailPage(movie: movie));
      await IntegrationHarness.pumpUntil(tester, find.text('剧情简介'));

      Finder favoriteIcon = find.byIcon(Icons.favorite_border);
      Finder favoriteFilledIcon = find.byIcon(Icons.favorite);
      final bool beforeBorder = favoriteIcon.evaluate().isNotEmpty;

      await tester.tap(find.byType(IconButton).first);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 800),
      );

      favoriteIcon = find.byIcon(Icons.favorite_border);
      favoriteFilledIcon = find.byIcon(Icons.favorite);
      final bool afterBorder = favoriteIcon.evaluate().isNotEmpty;
      final bool hasFavoriteState =
          favoriteIcon.evaluate().isNotEmpty ||
          favoriteFilledIcon.evaluate().isNotEmpty;
      expect(hasFavoriteState, isTrue);
      expect(beforeBorder != afterBorder, isTrue, reason: '收藏按钮状态应发生切换');
    });
  });
}
