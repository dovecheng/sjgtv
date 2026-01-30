import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base/log.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart';
import 'package:sjgtv/gen/assets.gen.dart';
import 'package:sjgtv/src/model/proxy.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/model/tag.dart';
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
    // Sources endpoints
    ..get('/api/sources', _handleGetSources)
    ..post('/api/sources', _handleAddSource)
    ..put('/api/sources/toggle', _handleToggleSource)
    ..delete('/api/sources', _handleDeleteSource)
    // Proxies endpoints
    ..get('/api/proxies', _handleGetProxies)
    ..post('/api/proxies', _handleAddProxy)
    ..put('/api/proxies/toggle', _handleToggleProxy)
    ..delete('/api/proxies', _handleDeleteProxy)
    // Tags endpoints
    ..get('/api/tags', _handleGetTags)
    ..post('/api/tags', _handleAddTag)
    ..put('/api/tags', _handleUpdateTag)
    ..put('/api/tags/order', _handleUpdateTagOrder)
    ..delete('/api/tags', _handleDeleteTag)
    // Search endpoint
    ..get('/api/search', _handleSearchRequest)
    // Static files
    ..get('/', staticHandler)
    ..get('/<any|.*>', staticHandler);

  final Handler handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  return await shelf_io.serve(handler, '0.0.0.0', port);
}

/// 数据存储类（Hive）
abstract final class SourceStorage {
  static const String _boxName = 'sources';
  static const String _proxyBoxName = 'proxies';
  static const String _tagBoxName = 'tags';

  // --- Source 方法 ---

