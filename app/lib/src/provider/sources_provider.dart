import 'package:base/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/api/service/api_service.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/provider/api_service_provider.dart';

part 'sources_provider.g.dart';

/// 源列表提供者
///
/// 页面通过 [ref.watch] 监听，增删改或切换启用后 [ref.invalidate] 本提供者即可自动刷新。
@Riverpod(keepAlive: true)
class SourcesProvider extends _$SourcesProvider {
  @override
  Future<List<Source>> build() async {
    final ApiService api = ref.read(apiServiceProvider);
    final ApiListResultModel<Source> result = await api.getSources();
    if (result.isSuccess && result.data != null) {
      return result.data!;
    }
    throw Exception(result.message ?? '获取源列表失败');
  }
}
