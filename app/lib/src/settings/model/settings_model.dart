import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sjgtv/domain/entities/settings.dart';

part 'settings_model.g.dart';

/// 设置模型（Isar）
@Name('Settings')
@Collection(accessor: 'settings')
@JsonSerializable()
class SettingsModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id? id;

  @JsonKey(name: 'id')
  String uuid;

  double defaultVolume;
  double defaultPlaybackSpeed;
  bool autoPlayNext;
  String themeMode;
  String language;
  DateTime? createdAt;
  DateTime? updatedAt;

  SettingsModel({
    this.id,
    required this.uuid,
    this.defaultVolume = 100.0,
    this.defaultPlaybackSpeed = 1.0,
    this.autoPlayNext = true,
    this.themeMode = 'system',
    this.language = 'zh_CN',
    this.createdAt,
    this.updatedAt,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  /// 转换为领域实体
  Settings toEntity() {
    return Settings(
      uuid: uuid,
      defaultVolume: defaultVolume,
      defaultPlaybackSpeed: defaultPlaybackSpeed,
      autoPlayNext: autoPlayNext,
      themeMode: _parseThemeMode(themeMode),
      language: language,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 从领域实体创建模型
  factory SettingsModel.fromEntity(Settings entity) {
    return SettingsModel(
      uuid: entity.uuid,
      defaultVolume: entity.defaultVolume,
      defaultPlaybackSpeed: entity.defaultPlaybackSpeed,
      autoPlayNext: entity.autoPlayNext,
      themeMode: _themeModeToString(entity.themeMode),
      language: entity.language,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  AppThemeMode _parseThemeMode(String value) {
    switch (value.toLowerCase()) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  static String _themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}