import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/settings.dart';

/// 设置仓库接口
///
/// 定义设置数据的访问方法
abstract class SettingsRepository {
  /// 获取设置
  Future<Result<Settings, Failure>> getSettings();

  /// 保存设置
  ///
  /// [settings] 设置实体
  Future<Result<Settings, Failure>> saveSettings(Settings settings);

  /// 更新设置
  ///
  /// [settings] 设置实体
  Future<Result<Settings, Failure>> updateSettings(Settings settings);
}