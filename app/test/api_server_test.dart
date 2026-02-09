import 'dart:io';

import 'package:sjgtv/core/base.dart';
import 'package:flutter/material.dart';
import 'package:sjgtv/src/shelf/api.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';

/// shelf 本地服务测试入口
///
/// 运行方式: flutter run -t test/api_server_test.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 使用 base 同一 Isar 实例（覆盖 isarProvider 并注册 app schema）
  configRef(
    overrides: [
      isarProvider.overrideWith(
        () => IsarProvider(
          schemas: [
            SourceModelSchema,
            ProxyModelSchema,
            TagModelSchema,
          ],
        ),
      ),
    ],
  );
  await $ref.read(isarProvider.future);

  // 启动 Web 服务
  final HttpServer server = await startServer();

  runApp(_ApiTestApp(server: server));
}

/// 测试用 App，显示服务状态
class _ApiTestApp extends StatelessWidget {
  final HttpServer server;

  const _ApiTestApp({required this.server});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '苹果CMS聚合搜索API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('苹果CMS聚合搜索API')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('服务运行在: http://localhost:${server.port}'),
              const SizedBox(height: 20),
              const Text('API端点:'),
              const Text('/api/sources - 获取源列表'),
              const Text('/api/tags - 标签管理'),
              const Text('/api/proxies - 代理管理'),
              const Text('/api/search?wd=关键词 - 搜索内容'),
            ],
          ),
        ),
      ),
    );
  }
}
