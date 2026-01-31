import 'dart:io';

import 'package:base/base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sjgtv/src/model/proxy_entity.dart';
import 'package:sjgtv/src/model/source_entity.dart';
import 'package:sjgtv/src/model/tag_entity.dart';
import 'package:sjgtv/src/storage/source_storage.dart';
import 'package:sjgtv/src/app/provider/json_adapter_provider.dart';
import 'package:sjgtv/src/app/theme/app_colors.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';
import 'package:sjgtv/src/api/shelf/api.dart';
import 'package:sjgtv/src/model/proxy.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/model/tag.dart';
import 'package:sjgtv/src/page/home/app_wrapper.dart';
import 'package:uuid/uuid.dart';

/// sjgtv 应用启动器
///
/// 继承 base 的 AppRunner，配置应用所需的提供者
final class SjgtvRunner extends AppRunner {
  /// shelf 本地服务实例
  HttpServer? server;

  SjgtvRunner();

  /// JSON 转换器配置
  @override
  JsonAdapterProvider get jsonAdapter => JsonAdapterImpl();

  /// API 客户端配置
  @override
  ApiClientProvider get apiClient => ApiClientProvider(
        interceptors: [
          ApiResultInterceptor(),
        ],
      );

  /// 使用 base 同一 Isar 实例，并注册 app 的 sources/proxies/tags schema
  @override
  IsarProvider? get isar => IsarProvider(
        schemas: [
          SourceEntitySchema,
          ProxyEntitySchema,
          TagEntitySchema,
        ],
      );

  @override
  Future<void> init() async {
    await super.init();

    // 加载初始配置（Isar 由 base initProvider 通过 isarProvider 初始化）
    await _ConfigLoader().loadInitialConfig();

    // 启动 shelf 本地 API 服务（不阻塞）
    startServer().then((HttpServer s) {
      server = s;
      log.d(() => 'shelf 本地服务已启动: http://localhost:8023');
    });
  }

  /// 构建应用
  @override
  Future<Widget> buildApp() async {
    return MaterialApp(
      title: '苹果CMS电影播放器',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const AppWrapper(),
    );
  }

  /// 构建主题（色板来自 [AppColors]，UI 使用 [Theme.of].colorScheme 或 [AppThemeColors]）
  ThemeData _buildTheme() {
    final AppThemeColors appColors = AppThemeColors.fromAppColors();
    final ColorScheme colorScheme = ColorScheme.dark(
      primary: appColors.primary,
      onPrimary: Colors.black87,
      primaryContainer: appColors.primary.withAlpha((255 * 0.2).toInt()),
      onPrimaryContainer: appColors.primary,
      secondary: appColors.seedColor,
      onSecondary: Colors.black87,
      surface: appColors.background,
      onSurface: Colors.white,
      surfaceContainerHighest: appColors.cardBackground,
      surfaceContainer: appColors.cardSurface,
      surfaceContainerLow: appColors.surfaceVariant,
      onSurfaceVariant: appColors.hint,
      outline: Colors.white24,
      outlineVariant: appColors.surfaceVariant,
      error: appColors.error,
      onError: Colors.white,
    );
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      extensions: <ThemeExtension<dynamic>>[appColors],
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
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}

/// 初始配置加载器
class _ConfigLoader {
  Future<void> loadInitialConfig() async {
    final Uuid uuid = Uuid();

    if (await SourceStorage.sourceCount == 0) {
      await _initializeSources(uuid);
    } else {
      log.d(() => 'sources 已有数据，跳过初始化');
    }

    if (await SourceStorage.proxyCount == 0) {
      await _initializeProxies(uuid);
    } else {
      log.d(() => 'proxies 已有数据，跳过初始化');
    }

    if (await SourceStorage.tagCount == 0) {
      await _initializeTags(uuid);
    } else {
      log.d(() => 'tags 已有数据，跳过初始化');
    }
  }

  Future<void> _initializeSources(Uuid uuid) async {
    try {
      final Dio dio = Dio();
      log.d(() => '开始加载 sources 配置...');
      final Response<dynamic> response = await dio.get<dynamic>(
        'https://ktv.aini.us.kg/config.json',
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        final dynamic config = response.data;
        log.d(
            () => '成功获取 sources 配置，共${config['sources']?.length ?? 0}个源');

        int savedCount = 0;
        for (final dynamic source in config['sources']) {
          try {
            final String id = uuid.v4();
            final String urlRaw = (source['url']?.toString() ?? '').trim();
            String url = urlRaw;
            if (url.isNotEmpty && !url.endsWith('/')) url += '/';
            if (url.isNotEmpty && !url.endsWith('api.php/provide/vod')) {
              url += 'api.php/provide/vod';
            }
            final Source newSource = Source(
              id: id,
              name: (source['name']?.toString() ?? '').trim(),
              url: url,
              weight: IntConverter.toIntOrNull(source['weight']) ?? 5,
              tagIds: List<String>.from(source['tagIds'] ?? []),
            );
            await SourceStorage.addSource(newSource);
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

  Future<void> _initializeProxies(Uuid uuid) async {
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
        final dynamic proxy = config['proxy'];
        final Proxy newProxy = Proxy(
          id: uuid.v4(),
          url: (proxy['url']?.toString() ?? '').trim(),
          name: (proxy['name']?.toString() ?? '').trim(),
          enabled: proxy['enabled'] == true,
        );
        await SourceStorage.addProxy(newProxy);
        log.d(() => '成功保存代理配置');
      } else {
        log.w(() => '获取 proxies 配置失败，状态码: ${response.statusCode}');
      }
    } catch (e, s) {
      log.e(() => '加载 proxies 初始配置失败: $e', e, s);
    }
  }

  Future<void> _initializeTags(Uuid uuid) async {
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
        for (final dynamic tag in config['tags'] ?? <dynamic>[]) {
          final Tag newTag = Tag(
            id: uuid.v4(),
            name: (tag['name']?.toString() ?? '').trim(),
            color: tag['color']?.toString() ?? '#4285F4',
            order: tagCount,
          );
          await SourceStorage.addTag(newTag);
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
