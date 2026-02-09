import '../../../core/isar.dart';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';

part 'tags_provider.g.dart';

/// 标签列表提供者 [tagsStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
@Riverpod(keepAlive: true)
class TagsStorageProvider extends _$TagsStorageProvider {
  @override
  Future<List<TagModel>> build() async {
    final List<TagModel> list = await $isar.tags
        .where()
        .sortByOrder()
        .findAll();
    return list;
  }

  Future<TagModel> addTagModel(TagModel tag) async {
    await $isar.writeTxn(() async => $isar.tags.put(tag));
    ref.invalidateSelf();
    return tag;
  }

  Future<void> updateTagModel(TagModel tag) async {
    final List<TagModel> list = await $isar.tags
        .where()
        .filter()
        .uuidEqualTo(tag.uuid)
        .findAll();
    final TagModel? e = list.isEmpty ? null : list.first;
    if (e == null) return;
    e.name = tag.name;
    e.color = tag.color;
    e.order = tag.order;
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.tags.put(e));
    ref.invalidateSelf();
  }

  Future<void> deleteTagModel(String uuid) async {
    await $isar.writeTxn(() async {
      final List<TagModel> toDelete = await $isar.tags
          .where()
          .filter()
          .uuidEqualTo(uuid)
          .findAll();
      for (final TagModel t in toDelete) {
        if (t.id != null) await $isar.tags.delete(t.id!);
      }
      final List<SourceModel> sources = await $isar.sources.where().findAll();
      for (final SourceModel s in sources) {
        if (s.tagIds.contains(uuid)) {
          s.tagIds.remove(uuid);
          s.updatedAt = DateTime.now();
          await $isar.sources.put(s);
        }
      }
    });
    ref.invalidateSelf();
  }

  /// 用远程 config 的 tags 全量替换本地（先删后加）
  Future<void> replaceAllTagsFromConfig(
    List<dynamic> tagsFromConfig,
    String Function() newUuid,
  ) async {
    if (tagsFromConfig.isEmpty) return;
    await $isar.writeTxn(() async {
      final List<TagModel> existing =
          await $isar.tags.where().anyId().findAll();
      for (final TagModel t in existing) {
        if (t.id != null) await $isar.tags.delete(t.id!);
      }
      final List<SourceModel> sources =
          await $isar.sources.where().anyId().findAll();
      for (final SourceModel s in sources) {
        s.tagIds = <String>[];
        s.updatedAt = DateTime.now();
        await $isar.sources.put(s);
      }
      int order = 0;
      for (final dynamic tag in tagsFromConfig) {
        final TagModel newTag = TagModel(
          uuid: newUuid(),
          name: (tag['name']?.toString() ?? '').trim(),
          color: tag['color']?.toString() ?? '#4285F4',
          order: order++,
        );
        await $isar.tags.put(newTag);
      }
    });
    ref.invalidateSelf();
  }

  Future<void> updateTagModelOrder(List<String> tagUuids) async {
    await $isar.writeTxn(() async {
      for (int i = 0; i < tagUuids.length; i++) {
        final List<TagModel> list = await $isar.tags
            .where()
            .filter()
            .uuidEqualTo(tagUuids[i])
            .findAll();
        final TagModel? e = list.isEmpty ? null : list.first;
        if (e != null) {
          e.order = i;
          e.updatedAt = DateTime.now();
          await $isar.tags.put(e);
        }
      }
    });
    ref.invalidateSelf();
  }
}
