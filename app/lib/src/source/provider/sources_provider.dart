import '../../../core/isar/isar.dart';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/source/model/source_model.dart';

part 'sources_provider.g.dart';

/// 源列表提供者 [sourcesProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
@Riverpod(keepAlive: true)
class SourcesProvider extends _$SourcesProvider {
  @override
  Future<List<SourceModel>> build() async {
    final List<SourceModel> list = await $isar.sources
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
    return list;
  }

  Future<SourceModel> addSource(SourceModel source) async {
    await $isar.writeTxn(() async => $isar.sources.put(source));
    ref.invalidateSelf();
    return source;
  }

  Future<List<SourceModel>> addSources(List<SourceModel> sources) async {
    await $isar.writeTxn(() async => $isar.sources.putAll(sources));
    ref.invalidateSelf();
    return sources;
  }

  Future<SourceModel> updateSource(SourceModel source) async {
    final List<SourceModel> list = await $isar.sources
        .where()
        .filter()
        .uuidEqualTo(source.uuid)
        .findAll();
    final SourceModel? e = list.isEmpty ? null : list.first;
    if (e == null) throw Exception('源不存在');
    e.name = source.name;
    e.url = source.url;
    e.weight = source.weight;
    e.tagIds = List<String>.from(source.tagIds);
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.sources.put(e));
    ref.invalidateSelf();
    return e;
  }

  Future<SourceModel> toggleSource(String uuid) async {
    final List<SourceModel> list = await $isar.sources
        .where()
        .filter()
        .uuidEqualTo(uuid)
        .findAll();
    final SourceModel? e = list.isEmpty ? null : list.first;
    if (e == null) throw Exception('源不存在');
    e.disabled = !e.disabled;
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.sources.put(e));
    ref.invalidateSelf();
    return e;
  }

  Future<void> deleteSource(String uuid) async {
    await $isar.writeTxn(() async {
      final List<SourceModel> list = await $isar.sources
          .where()
          .filter()
          .uuidEqualTo(uuid)
          .findAll();
      for (final SourceModel e in list) {
        if (e.id != null) await $isar.sources.delete(e.id!);
      }
    });
    ref.invalidateSelf();
  }
}
