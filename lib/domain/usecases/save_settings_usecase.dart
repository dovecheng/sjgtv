import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/settings.dart';
import 'package:sjgtv/domain/repositories/settings_repository.dart';

/// 保存设置 Use Case
class SaveSettingsUseCase {
  const SaveSettingsUseCase(this.repository);

  final SettingsRepository repository;

  /// 执行保存
  Future<Result<Settings, Failure>> call(Settings settings) async {
    return repository.saveSettings(settings);
  }
}
