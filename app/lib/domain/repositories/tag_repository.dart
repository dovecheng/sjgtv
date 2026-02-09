import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/tag.dart';

/// 标签仓库接口
///
/// 定义标签数据的访问方法，不关心具体实现细节
abstract class TagRepository {
  /// 获取所有标签（按排序顺序）
  Future<Result<List<Tag>, Failure>> getAllTags();

  /// 根据排序获取标签
  ///
  /// [order] 排序值
  Future<Result<List<Tag>, Failure>> getTagsByOrder(int order);

  /// 添加标签
  ///
  /// [tag] 标签实体
  Future<Result<Tag, Failure>> addTag(Tag tag);

  /// 更新标签
  ///
  /// [tag] 标签实体
  Future<Result<Tag, Failure>> updateTag(Tag tag);

  /// 删除标签
  ///
  /// [uuid] 标签 UUID
  Future<Result<void, Failure>> deleteTag(String uuid);

  /// 调整标签排序
  ///
  /// [uuids] 标签 UUID 列表（按新顺序）
  Future<Result<void, Failure>> reorderTags(List<String> uuids);
}