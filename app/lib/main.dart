import 'dart:io';

import 'package:base/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:sjgtv/services/api.dart';
import 'package:sjgtv/widgets/app_wrapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Hive
  final Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Hive.openBox('sources');
  await Hive.openBox('proxies');
  await Hive.openBox('tags');

  // 加载并存储初始配置
  await _ConfigLoader().loadInitialConfig();

  // 启动Web服务
  final HttpServer server = await startServer();

  runApp(MyApp(server: server)); // 传递server参数
}

class _ConfigLoader {
  Future<void> loadInitialConfig() async {
    final Uuid uuid = Uuid();
    final Box<dynamic> sourcesBox = Hive.box('sources');
    final Box<dynamic> proxiesBox = Hive.box('proxies');
    final Box<dynamic> tagsBox = Hive.box('tags');

    if (sourcesBox.isEmpty) {
      await _initializeSources(sourcesBox, uuid);
    } else {
      log.d(() => 'sources 已有数据，跳过初始化');
    }

    if (proxiesBox.isEmpty) {
      await _initializeProxies(proxiesBox, uuid);
    } else {
      log.d(() => 'proxies 已有数据，跳过初始化');
    }

    if (tagsBox.isEmpty) {
      await _initializeTags(tagsBox, uuid);
    } else {
      log.d(() => 'tags 已有数据，跳过初始化');
    }
  }

  Future<void> _initializeSources(Box<dynamic> sourcesBox, Uuid uuid) async {
    try {
      final Dio dio = Dio();
      log.d(() => '开始加载 sources 配置...');
      final Response<dynamic> response = await dio.get<dynamic>(
        'https://ktv.aini.us.kg/config.json',
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        final dynamic config = response.data;
        log.d(() => '成功获取 sources 配置，共${config['sources']?.length ?? 0}个源');

        int savedCount = 0;
        for (final dynamic source in config['sources']) {
          try {
            final String id = uuid.v4();
            sourcesBox.put(id, {
              ...source,
              'id': id,
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            });
            savedCount++;
            log.d(() => '成功保存源: ${source['name']}');
          } catch (e, s) {
            log.w(() => '保存源${source['name']}失败: $e', e, s);
          }
        }
        log.d(() => '实际保存源数量: $savedCount');
      } else {
        log.w(() => '获取 sources 配置失败，状态码: ${response.statusCode}');
      }
    } catch (e, s) {
      log.e(() => '加载 sources 初始配置失败: $e', e, s);
    }
  }

  Future<void> _initializeProxies(Box<dynamic> proxiesBox, Uuid uuid) async {
    try {
      final Dio dio = Dio();
      log.d(() => '开始加载 proxies 配置...');
      final Response<dynamic> response = await dio.get<dynamic>(
        'https://ktv.aini.us.kg/config.json',
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        final dynamic config = response.data;
        log.d(() => '成功获取 proxies 配置');

        final String pid = uuid.v4();
        proxiesBox.put(pid, {
          "id": pid,
          "url": config['proxy']['url'],
          "name": config['proxy']['name'],
          "enabled": config['proxy']['enabled'],
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        });
        log.d(() => '成功保存代理配置');
      } else {
        log.w(() => '获取 proxies 配置失败，状态码: ${response.statusCode}');
      }
    } catch (e, s) {
      log.e(() => '加载 proxies 初始配置失败: $e', e, s);
    }
  }

  Future<void> _initializeTags(Box<dynamic> tagsBox, Uuid uuid) async {
    try {
      final Dio dio = Dio();
      log.d(() => '开始加载 tags 配置...');
      final Response<dynamic> response = await dio.get<dynamic>(
        'https://ktv.aini.us.kg/config.json',
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        final dynamic config = response.data;
        log.d(() => '成功获取 tags 配置，共${config['tags']?.length ?? 0}个标签');

        int tagCount = 0;
        for (final dynamic tag in config['tags']) {
          final String tid = uuid.v4();
          tagsBox.put(tid, {
            ...tag,
            'id': tid,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
          tagCount++;
          log.d(() => '成功保存标签: ${tag['name']}');
        }
        log.d(() => '实际保存标签数量: $tagCount');
      } else {
        log.w(() => '获取 tags 配置失败，状态码: ${response.statusCode}');
      }
    } catch (e, s) {
      log.e(() => '加载 tags 初始配置失败: $e', e, s);
    }
  }
}

class MyApp extends StatelessWidget {
  final HttpServer server; // 新增server属性

  const MyApp({super.key, required this.server}); // 更新构造函数

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '苹果CMS电影播放器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            displaySmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            headlineMedium: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            headlineSmall: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ).apply(displayColor: Colors.white, bodyColor: Colors.white),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 4,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          surfaceTintColor: Colors.transparent,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: const AppWrapper(),
    );
  }
}
