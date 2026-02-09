import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/source.dart';

/// 视频源仓库接口
///
/// 定义视频源数据的访问方法，不关心具体实现细节
abstract class SourceRepository {
  /// 获取所有视频源
  Future<Result<List<Source>, Failure>> getAllSources();

  /// 根据标签获取视频源
  ///
  /// [tagId] 标签 ID
  Future<Result<List<Source>, Failure>> getSourcesByTag(String tagId);

  /// 添加视频源
  ///
  /// [source] 视频源实体
  Future<Result<Source, Failure>> addSource(Source source);

  /// 更新视频源
  ///
  /// [source] 视频源实体
  Future<Result<Source, Failure>> updateSource(Source source);

  /// 删除视频源
  ///
  /// [uuid] 视频 UUID
  Future<Result<void, Failure>> deleteSource(String uuid);

  /// 切换视频源启用/禁用状态
  ///
  /// [uuid] 视频 UUID
  Future<Result<Source, Failure>> toggleSource(String uuid);

  /// 测试视频源连接
  ///
  /// [uuid] 视频 UUID
  Future<Result<bool, Failure>> testSource(String uuid);
}
