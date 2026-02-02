import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base/converter.dart';
import 'package:base/l10n.dart';
import 'package:base/log.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/services.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart';
import 'package:sjgtv/gen/assets.gen.dart';
import 'package:sjgtv/src/shelf/l10n/api_l10n.gen.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';
import 'package:sjgtv/src/proxy/provider/proxies_provider.dart';
import 'package:sjgtv/src/source/provider/sources_provider.dart';
import 'package:sjgtv/src/tag/provider/tags_provider.dart';
import 'package:base/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final Log _log = Log('Api');

/// 去掉重复的 vod/api.php/provide/，保证格式为 https://{domain}/api.php/provide/vod。
String _normalizeSourceBase(String url) {
  const String duplicate = '/vod/api.php/provide/';
  if (url.contains(duplicate)) {
    return url.replaceFirst(duplicate, '/');
  }
  return url;
}

/// 使用代理时：代理 origin + 规范化源 URL，格式为 /https://{domain}/api.php/provide/vod。
String _resolveBaseUrl(ProxyModel? proxy, String sourceUrl) {
  final String normalized = _normalizeSourceBase(sourceUrl);
  if (proxy == null) return normalized;
  final bool sourceIsAbsolute =
      normalized.startsWith('http://') || normalized.startsWith('https://');
  if (sourceIsAbsolute) {
    final Uri uri = Uri.parse(proxy.url);
    final String origin =
        '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}/';
    return origin + normalized;
  }
  return proxy.url;
}

/// shelf 本地 API 服务单例（混入 [ShelfApiL10nMixin]，方法内用 this.xxxL10n 获取翻译）
class ShelfApi with ShelfApiL10nMixin implements ShelfApiL10n {
  ShelfApi._();

  static ShelfApi? _instance;

  static ShelfApi get instance => _instance ??= ShelfApi._();

  /// 复制 assets 到文档目录
  Future<Directory> _copyAssetsToDocuments() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory webDir = Directory('${appDir.path}/web');

    if (!await webDir.exists()) {
      await webDir.create(recursive: true);
    }

    final Iterable<String> assets = Assets.web.values;

    for (final String asset in assets) {
      try {
        final String content = await rootBundle.loadString(asset);
        final String filename = asset.split('/').last;
        await File('${webDir.path}/$filename').writeAsString(content);
      } catch (e, s) {
        _log.w(() => 'Error copying $asset: $e', e, s);
      }
    }

