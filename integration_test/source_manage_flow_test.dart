import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  IntegrationHarness.init();

  group('P1 源管理流程（10条）', () {
    testWidgets('P1_01_进入源管理页_标题可见', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);
      expect(find.text('源管理'), findsOneWidget);
    });

    testWidgets('P1_02_源管理列表_可见空态或列表', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);

      final bool hasEmpty = find.text('暂无数据源').evaluate().isNotEmpty;
      final bool hasCard = find.byType(Card).evaluate().isNotEmpty;
      final bool hasLoading = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      expect(hasEmpty || hasCard || hasLoading, isTrue);
    });

    testWidgets('P1_03_点击新增_进入添加表单', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);

      await tester.tap(find.byIcon(Icons.add));
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));
      expect(find.text('添加数据源'), findsOneWidget);
      expect(find.text('保存'), findsOneWidget);
    });

    testWidgets('P1_04_新增表单_名称必填校验', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);
      await tester.tap(find.byIcon(Icons.add));
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));

      await tester.tap(find.text('保存'));
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 400),
      );
      expect(find.text('请输入名称'), findsOneWidget);
    });

    testWidgets('P1_05_新增表单_URL必填校验', (WidgetTester tester) async {
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);
      await tester.tap(find.byIcon(Icons.add));
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        IntegrationHarness.uniqueName('it-src'),
      );
      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).at(1),
        'abc',
      );
      await tester.tap(find.text('保存'));
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 400),
      );
      expect(find.text('请输入有效的 http(s) 地址'), findsOneWidget);
    });

    testWidgets('P1_06_新增源_列表出现新条目', (WidgetTester tester) async {
      final String sourceName = IntegrationHarness.uniqueName('it-src-add');
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);
      await tester.tap(find.byIcon(Icons.add));
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        sourceName,
      );
      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).at(1),
        'https://example.com/',
      );
      await tester.tap(find.text('保存'));
      await IntegrationHarness.settle(tester, const Duration(seconds: 2));

      expect(find.text(sourceName), findsOneWidget);
    });

    testWidgets('P1_07_编辑源_更新名称成功', (WidgetTester tester) async {
      final String sourceName = IntegrationHarness.uniqueName('it-src-edit');
      final String updatedName = '$sourceName-updated';

      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);

      await _createSource(tester, sourceName);
      expect(find.text(sourceName), findsOneWidget);

      final Finder card = find
          .ancestor(of: find.text(sourceName), matching: find.byType(Card))
          .first;
      final Finder editButton = find.descendant(
        of: card,
        matching: find.byIcon(Icons.edit),
      );
      await tester.tap(editButton);
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));

      await IntegrationHarness.enterText(
        tester,
        find.byType(TextField).first,
        updatedName,
      );
      await tester.tap(find.text('保存'));
      await IntegrationHarness.settle(tester, const Duration(seconds: 2));
      expect(find.text(updatedName), findsOneWidget);
    });

    testWidgets('P1_08_删除弹窗_取消不删除', (WidgetTester tester) async {
      final String sourceName = IntegrationHarness.uniqueName(
        'it-src-cancel-delete',
      );
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);
      await _createSource(tester, sourceName);

      final Finder card = find
          .ancestor(of: find.text(sourceName), matching: find.byType(Card))
          .first;
      final Finder deleteButton = find.descendant(
        of: card,
        matching: find.byIcon(Icons.delete_outline),
      );
      await tester.tap(deleteButton);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 500),
      );
      expect(find.text('删除源'), findsOneWidget);

      await tester.tap(find.text('取消'));
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 500),
      );
      expect(find.text(sourceName), findsOneWidget);
    });

    testWidgets('P1_09_删除源_确认后移除条目', (WidgetTester tester) async {
      final String sourceName = IntegrationHarness.uniqueName('it-src-delete');
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);
      await _createSource(tester, sourceName);
      expect(find.text(sourceName), findsOneWidget);

      final Finder card = find
          .ancestor(of: find.text(sourceName), matching: find.byType(Card))
          .first;
      final Finder deleteButton = find.descendant(
        of: card,
        matching: find.byIcon(Icons.delete_outline),
      );
      await tester.tap(deleteButton);
      await IntegrationHarness.settle(
        tester,
        const Duration(milliseconds: 500),
      );
      await tester.tap(find.text('确认删除'));
      await IntegrationHarness.settle(tester, const Duration(seconds: 2));
      expect(find.text(sourceName), findsNothing);
    });

    testWidgets('P1_10_源状态切换_图标状态变化', (WidgetTester tester) async {
      final String sourceName = IntegrationHarness.uniqueName('it-src-toggle');
      await IntegrationHarness.launchApp(tester);
      await IntegrationHarness.openSourceManagePage(tester);
      await _createSource(tester, sourceName);

      final Finder card = find
          .ancestor(of: find.text(sourceName), matching: find.byType(Card))
          .first;
      Finder toggleOn = find.descendant(
        of: card,
        matching: find.byIcon(Icons.toggle_on),
      );
      Finder toggleOff = find.descendant(
        of: card,
        matching: find.byIcon(Icons.toggle_off),
      );
      final bool beforeOn = toggleOn.evaluate().isNotEmpty;
      final bool beforeOff = toggleOff.evaluate().isNotEmpty;
      expect(beforeOn || beforeOff, isTrue);

      await tester.tap(
        find.descendant(of: card, matching: find.byType(GestureDetector)).last,
      );
      await IntegrationHarness.settle(tester, const Duration(seconds: 1));

      toggleOn = find.descendant(
        of: card,
        matching: find.byIcon(Icons.toggle_on),
      );
      toggleOff = find.descendant(
        of: card,
        matching: find.byIcon(Icons.toggle_off),
      );
      final bool afterOn = toggleOn.evaluate().isNotEmpty;
      final bool afterOff = toggleOff.evaluate().isNotEmpty;
      expect(afterOn || afterOff, isTrue);
      expect(beforeOn != afterOn || beforeOff != afterOff, isTrue);
    });
  });
}

Future<void> _createSource(WidgetTester tester, String sourceName) async {
  await tester.tap(find.byIcon(Icons.add));
  await IntegrationHarness.settle(tester, const Duration(seconds: 1));
  await IntegrationHarness.enterText(
    tester,
    find.byType(TextField).first,
    sourceName,
  );
  await IntegrationHarness.enterText(
    tester,
    find.byType(TextField).at(1),
    'https://example.com/',
  );
  await tester.tap(find.text('保存'));
  await IntegrationHarness.settle(tester, const Duration(seconds: 2));
}
