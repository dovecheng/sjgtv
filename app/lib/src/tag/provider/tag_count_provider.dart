import '../../../core/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';

part 'tag_count_provider.g.dart';

/// 标签数量提供者 [tagCountStorageProvider]
@Riverpod(keepAlive: true)
class TagCountStorageProvider extends _$TagCountStorageProvider {
  @override
  Future<int> build() async => $isar.tags.count();
}
