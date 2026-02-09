import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_datasource.dart';

/// 设置仓库实现
///
/// 实现 SettingsRepository 接口
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required this.localDataSource,
  });

  final LocalDataSource localDataSource;

  @override
  Future<Result<Settings, Failure>> getSettings() async {
    return localDataSource.getSettings();
  }

  @override
  Future<Result<Settings, Failure>> saveSettings(Settings settings) async {
    return localDataSource.saveSettings(settings);
  }

  @override
  Future<Result<Settings, Failure>> updateSettings(Settings settings) async {
    return localDataSource.updateSettings(settings);
  }
}