import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sjgtv/main.dart' as app;
import 'package:sjgtv/core/log/log.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final log = Log('simple_test');

  testWidgets('简单启动测试', (WidgetTester tester) async {
    // 启动应用
    app.main();
    await tester.pumpAndSettle();

    log.d('✅ 应用启动成功');

    // 等待 3 秒
    await tester.pumpAndSettle(const Duration(seconds: 3));

    log.d('✅ 测试完成');
  });
}
