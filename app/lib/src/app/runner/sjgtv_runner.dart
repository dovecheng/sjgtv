import 'dart:io';

import 'package:base/base.dart';
import 'package:sjgtv/gen/l10n.gen.dart';
import 'package:sjgtv/src/app/provider/config_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';
import 'package:sjgtv/src/source/provider/source_count_provider.dart';
import 'package:sjgtv/src/proxy/provider/proxy_count_provider.dart';
import 'package:sjgtv/src/tag/provider/tag_count_provider.dart';
import 'package:sjgtv/src/proxy/provider/proxies_provider.dart';
import 'package:sjgtv/src/source/provider/sources_provider.dart';
import 'package:sjgtv/src/tag/provider/tags_provider.dart';
import 'package:sjgtv/src/app/provider/json_adapter_provider.dart';
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

  /// 注入 app 的 L10n.translations，与 base 的 L10n.translations 在 provider 内合并
  @override
  L10nTranslationProvider? get l10nTranslation =>
      L10nTranslationProvider(L10n.translations);

  /// 仅支持横屏
  @override
  List<DeviceOrientation> get preferredOrientations => const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  /// 使用 base 同一 Isar 实例，并注册 app 的 sources/proxies/tags schema
  @override
  IsarProvider? get isar => IsarProvider(
    schemas: [SourceModelSchema, ProxyModelSchema, TagModelSchema],
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

  /// 构建应用（仅支持暗黑模式，使用原生暗黑主题；title 来自 L10n app_title）
  @override
  Future<Widget> buildApp() async {
    final L10nTranslationModel tr = await $ref.read(
      l10nTranslationProvider.future,
    );
    final String title = tr['app_title'] ?? '苹果CMS电影播放器';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MovieHomePage(),
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
    final bool needTags = await $ref.read(tagCountStorageProvider.future) == 0;

    if (!needSources && !needProxies && !needTags) {
      log.d(() => 'sources/proxies/tags 已有数据，跳过初始化');
      return;
    }

    try {
      log.d(() => '开始加载远程配置...');
      final Map<String, dynamic>? config = await $ref.read(
        configApiProvider.future,
      );

      if (config == null || config.isEmpty) {
        log.w(() => '配置格式异常');
        return;
      }

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

      if (needTags) {
        await _initializeTagModels(uuid, config);
      } else {
        log.d(() => 'tags 已有数据，跳过初始化');
      }
    } catch (e, s) {
      log.e(() => '加载远程配置失败: $e', e, s);
    }
  }

  Future<void> _initializeSourceModels(
    Uuid uuid,
    Map<String, dynamic> config,
  ) async {
    try {
      log.d(() => '成功获取 sources 配置，共${config['sources']?.length ?? 0}个源');

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
              .read(sourcesProvider.notifier)
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

  Future<void> _initializeProxies(
    Uuid uuid,
    Map<String, dynamic> config,
  ) async {
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

  Future<void> _initializeTagModels(
    Uuid uuid,
    Map<String, dynamic> config,
  ) async {
    try {
      log.d(() => '成功获取 tags 配置，共${config['tags']?.length ?? 0}个标签');
      int tagCount = 0;
      for (final dynamic tag in config['tags'] ?? <dynamic>[]) {
        final TagModel newTagModel = TagModel(
          uuid: uuid.v4(),
          name: (tag['name']?.toString() ?? '').trim(),
          color: tag['color']?.toString() ?? '#4285F4',
          order: tagCount,
        );
        await $ref.read(tagsStorageProvider.notifier).addTagModel(newTagModel);
        tagCount++;
        log.d(() => '成功保存标签: ${tag['name']}');
      }
      log.d(() => '实际保存标签数量: $tagCount');
    } catch (e, s) {
      log.e(() => '加载 tags 初始配置失败: $e', e, s);
    }
  }
}
