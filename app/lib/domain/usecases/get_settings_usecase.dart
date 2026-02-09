import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

/// 获取设置 Use Case
class GetSettingsUseCase {
  const GetSettingsUseCase(this.repository);

  final SettingsRepository repository;

  /// 执行获取
  Future<Result<Settings, Failure>> call() async {
    return repository.getSettings();
  }
}