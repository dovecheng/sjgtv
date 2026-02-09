import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

/// 保存设置 Use Case
class SaveSettingsUseCase {
  const SaveSettingsUseCase(this.repository);

  final SettingsRepository repository;

  /// 执行保存
  Future<Result<Settings, Failure>> call(Settings settings) async {
    return repository.saveSettings(settings);
  }
}