import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/settings.dart';
import 'package:sjgtv/domain/repositories/settings_repository.dart';

/// 获取设置 Use Case
class GetSettingsUseCase {
  const GetSettingsUseCase(this.repository);

  final SettingsRepository repository;

  /// 执行获取
  Future<Result<Settings, Failure>> call() async {
    return repository.getSettings();
  }
}