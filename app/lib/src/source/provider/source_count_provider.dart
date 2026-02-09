import '../../../core/isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/source/model/source_model.dart';

part 'source_count_provider.g.dart';

/// 源数量提供者 [sourceCountStorageProvider]（用于判断是否需初始写入）
@Riverpod(keepAlive: true)
class SourceCountStorageProvider extends _$SourceCountStorageProvider {
  @override
  Future<int> build() async => $isar.sources.count();
}
