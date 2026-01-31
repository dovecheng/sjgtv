import 'package:base/isar.dart';
import 'package:isar_community/isar.dart';
import 'package:sjgtv/src/model/proxy.dart';
import 'package:sjgtv/src/model/proxy_entity.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/model/source_entity.dart';
import 'package:sjgtv/src/model/tag.dart';
import 'package:sjgtv/src/model/tag_entity.dart';

/// 数据存储（使用 base 同一 Isar 实例，sources/proxies/tags）
abstract final class SourceStorage {
  // --- Source ---

  static Future<List<Source>> getAllSources() async {
    final List<SourceEntity> list = await $isar.sourceEntitys
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
    return list.map(_sourceFromEntity).toList();
  }

  static Future<Source> addSource(Source source) async {
    final SourceEntity e = _sourceToEntity(source);
    await $isar.writeTxn(() async => $isar.sourceEntitys.put(e));
    return source;
  }

  static Future<Source> updateSource(Source source) async {
    final List<SourceEntity> list = await $isar.sourceEntitys
        .where()
        .filter()
        .uuidEqualTo(source.id)
        .findAll();
    final SourceEntity? e = list.isEmpty ? null : list.first;
    if (e == null) throw Exception('源不存在');
    e.name = source.name;
    e.url = source.url;
    e.weight = source.weight;
    e.tagIds = List<String>.from(source.tagIds);
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.sourceEntitys.put(e));
    return _sourceFromEntity(e);
  }

  static Future<Source> toggleSource(String id) async {
    final List<SourceEntity> list = await $isar.sourceEntitys
        .where()
        .filter()
        .uuidEqualTo(id)
        .findAll();
    final SourceEntity? e = list.isEmpty ? null : list.first;
    if (e == null) throw Exception('源不存在');
    e.disabled = !e.disabled;
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.sourceEntitys.put(e));
    return _sourceFromEntity(e);
  }

  static Future<void> deleteSource(String id) async {
    await $isar.writeTxn(() async {
      final List<SourceEntity> list = await $isar.sourceEntitys
          .where()
          .filter()
          .uuidEqualTo(id)
          .findAll();
      for (final SourceEntity e in list) {
        await $isar.sourceEntitys.delete(e.id);
      }
    });
  }

  // --- Proxy ---

  static Future<List<Proxy>> getAllProxies() async {
    final List<ProxyEntity> list = await $isar.proxyEntitys
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
    return list.map(_proxyFromEntity).toList();
  }

  static Future<Proxy> addProxy(Proxy proxy) async {
    final ProxyEntity e = _proxyToEntity(proxy);
    await $isar.writeTxn(() async => $isar.proxyEntitys.put(e));
    return proxy;
  }

  static Future<Proxy> toggleProxy(String id) async {
    final List<ProxyEntity> list = await $isar.proxyEntitys
        .where()
        .filter()
        .uuidEqualTo(id)
        .findAll();
    final ProxyEntity? e = list.isEmpty ? null : list.first;
    if (e == null) throw Exception('代理不存在');
    e.enabled = !e.enabled;
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.proxyEntitys.put(e));
    return _proxyFromEntity(e);
  }

  static Future<void> deleteProxy(String id) async {
    await $isar.writeTxn(() async {
      final List<ProxyEntity> list = await $isar.proxyEntitys
          .where()
          .filter()
          .uuidEqualTo(id)
          .findAll();
      for (final ProxyEntity e in list) {
        await $isar.proxyEntitys.delete(e.id);
      }
    });
  }

  // --- Tag ---

  static Future<List<Tag>> getAllTags() async {
    final List<TagEntity> list = await $isar.tagEntitys
        .where()
        .sortByOrder()
        .findAll();
    return list.map(_tagFromEntity).toList();
  }

  static Future<Tag> addTag(Tag tag) async {
    final TagEntity e = _tagToEntity(tag);
    await $isar.writeTxn(() async => $isar.tagEntitys.put(e));
    return tag;
  }

  static Future<void> updateTag(Tag tag) async {
    final List<TagEntity> list = await $isar.tagEntitys
        .where()
        .filter()
        .uuidEqualTo(tag.id)
        .findAll();
    final TagEntity? e = list.isEmpty ? null : list.first;
    if (e == null) return;
    e.name = tag.name;
    e.color = tag.color;
    e.order = tag.order;
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.tagEntitys.put(e));
  }

  static Future<void> deleteTag(String id) async {
    await $isar.writeTxn(() async {
      final List<TagEntity> toDelete = await $isar.tagEntitys
          .where()
          .filter()
          .uuidEqualTo(id)
          .findAll();
      for (final TagEntity t in toDelete) {
        await $isar.tagEntitys.delete(t.id);
      }
      // 从所有源中移除此标签
      final List<SourceEntity> sources =
          await $isar.sourceEntitys.where().findAll();
      for (final SourceEntity s in sources) {
        if (s.tagIds.contains(id)) {
          s.tagIds.remove(id);
          s.updatedAt = DateTime.now();
          await $isar.sourceEntitys.put(s);
        }
      }
    });
  }

  static Future<void> updateTagOrder(List<String> tagIds) async {
    await $isar.writeTxn(() async {
      for (int i = 0; i < tagIds.length; i++) {
        final List<TagEntity> list = await $isar.tagEntitys
            .where()
            .filter()
            .uuidEqualTo(tagIds[i])
            .findAll();
        final TagEntity? e = list.isEmpty ? null : list.first;
        if (e != null) {
          e.order = i;
          e.updatedAt = DateTime.now();
          await $isar.tagEntitys.put(e);
        }
      }
    });
  }

  // --- 数量查询（用于初始配置是否为空）---

  static Future<int> get sourceCount =>
      $isar.sourceEntitys.count();
  static Future<int> get proxyCount =>
      $isar.proxyEntitys.count();
  static Future<int> get tagCount =>
      $isar.tagEntitys.count();

  // --- 转换 ---

  static Source _sourceFromEntity(SourceEntity e) => Source(
        id: e.uuid,
        name: e.name,
        url: e.url,
        weight: e.weight,
        disabled: e.disabled,
        tagIds: List<String>.from(e.tagIds),
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  static SourceEntity _sourceToEntity(Source s) {
    final SourceEntity e = SourceEntity()
      ..uuid = s.id
      ..name = s.name
      ..url = s.url
      ..weight = s.weight
      ..disabled = s.disabled
      ..tagIds = List<String>.from(s.tagIds)
      ..createdAt = s.createdAt
      ..updatedAt = s.updatedAt;
    return e;
  }

  static Proxy _proxyFromEntity(ProxyEntity e) => Proxy(
        id: e.uuid,
        url: e.url,
        name: e.name,
        enabled: e.enabled,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  static ProxyEntity _proxyToEntity(Proxy p) {
    final ProxyEntity e = ProxyEntity()
      ..uuid = p.id
      ..url = p.url
      ..name = p.name
      ..enabled = p.enabled
      ..createdAt = p.createdAt
      ..updatedAt = p.updatedAt;
    return e;
  }

  static Tag _tagFromEntity(TagEntity e) => Tag(
        id: e.uuid,
        name: e.name,
        color: e.color,
        order: e.order,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  static TagEntity _tagToEntity(Tag t) {
    final TagEntity e = TagEntity()
      ..uuid = t.id
      ..name = t.name
      ..color = t.color
      ..order = t.order
      ..createdAt = t.createdAt
      ..updatedAt = t.updatedAt;
    return e;
  }
}
