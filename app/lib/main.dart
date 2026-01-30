import 'package:sjgtv/src/app/sjgtv_runner.dart';

/// 应用入口
///
/// 使用 SjgtvRunner 启动应用，自动完成：
/// - Hive 初始化
/// - 初始配置加载
/// - shelf 本地服务启动
/// - Riverpod 提供者配置
void main() => SjgtvRunner().launchApp();
