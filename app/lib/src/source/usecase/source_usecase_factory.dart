import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/source/usecase/add_source_usecase.dart';
import 'package:sjgtv/src/source/usecase/get_sources_usecase.dart';

/// 视频源 Use Case 工厂
///
/// 负责创建和提供视频源相关的 Use Cases
class SourceUseCaseFactory {
  SourceUseCaseFactory._();

  /// 创建获取源列表 Use Case
  static GetSourcesUseCase createGetSourcesUseCase({
    required Future<List<dynamic>> Function() getSources,
  }) {
    return GetSourcesUseCase(
      getSources: () async {
        final result = await getSources();
        return result.map((e) => e as SourceModel).toList();
      },
    );
  }

  /// 创建添加源 Use Case
  static AddSourceUseCase createAddSourceUseCase({
    required Future<dynamic> Function(dynamic) addSource,
  }) {
    return AddSourceUseCase(
      addSource: (source) async {
        final result = await addSource(source);
        return result as SourceModel;
      },
    );
  }
}