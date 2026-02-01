import 'dart:io';

import 'package:base/base.dart';
import 'package:sjgtv/gen/l10n.gen.dart';
import 'package:sjgtv/src/app/provider/config_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';
import 'package:sjgtv/src/source/provider/source_count_provider.dart';
import 'package:sjgtv/src/proxy/provider/proxy_count_provider.dart';
import 'package:sjgtv/src/proxy/provider/proxies_provider.dart';
import 'package:sjgtv/src/source/provider/sources_storage_provider.dart';
import 'package:sjgtv/src/tag/provider/tags_provider.dart';
import 'package:sjgtv/src/app/provider/json_adapter_provider.dart';
import 'package:sjgtv/src/app/theme/app_colors.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';
import 'package:sjgtv/src/shelf/api.dart';
import 'package:sjgtv/src/movie/page/category_page.dart';
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

  /// 注入 app 的 L10n.translations，与 base 的 L10n.translations 在 provider 内合并
  @override
  L10nTranslationProvider? get l10nTranslation =>
      L10nTranslationProvider(L10n.translations);

  /// 使用 base 同一 Isar 实例，并注册 app 的 sources/proxies/tags schema
  @override
  IsarProvider? get isar => IsarProvider(
        schemas: [
          SourceModelSchema,
          ProxyModelSchema,
          TagModelSchema,
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
      home: PopScope(
        canPop: false,
        child: const MovieHomePage(),
      ),
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
///
/// 通过 [configApiProvider] 获取远程 config.json 请求结果，
/// 使用 base 的 apiClientProvider（含日志、拦截器等）。
class _ConfigLoader {
  Future<void> loadInitialConfig() async {
    final Uuid uuid = Uuid();
    final bool needSources =
        await $ref.read(sourceCountStorageProvider.future) == 0;
    final bool needProxies =
        await $ref.read(proxyCountStorageProvider.future) == 0;

    try {
      $ref.invalidate(configApiProvider);
      debugPrint('[Config] 开始加载远程配置: https://ktv.aini.us.kg/config.json');
      log.d(() => '开始加载远程配置: https://ktv.aini.us.kg/config.json');
      final Map<String, dynamic>? config =
          await $ref.read(configApiProvider.future);

      if (config == null) {
        debugPrint('[Config] 远程配置拉取失败');
        log.w(() => '远程配置拉取失败');
        return;
      }

      debugPrint(
          '[Config] 远程配置拉取成功: sources=${config['sources']?.length ?? 0}, tags=${config['tags']?.length ?? 0}');
      log.d(() =>
          '远程配置拉取成功: sources=${config['sources']?.length ?? 0}, tags=${config['tags']?.length ?? 0}');

      if (needSources) {
        await _initializeSourceModels(uuid, config);
      } else {
        log.d(() => 'sources 已有数据，跳过初始化');
      }

      if (needProxies) {
        await _initializeProxies(uuid, config);
      } else {
        log.d(() => 'proxies 已有数据，跳过初始化');
      }

      final List<dynamic>? tags = config['tags'] as List<dynamic>?;
      if (tags != null && tags.isNotEmpty) {
        debugPrint('[Config] 即将用远程 ${tags.length} 个 tag 覆盖本地');
        try {
          await $ref
              .read(tagsStorageProvider.notifier)
              .replaceAllTagsFromConfig(tags, () => uuid.v4());
          $ref.invalidate(tagsStorageProvider);
          debugPrint('[Config] 已用远程 config 同步标签: ${tags.length} 个');
          log.d(() => '已用远程 config 同步标签: ${tags.length} 个');
        } catch (e, s) {
          log.e(() => 'replaceAllTagsFromConfig 失败: $e', e, s);
          debugPrint('[Config] 同步标签失败: $e');
        }
      } else {
        log.d(() => '远程无 tags 或 tags 已有数据，跳过');
      }
    } catch (e, s) {
      log.e(() => '加载远程配置失败: $e', e, s);
      debugPrint('[Config] 加载远程配置失败: $e');
    }
  }

  Future<void> _initializeSourceModels(
      Uuid uuid, Map<String, dynamic> config) async {
    try {
      log.d(
          () => '成功获取 sources 配置，共${config['sources']?.length ?? 0}个源');

      int savedCount = 0;
      for (final dynamic source in config['sources'] ?? <dynamic>[]) {
        try {
          final String id = uuid.v4();
          final String urlRaw = (source['url']?.toString() ?? '').trim();
          String url = urlRaw;
          if (url.isNotEmpty && !url.endsWith('/')) url += '/';
          if (url.isNotEmpty && !url.endsWith('api.php/provide/vod')) {
            url += 'api.php/provide/vod';
          }
          final SourceModel newSourceModel = SourceModel(
            uuid: id,
            name: (source['name']?.toString() ?? '').trim(),
            url: url,
            weight: IntConverter.toIntOrNull(source['weight']) ?? 5,
            tagIds: List<String>.from(source['tagIds'] ?? []),
          );
          await $ref
              .read(sourcesStorageProvider.notifier)
              .addSource(newSourceModel);
          savedCount++;
          log.d(() => '成功保存源: ${source['name']}');
        } catch (e, s) {
          log.w(() => '保存源${source['name']}失败: $e', e, s);
        }
      }
      log.d(() => '实际保存源数量: $savedCount');
    } catch (e, s) {
      log.e(() => '加载 sources 初始配置失败: $e', e, s);
    }
  }

  Future<void> _initializeProxies(Uuid uuid, Map<String, dynamic> config) async {
    try {
      log.d(() => '成功获取 proxies 配置');
      final dynamic proxy = config['proxy'];
      if (proxy != null && proxy is Map<String, dynamic>) {
        final ProxyModel newProxyModel = ProxyModel(
          uuid: uuid.v4(),
          url: (proxy['url']?.toString() ?? '').trim(),
          name: (proxy['name']?.toString() ?? '').trim(),
          enabled: proxy['enabled'] == true,
        );
        await $ref
            .read(proxiesStorageProvider.notifier)
            .addProxyModel(newProxyModel);
        log.d(() => '成功保存代理配置');
      }
    } catch (e, s) {
      log.e(() => '加载 proxies 初始配置失败: $e', e, s);
    }
  }

}
