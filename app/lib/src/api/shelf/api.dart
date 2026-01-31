import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base/converter.dart';
import 'package:base/log.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/services.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart';
import 'package:sjgtv/gen/assets.gen.dart';
import 'package:sjgtv/src/api/shelf/web_l10n.dart';
import 'package:sjgtv/src/proxy/proxy_model.dart';
import 'package:sjgtv/src/source/source_model.dart';
import 'package:sjgtv/src/tag/tag_model.dart';
import 'package:sjgtv/src/proxy/proxies_provider.dart';
import 'package:sjgtv/src/source/sources_storage_provider.dart';
import 'package:sjgtv/src/tag/tags_provider.dart';
import 'package:base/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final Log _log = Log('Api');

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
    // SourceModels endpoints
    ..get('/api/sources', _handleGetSourceModels)
    ..post('/api/sources', _handleAddSourceModel)
    ..put('/api/sources', _handleUpdateSourceModel)
    ..put('/api/sources/toggle', _handleToggleSourceModel)
    ..delete('/api/sources', _handleDeleteSourceModel)
    // Proxies endpoints
    ..get('/api/proxies', _handleGetProxies)
    ..post('/api/proxies', _handleAddProxyModel)
    ..put('/api/proxies/toggle', _handleToggleProxyModel)
    ..delete('/api/proxies', _handleDeleteProxyModel)
    // TagModels endpoints
    ..get('/api/tags', _handleGetTagModels)
    ..post('/api/tags', _handleAddTagModel)
    ..put('/api/tags', _handleUpdateTagModel)
    ..put('/api/tags/order', _handleUpdateTagModelOrder)
    ..delete('/api/tags', _handleDeleteTagModel)
    // Search endpoint
    ..get('/api/search', _handleSearchRequest)
    // 网页国际化：返回当前语言的 web_* 翻译 JSON
    ..get('/api/l10n', _handleGetL10n)
    // Static files
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

Future<Response> _handleGetSourceModels(Request request) async {
  try {
    final List<SourceModel> sources =
        await $ref.read(sourcesStorageProvider.future);
    return _createSuccessResponse(sources.map((SourceModel s) => s.toJson()).toList());
  } catch (e) {
    return _createErrorResponse('获取源列表失败', 500, e);
  }
}