    return webDir;
  }

  /// 启动 shelf 本地服务
  Future<HttpServer> startServer({int port = 8023}) async {
    final Directory webDir = await _copyAssetsToDocuments();

    final Handler staticHandler = createStaticHandler(
      webDir.path,
      defaultDocument: 'index.html',
    );

    final shelf_router.Router router = shelf_router.Router()
      ..options('/api/<any|.*>', (Request request) => Response.ok(''))
      ..get('/api/sources', handleGetSourceModels)
      ..post('/api/sources', handleAddSourceModel)
      ..put('/api/sources', handleUpdateSourceModel)
      ..put('/api/sources/toggle', handleToggleSourceModel)
      ..delete('/api/sources', handleDeleteSourceModel)
      ..get('/api/proxies', handleGetProxies)
      ..post('/api/proxies', handleAddProxyModel)
      ..put('/api/proxies/toggle', handleToggleProxyModel)
      ..delete('/api/proxies', handleDeleteProxyModel)
      ..get('/api/tags', handleGetTagModels)
      ..post('/api/tags', handleAddTagModel)
      ..put('/api/tags', handleUpdateTagModel)
      ..put('/api/tags/order', handleUpdateTagModelOrder)
      ..delete('/api/tags', handleDeleteTagModel)
      ..get('/api/search', handleSearchRequest)
      ..get('/api/l10n', handleGetL10n)
      ..get('/', staticHandler)
      ..get('/<any|.*>', staticHandler);

    final Handler handler = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(corsHeaders())
        .addHandler(router.call);

    return await shelf_io.serve(handler, '0.0.0.0', port);
  }

  // ============================================================================
  // API Handlers - SourceModels
  // ============================================================================

  Future<Response> handleGetSourceModels(Request request) async {
    try {
      final List<SourceModel> sources =
          await $ref.read(sourcesProvider.future);
      return createSuccessResponse(sources.map((SourceModel s) => s.toJson()).toList());
    } catch (e) {
      return createErrorResponse(getSourceListFailL10n, 500, e);
    }
  }

  Future<Response> handleAddSourceModel(Request request) async {
    try {
      final String body = await request.readAsString();
      final dynamic data = jsonDecode(body);

      if (data['name'] == null || data['url'] == null) {
        throw Exception(nameAndUrlRequiredL10n);
      }

      final String urlInput = (data['url']?.toString() ?? '').trim();
      if (!isValidUrl(urlInput)) {
        throw Exception(invalidUrlL10n);
      }

      String url = urlInput;
      if (!url.endsWith('/')) url += '/';
      if (!url.endsWith('api.php/provide/vod')) {
        url += 'api.php/provide/vod';
      }

      final SourceModel source = SourceModel(
        uuid: const Uuid().v4(),
        name: (data['name']?.toString() ?? '').trim(),
        url: url,
        weight: IntConverter.toIntOrNull(data['weight']) ?? 5,
        tagIds: List<String>.from(data['tagIds'] ?? []),
      );

      final SourceModel newSourceModel =
          await $ref.read(sourcesProvider.notifier).addSource(source);

      return createSuccessResponse(newSourceModel.toJson(), msg: sourceAddSuccessL10n);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleUpdateSourceModel(Request request) async {
    try {
      final String body = await request.readAsString();
      final dynamic data = jsonDecode(body);

      if (data['id'] == null) throw Exception(idRequiredL10n);
      if (data['name'] == null || data['url'] == null) {
        throw Exception(nameAndUrlRequiredL10n);
      }

      final String urlInput = (data['url']?.toString() ?? '').trim();
      if (!isValidUrl(urlInput)) {
        throw Exception(invalidUrlL10n);
      }

      String url = urlInput;
      if (!url.endsWith('/')) url += '/';
      if (!url.endsWith('api.php/provide/vod')) {
        url += 'api.php/provide/vod';
      }

      final List<SourceModel> existing =
          await $ref.read(sourcesProvider.future);
      SourceModel? src;
      for (final SourceModel s in existing) {
        if (s.uuid == data['id']) {
          src = s;
          break;
        }
      }
      if (src == null) throw Exception(sourceNotFoundL10n);

      final SourceModel updated = SourceModel(
        uuid: src.uuid,
        name: (data['name']?.toString() ?? '').trim(),
        url: url,
        weight: IntConverter.toIntOrNull(data['weight']) ?? src.weight,
        disabled: src.disabled,
        tagIds: List<String>.from(data['tagIds'] ?? src.tagIds),
        createdAt: src.createdAt,
        updatedAt: DateTime.now(),
      );

      final SourceModel result =
          await $ref.read(sourcesProvider.notifier).updateSource(updated);
      return createSuccessResponse(result.toJson(), msg: sourceUpdateSuccessL10n);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleToggleSourceModel(Request request) async {
    try {
      final String? id = request.url.queryParameters['id'];
      if (id == null) throw Exception(idRequiredL10n);

      final SourceModel updatedSourceModel =
          await $ref.read(sourcesProvider.notifier).toggleSource(id);
      return createSuccessResponse(updatedSourceModel.toJson());
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleDeleteSourceModel(Request request) async {
    try {
      final String? id = request.url.queryParameters['id'];
      if (id == null) throw Exception(idRequiredL10n);

      await $ref.read(sourcesProvider.notifier).deleteSource(id);
      return createSuccessResponse(null);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  // ============================================================================
  // API Handlers - Proxies
  // ============================================================================

  Future<Response> handleGetProxies(Request request) async {
    try {
      final List<ProxyModel> proxies =
          await $ref.read(proxiesStorageProvider.future);
      return createSuccessResponse(proxies.map((ProxyModel p) => p.toJson()).toList());
    } catch (e) {
      return createErrorResponse(getProxyListFailL10n, 500, e);
    }
  }

  Future<Response> handleAddProxyModel(Request request) async {
    try {
      final String body = await request.readAsString();
      final dynamic data = jsonDecode(body);

      if (data['url'] == null) {
        throw Exception(urlRequiredL10n);
      }

      if (data['name'] == null) {
        throw Exception(proxyNameRequiredL10n);
      }

      final String url = (data['url']?.toString() ?? '').trim();
      if (!isValidUrl(url)) {
        throw Exception(invalidUrlL10n);
      }

      final ProxyModel proxy = ProxyModel(
        uuid: const Uuid().v4(),
        url: url,
        name: (data['name']?.toString() ?? '').trim(),
      );

      final ProxyModel newProxyModel =
          await $ref.read(proxiesStorageProvider.notifier).addProxyModel(proxy);

      return createSuccessResponse(newProxyModel.toJson(), msg: proxyAddSuccessL10n);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleToggleProxyModel(Request request) async {
    try {
      final String? id = request.url.queryParameters['id'];
      if (id == null) throw Exception(idRequiredL10n);

      final ProxyModel updatedProxyModel =
          await $ref.read(proxiesStorageProvider.notifier).toggleProxyModel(id);
      return createSuccessResponse(updatedProxyModel.toJson());
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleDeleteProxyModel(Request request) async {
    try {
      final String? id = request.url.queryParameters['id'];
      if (id == null) throw Exception(idRequiredL10n);

      await $ref.read(proxiesStorageProvider.notifier).deleteProxyModel(id);
      return createSuccessResponse(null);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  // ============================================================================
  // API Handlers - TagModels
  // ============================================================================

  Future<Response> handleGetTagModels(Request request) async {
    try {
      final List<TagModel> tags = await $ref.read(tagsStorageProvider.future);
      return createSuccessResponse(tags.map((TagModel t) => t.toJson()).toList());
    } catch (e) {
      return createErrorResponse(getTagListFailL10n, 500, e);
    }
  }

  Future<Response> handleAddTagModel(Request request) async {
    try {
      final String body = await request.readAsString();
      final dynamic data = jsonDecode(body);

      if (data['name'] == null) {
        throw Exception(tagNameRequiredL10n);
      }

      final List<TagModel> tags = await $ref.read(tagsStorageProvider.future);
      final int maxOrder = tags.isEmpty
          ? 0
          : tags.map((TagModel t) => t.order).reduce((int a, int b) => a > b ? a : b);

      final TagModel tag = TagModel(
        uuid: const Uuid().v4(),
        name: (data['name']?.toString() ?? '').trim(),
        color: data['color']?.toString() ?? '#4285F4',
        order: maxOrder + 1,
      );

      final TagModel newTagModel =
          await $ref.read(tagsStorageProvider.notifier).addTagModel(tag);

      return createSuccessResponse(newTagModel.toJson(), msg: tagAddSuccessL10n);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleUpdateTagModel(Request request) async {
    try {
      final String body = await request.readAsString();
      final dynamic data = jsonDecode(body);

      if (data['id'] == null || data['name'] == null) {
        throw Exception(idAndNameRequiredL10n);
      }

      final List<TagModel> tags = await $ref.read(tagsStorageProvider.future);
      final TagModel existingTagModel = tags.firstWhere(
        (TagModel t) => t.uuid == data['id'],
        orElse: () => throw Exception(tagNotFoundL10n),
      );

      final TagModel updatedTagModel = TagModel(
        uuid: existingTagModel.uuid,
        name: (data['name']?.toString() ?? '').trim(),
        color: data['color']?.toString() ?? existingTagModel.color,
        order: existingTagModel.order,
        createdAt: existingTagModel.createdAt,
        updatedAt: DateTime.now(),
      );

      await $ref.read(tagsStorageProvider.notifier).updateTagModel(updatedTagModel);

      return createSuccessResponse(updatedTagModel.toJson(), msg: tagUpdateSuccessL10n);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleUpdateTagModelOrder(Request request) async {
    try {
      final String body = await request.readAsString();
      final dynamic data = jsonDecode(body);

      if (data['tagIds'] == null || data['tagIds'] is! List) {
        throw Exception(tagIdsArrayRequiredL10n);
      }

      final List<String> tagIds = List<String>.from(data['tagIds']);
      await $ref.read(tagsStorageProvider.notifier).updateTagModelOrder(tagIds);

      return createSuccessResponse(null, msg: tagOrderUpdateSuccessL10n);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  Future<Response> handleDeleteTagModel(Request request) async {
    try {
      final String? id = request.url.queryParameters['id'];
      if (id == null) throw Exception(idRequiredL10n);

      await $ref.read(tagsStorageProvider.notifier).deleteTagModel(id);
      return createSuccessResponse(null);
    } catch (e) {
      return createErrorResponse(e.toString(), 400, e);
    }
  }

  // ============================================================================
  // API Handlers - Search
  // ============================================================================

  Future<Response> handleSearchRequest(Request request) async {
    final String wd = request.url.queryParameters['wd'] ?? '';
    Dio? dio;

    try {
      final List<SourceModel> sources =
          await $ref.read(sourcesProvider.future);
      final List<SourceModel> activeSourceModels =
          sources.where((SourceModel s) => !s.disabled).toList();

      if (activeSourceModels.isEmpty) {
        return createSuccessResponse({'list': <dynamic>[]}, msg: noAvailableSourcesL10n);
      }

      final List<ProxyModel> proxies =
          await $ref.read(proxiesStorageProvider.future);
      final List<ProxyModel> enabledProxies =
          proxies.where((ProxyModel p) => p.enabled).toList();
      final ProxyModel? activeProxyModel =
          enabledProxies.isEmpty ? null : enabledProxies.first;

      dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 5);

      final List<dynamic> results = await Future.wait<dynamic>(
        activeSourceModels.map((SourceModel source) async {
          final String baseUrl =
              _resolveBaseUrl(activeProxyModel, source.url);
          final Map<String, String> queryParams = {'ac': 'videolist', 'wd': wd};

          try {
            final dynamic response = await dio!.get<dynamic>(
              baseUrl,
              queryParameters: queryParams,
              options: Options(
                headers: {
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                },
              ),
            );

            if (response.statusCode == 200) {
              final dynamic data = response.data;
              if (data is String) {
                return jsonDecode(data);
              }
              return data;
            }
            return null;
          } catch (e, s) {
            _log.w(() => '请求源 ${source.url} 失败: $e', e, s);
            return null;
          }
        }),
      );

      final List<dynamic> validResults = results
          .where(
            (dynamic r) =>
                r != null &&
                (r['code'] == 1 || r['code'] == '1') &&
                r['list'] != null &&
                (r['list'] as List<dynamic>).isNotEmpty,
          )
          .toList();

      if (validResults.isEmpty) {
        return createSuccessResponse({'list': <dynamic>[]}, msg: noSearchResultsL10n);
      }

      final List<dynamic> mergedList = _mergeResults(validResults, activeSourceModels);

      return createSuccessResponse(
        {'total': mergedList.length, 'list': mergedList},
        msg: dataListL10n,
      );
    } catch (e) {
      return createErrorResponse('$searchFailL10n: $e', 500, e);
    } finally {
      dio?.close();
    }
  }

  List<dynamic> _mergeResults(List<dynamic> results, List<SourceModel> sources) {
    final List<dynamic> mergedList = <dynamic>[];
    final Set<String> seenIds = <String>{};

    for (int i = 0; i < results.length; i++) {
      final dynamic result = results[i];
      final int sourceWeight = sources[i].weight;

      for (final dynamic item in result['list']) {
        final String vodId = item['vod_id']?.toString() ?? '';
        if (!seenIds.contains(vodId)) {
          seenIds.add(vodId);

          final Map<String, dynamic> weightedItem =
              Map<String, dynamic>.from(item);
          if (weightedItem['vod_hits'] != null) {
            weightedItem['vod_hits'] =
                (weightedItem['vod_hits'] * sourceWeight).round();
          }

          weightedItem['source'] = {
            'name': sources[i].name,
            'weight': sourceWeight,
          };

          mergedList.add(weightedItem);
        }
      }
    }

    mergedList.sort(
        (dynamic a, dynamic b) =>
            (b['vod_hits'] ?? 0).compareTo(a['vod_hits'] ?? 0));

    return mergedList;
  }

  // ============================================================================
  // API Handlers - 网页国际化
  // ============================================================================

  Future<Response> handleGetL10n(Request request) async {
    try {
      final L10nTranslationModel tr =
          $ref.read(l10nTranslationProvider).requireValue;
      final Map<String, String> map = Map.fromEntries(
        tr.entries.where((MapEntry<String, String> e) => e.key.startsWith('web_')),
      );
      return Response(
        200,
        body: jsonEncode(map),
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
          'Cache-Control': 'no-store',
        },
      );
    } catch (e, s) {
      _log.e(() => '获取网页翻译失败: $e', e, s);
      return createErrorResponse(getL10nFailL10n, 500, e);
    }
  }

  // ============================================================================
  // Helper
  // ============================================================================

  Response createSuccessResponse(dynamic data, {String? msg}) {
    return Response(
      200,
      body: jsonEncode({'code': 200, 'data': data, 'msg': msg}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cache-Control': 'no-store',
      },
    );
  }

  Response createErrorResponse(String message, int status, dynamic error) {
    _log.e(() => 'Error $status: $message - $error', error);
    return Response(
      status,
      body: jsonEncode({'code': status, 'data': null, 'msg': message}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cache-Control': 'no-store',
      },
    );
  }

  bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// 启动 shelf 本地服务（兼容原有调用方）
Future<HttpServer> startServer({int port = 8023}) =>
    ShelfApi.instance.startServer(port: port);
