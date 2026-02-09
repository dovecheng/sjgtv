import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../../domain/entities/source.dart';
import '../../domain/entities/proxy.dart';
import '../../domain/entities/tag.dart';

/// 本地数据源接口
///
/// 定义本地数据访问方法
abstract class LocalDataSource {
  /// 获取所有视频源
  Future<Result<List<Source>, Failure>> getAllSources();

  /// 添加视频源
  Future<Result<Source, Failure>> addSource(Source source);

  /// 更新视频源
  Future<Result<Source, Failure>> updateSource(Source source);

  /// 删除视频源
  Future<Result<void, Failure>> deleteSource(String uuid);

  /// 获取所有代理
  Future<Result<List<Proxy>, Failure>> getAllProxies();

  /// 获取启用的代理
  Future<Result<List<Proxy>, Failure>> getEnabledProxies();

  /// 添加代理
  Future<Result<Proxy, Failure>> addProxy(Proxy proxy);

  /// 更新代理
  Future<Result<Proxy, Failure>> updateProxy(Proxy proxy);

  /// 删除代理
  Future<Result<void, Failure>> deleteProxy(String uuid);

  /// 获取所有标签
  Future<Result<List<Tag>, Failure>> getAllTags();

  /// 添加标签
  Future<Result<Tag, Failure>> addTag(Tag tag);

  /// 更新标签
  Future<Result<Tag, Failure>> updateTag(Tag tag);

  /// 删除标签
  Future<Result<void, Failure>> deleteTag(String uuid);
}