Future<Response> _handleAddSourceModel(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['name'] == null || data['url'] == null) {
      throw Exception('名称和URL不能为空');
    }

    final String urlInput = (data['url']?.toString() ?? '').trim();
    if (!_isValidUrl(urlInput)) {
      throw Exception('请输入有效的URL地址');
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
        await $ref.read(sourcesStorageProvider.notifier).addSource(source);

    return _createSuccessResponse(newSourceModel.toJson(), msg: '源添加成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleUpdateSourceModel(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['id'] == null) throw Exception('缺少ID参数');
    if (data['name'] == null || data['url'] == null) {
      throw Exception('名称和URL不能为空');
    }

    final String urlInput = (data['url']?.toString() ?? '').trim();
    if (!_isValidUrl(urlInput)) {
      throw Exception('请输入有效的URL地址');
    }

    String url = urlInput;
    if (!url.endsWith('/')) url += '/';
    if (!url.endsWith('api.php/provide/vod')) {
      url += 'api.php/provide/vod';
    }

    final List<SourceModel> existing =
        await $ref.read(sourcesStorageProvider.future);
    SourceModel? src;
    for (final SourceModel s in existing) {
      if (s.uuid == data['id']) {
        src = s;
        break;
      }
    }
    if (src == null) throw Exception('源不存在');

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
        await $ref.read(sourcesStorageProvider.notifier).updateSource(updated);
    return _createSuccessResponse(result.toJson(), msg: '源更新成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleToggleSourceModel(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    final SourceModel updatedSourceModel =
        await $ref.read(sourcesStorageProvider.notifier).toggleSource(id);
    return _createSuccessResponse(updatedSourceModel.toJson());
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleDeleteSourceModel(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    await $ref.read(sourcesStorageProvider.notifier).deleteSource(id);
    return _createSuccessResponse(null);
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

// ============================================================================
// API Handlers - Proxies
// ============================================================================

Future<Response> _handleGetProxies(Request request) async {
  try {
    final List<ProxyModel> proxies =
        await $ref.read(proxiesStorageProvider.future);
    return _createSuccessResponse(proxies.map((ProxyModel p) => p.toJson()).toList());
  } catch (e) {
    return _createErrorResponse('获取代理列表失败', 500, e);
  }
}

Future<Response> _handleAddProxyModel(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['url'] == null) {
      throw Exception('URL不能为空');
    }

    if (data['name'] == null) {
      throw Exception('代理名称不能为空');
    }

    final String url = (data['url']?.toString() ?? '').trim();
    if (!_isValidUrl(url)) {
      throw Exception('请输入有效的URL地址');
    }

    final ProxyModel proxy = ProxyModel(
      uuid: const Uuid().v4(),
      url: url,
      name: (data['name']?.toString() ?? '').trim(),
    );

    final ProxyModel newProxyModel =
        await $ref.read(proxiesStorageProvider.notifier).addProxyModel(proxy);

    return _createSuccessResponse(newProxyModel.toJson(), msg: '代理添加成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleToggleProxyModel(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    final ProxyModel updatedProxyModel =
        await $ref.read(proxiesStorageProvider.notifier).toggleProxyModel(id);
    return _createSuccessResponse(updatedProxyModel.toJson());
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleDeleteProxyModel(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    await $ref.read(proxiesStorageProvider.notifier).deleteProxyModel(id);
    return _createSuccessResponse(null);
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

// ============================================================================
// API Handlers - TagModels
// ============================================================================

Future<Response> _handleGetTagModels(Request request) async {
  try {
    final List<TagModel> tags = await $ref.read(tagsStorageProvider.future);
    return _createSuccessResponse(tags.map((TagModel t) => t.toJson()).toList());
  } catch (e) {
    return _createErrorResponse('获取标签列表失败', 500, e);
  }
}

Future<Response> _handleAddTagModel(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['name'] == null) {
      throw Exception('标签名称不能为空');
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

    return _createSuccessResponse(newTagModel.toJson(), msg: '标签添加成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleUpdateTagModel(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['id'] == null || data['name'] == null) {
      throw Exception('ID和名称不能为空');
    }

    final List<TagModel> tags = await $ref.read(tagsStorageProvider.future);
    final TagModel existingTagModel = tags.firstWhere(
      (TagModel t) => t.uuid == data['id'],
      orElse: () => throw Exception('标签不存在'),
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

    return _createSuccessResponse(updatedTagModel.toJson(), msg: '标签更新成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleUpdateTagModelOrder(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['tagIds'] == null || data['tagIds'] is! List) {
      throw Exception('需要标签ID数组');
    }

    final List<String> tagIds = List<String>.from(data['tagIds']);
    await $ref.read(tagsStorageProvider.notifier).updateTagModelOrder(tagIds);

    return _createSuccessResponse(null, msg: '标签顺序更新成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleDeleteTagModel(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    await $ref.read(tagsStorageProvider.notifier).deleteTagModel(id);
    return _createSuccessResponse(null);
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

// ============================================================================
// API Handlers - Search
// ============================================================================

Future<Response> _handleSearchRequest(Request request) async {
  final String wd = request.url.queryParameters['wd'] ?? '';
  Dio? dio;

  try {
    final List<SourceModel> sources =
        await $ref.read(sourcesStorageProvider.future);
    final List<SourceModel> activeSourceModels =
        sources.where((SourceModel s) => !s.disabled).toList();

    if (activeSourceModels.isEmpty) {
      return _createSuccessResponse({'list': <dynamic>[]}, msg: '没有可用的源');
    }

    final List<ProxyModel> proxies =
        await $ref.read(proxiesStorageProvider.future);
    final List<ProxyModel> enabledProxies = proxies.where((ProxyModel p) => p.enabled).toList();
    final ProxyModel? activeProxyModel = enabledProxies.isEmpty ? null : enabledProxies.first;

    dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    final List<dynamic> results = await Future.wait<dynamic>(
      activeSourceModels.map((SourceModel source) async {
        final String baseUrl = activeProxyModel != null
            ? '${activeProxyModel.url}/${source.url}'
            : source.url;
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
      return _createSuccessResponse({'list': <dynamic>[]}, msg: '未找到相关内容');
    }

    final List<dynamic> mergedList = _mergeResults(validResults, activeSourceModels);

    return _createSuccessResponse({
      'total': mergedList.length,
      'list': mergedList,
    }, msg: '数据列表');
  } catch (e) {
    return _createErrorResponse("搜索失败: ${e.toString()}", 500, e);
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
      (dynamic a, dynamic b) => (b['vod_hits'] ?? 0).compareTo(a['vod_hits'] ?? 0));

  return mergedList;
}

// ============================================================================
// API Handlers - 网页国际化
// ============================================================================

Future<Response> _handleGetL10n(Request request) async {
  try {
    final Map<String, String> map = getWebL10nMap();
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
    return _createErrorResponse('获取翻译失败', 500, e);
  }
}

// ============================================================================
// Helper Functions
// ============================================================================

/// 成功响应，统一返回 { code, data, msg } 格式
Response _createSuccessResponse(dynamic data, {String? msg}) {
  return Response(
    200,
    body: jsonEncode({
      'code': 200,
      'data': data,
      'msg': msg,
    }),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Cache-Control': 'no-store',
    },
  );
}

/// 错误响应，统一返回 { code, data, msg } 格式
Response _createErrorResponse(String message, int status, dynamic error) {
  _log.e(() => 'Error $status: $message - $error', error);
  return Response(
    status,
    body: jsonEncode({
      'code': status,
      'data': null,
      'msg': message,
    }),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Cache-Control': 'no-store',
    },
  );
}

bool _isValidUrl(String url) {
  try {
    Uri.parse(url);
    return true;
  } catch (e) {
    return false;
  }
}