  static Future<List<Source>> getAllSources() async {
    final Box<dynamic> box = Hive.box(_boxName);
    final List<Source> sources = box.values
        .map((dynamic e) => Source.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    sources.sort((Source a, Source b) => b.createdAt.compareTo(a.createdAt));
    return sources;
  }

  static Future<Source> addSource(Source source) async {
    final Box<dynamic> box = Hive.box(_boxName);
    await box.put(source.id, source.toJson());
    return source;
  }

  static Future<Source> toggleSource(String id) async {
    final Box<dynamic> box = Hive.box(_boxName);
    final dynamic data = box.get(id);
    if (data == null) throw Exception('源不存在');

    final Source source = Source.fromJson(Map<String, dynamic>.from(data));
    source.disabled = !source.disabled;
    source.updatedAt = DateTime.now();
    await box.put(id, source.toJson());
    return source;
  }

  static Future<void> deleteSource(String id) async {
    final Box<dynamic> box = Hive.box(_boxName);
    await box.delete(id);
  }

  // --- Proxy 方法 ---

  static Future<List<Proxy>> getAllProxies() async {
    final Box<dynamic> box = Hive.box(_proxyBoxName);
    final List<Proxy> proxies = box.values
        .map((dynamic e) => Proxy.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    proxies.sort((Proxy a, Proxy b) => b.createdAt.compareTo(a.createdAt));
    return proxies;
  }

  static Future<Proxy> addProxy(Proxy proxy) async {
    final Box<dynamic> box = Hive.box(_proxyBoxName);
    await box.put(proxy.id, proxy.toJson());
    return proxy;
  }

  static Future<Proxy> toggleProxy(String id) async {
    final Box<dynamic> box = Hive.box(_proxyBoxName);
    final dynamic data = box.get(id);
    if (data == null) throw Exception('代理不存在');

    final Proxy proxy = Proxy.fromJson(Map<String, dynamic>.from(data));
    proxy.enabled = !proxy.enabled;
    proxy.updatedAt = DateTime.now();
    await box.put(id, proxy.toJson());
    return proxy;
  }

  static Future<void> deleteProxy(String id) async {
    final Box<dynamic> box = Hive.box(_proxyBoxName);
    await box.delete(id);
  }

  // --- Tag 方法 ---

  static Future<List<Tag>> getAllTags() async {
    final Box<dynamic> box = Hive.box(_tagBoxName);
    final List<Tag> tags = box.values
        .map((dynamic e) => Tag.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    tags.sort((Tag a, Tag b) => a.order.compareTo(b.order));
    return tags;
  }

  static Future<Tag> addTag(Tag tag) async {
    final Box<dynamic> box = Hive.box(_tagBoxName);
    await box.put(tag.id, tag.toJson());
    return tag;
  }

  static Future<void> updateTag(Tag tag) async {
    final Box<dynamic> box = Hive.box(_tagBoxName);
    await box.put(tag.id, tag.toJson());
  }

  static Future<void> deleteTag(String id) async {
    final Box<dynamic> box = Hive.box(_tagBoxName);
    await box.delete(id);

    // 同时从所有源中移除此标签
    final Box<dynamic> sourceBox = Hive.box(_boxName);
    for (final dynamic key in sourceBox.keys) {
      final dynamic data = sourceBox.get(key);
      if (data != null) {
        final Source source = Source.fromJson(Map<String, dynamic>.from(data));
        if (source.tagIds.contains(id)) {
          source.tagIds.remove(id);
          await sourceBox.put(key, source.toJson());
        }
      }
    }
  }

  static Future<void> updateTagOrder(List<String> tagIds) async {
    final Box<dynamic> box = Hive.box(_tagBoxName);
    for (int i = 0; i < tagIds.length; i++) {
      final dynamic tagJson = box.get(tagIds[i]);
      if (tagJson != null) {
        final Tag tag = Tag.fromJson(Map<String, dynamic>.from(tagJson));
        tag.order = i;
        await box.put(tag.id, tag.toJson());
      }
    }
  }
}

// ============================================================================
// API Handlers - Sources
// ============================================================================

Future<Response> _handleGetSources(Request request) async {
  try {
    final List<Source> sources = await SourceStorage.getAllSources();
    return _createSuccessResponse(sources.map((Source s) => s.toJson()).toList());
  } catch (e) {
    return _createErrorResponse('获取源列表失败', 500, e);
  }
}

Future<Response> _handleAddSource(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['name'] == null || data['url'] == null) {
      throw Exception('名称和URL不能为空');
    }

    if (!_isValidUrl(data['url'])) {
      throw Exception('请输入有效的URL地址');
    }

    String apiUrl = data['url'].trim();
    if (!apiUrl.endsWith('/')) apiUrl += '/';
    if (!apiUrl.endsWith('api.php/provide/vod')) {
      apiUrl += 'api.php/provide/vod';
    }

    final Source source = Source(
      id: const Uuid().v4(),
      name: data['name'].trim(),
      url: apiUrl,
      weight: data['weight'] != null ? int.parse(data['weight'].toString()) : 5,
      tagIds: List<String>.from(data['tagIds'] ?? []),
    );

    final Source newSource = await SourceStorage.addSource(source);

    return _createSuccessResponse(newSource.toJson(), msg: '源添加成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleToggleSource(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    final Source updatedSource = await SourceStorage.toggleSource(id);
    return _createSuccessResponse(updatedSource.toJson());
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleDeleteSource(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    await SourceStorage.deleteSource(id);
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
    final List<Proxy> proxies = await SourceStorage.getAllProxies();
    return _createSuccessResponse(proxies.map((Proxy p) => p.toJson()).toList());
  } catch (e) {
    return _createErrorResponse('获取代理列表失败', 500, e);
  }
}

Future<Response> _handleAddProxy(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['url'] == null) {
      throw Exception('URL不能为空');
    }

    if (data['name'] == null) {
      throw Exception('代理名称不能为空');
    }

    final String url = data['url'].toString().trim();
    if (!_isValidUrl(url)) {
      throw Exception('请输入有效的URL地址');
    }

    final Proxy proxy = Proxy(id: const Uuid().v4(), url: url, name: data['name']);

    final Proxy newProxy = await SourceStorage.addProxy(proxy);

    return _createSuccessResponse(newProxy.toJson(), msg: '代理添加成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleToggleProxy(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    final Proxy updatedProxy = await SourceStorage.toggleProxy(id);
    return _createSuccessResponse(updatedProxy.toJson());
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleDeleteProxy(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    await SourceStorage.deleteProxy(id);
    return _createSuccessResponse(null);
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

// ============================================================================
// API Handlers - Tags
// ============================================================================

Future<Response> _handleGetTags(Request request) async {
  try {
    final List<Tag> tags = await SourceStorage.getAllTags();
    return _createSuccessResponse(tags.map((Tag t) => t.toJson()).toList());
  } catch (e) {
    return _createErrorResponse('获取标签列表失败', 500, e);
  }
}

Future<Response> _handleAddTag(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['name'] == null) {
      throw Exception('标签名称不能为空');
    }

    final List<Tag> tags = await SourceStorage.getAllTags();
    final int maxOrder = tags.isEmpty
        ? 0
        : tags.map((Tag t) => t.order).reduce((int a, int b) => a > b ? a : b);

    final Tag tag = Tag(
      id: const Uuid().v4(),
      name: data['name'].toString().trim(),
      color: data['color']?.toString() ?? '#4285F4',
      order: maxOrder + 1,
    );

    final Tag newTag = await SourceStorage.addTag(tag);

    return _createSuccessResponse(newTag.toJson(), msg: '标签添加成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleUpdateTag(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['id'] == null || data['name'] == null) {
      throw Exception('ID和名称不能为空');
    }

    final List<Tag> tags = await SourceStorage.getAllTags();
    final Tag existingTag = tags.firstWhere(
      (Tag t) => t.id == data['id'],
      orElse: () => throw Exception('标签不存在'),
    );

    final Tag updatedTag = Tag(
      id: existingTag.id,
      name: data['name'].toString().trim(),
      color: data['color']?.toString() ?? existingTag.color,
      order: existingTag.order,
      createdAt: existingTag.createdAt,
      updatedAt: DateTime.now(),
    );

    await SourceStorage.updateTag(updatedTag);

    return _createSuccessResponse(updatedTag.toJson(), msg: '标签更新成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleUpdateTagOrder(Request request) async {
  try {
    final String body = await request.readAsString();
    final dynamic data = jsonDecode(body);

    if (data['tagIds'] == null || data['tagIds'] is! List) {
      throw Exception('需要标签ID数组');
    }

    final List<String> tagIds = List<String>.from(data['tagIds']);
    await SourceStorage.updateTagOrder(tagIds);

    return _createSuccessResponse(null, msg: '标签顺序更新成功');
  } catch (e) {
    return _createErrorResponse(e.toString(), 400, e);
  }
}

Future<Response> _handleDeleteTag(Request request) async {
  try {
    final String? id = request.url.queryParameters['id'];
    if (id == null) throw Exception('缺少ID参数');

    await SourceStorage.deleteTag(id);
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
    final List<Source> sources = await SourceStorage.getAllSources();
    final List<Source> activeSources =
        sources.where((Source s) => !s.disabled).toList();

    if (activeSources.isEmpty) {
      return _createSuccessResponse({'list': <dynamic>[]}, msg: '没有可用的源');
    }

    final Box<dynamic> proxyBox = Hive.box(SourceStorage._proxyBoxName);
    final List<dynamic> proxyList = proxyBox.values.toList();
    final dynamic activeProxy = proxyList.firstWhere(
      (dynamic proxy) => proxy['enabled'] == true,
      orElse: () => null,
    );

    dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    final List<dynamic> results = await Future.wait<dynamic>(
      activeSources.map((Source source) async {
        final String baseUrl = activeProxy != null
            ? '${activeProxy['url']}/${source.url}'
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

    final List<dynamic> mergedList = _mergeResults(validResults, activeSources);

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

List<dynamic> _mergeResults(List<dynamic> results, List<Source> sources) {
  final List<dynamic> mergedList = <dynamic>[];
  final Set<String> seenIds = <String>{};

  for (int i = 0; i < results.length; i++) {
    final dynamic result = results[i];
    final int sourceWeight = sources[i].weight;

    for (final dynamic item in result['list']) {
      final String vodId = item['vod_id'].toString();
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
