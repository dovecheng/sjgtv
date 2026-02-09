/// 设置实体
///
/// 表示用户的应用设置
class Settings {
  const Settings({
    required this.uuid,
    this.defaultVolume = 100.0,
    this.defaultPlaybackSpeed = 1.0,
    this.autoPlayNext = true,
    this.themeMode = AppThemeMode.system,
    this.language = 'zh_CN',
    this.createdAt,
    this.updatedAt,
  });

  /// 唯一标识（单例模式，只有一个 Settings 记录）
  final String uuid;

  /// 默认音量 (0-100)
  final double defaultVolume;

  /// 默认播放速度
  final double defaultPlaybackSpeed;

  /// 自动播放下一集
  final bool autoPlayNext;

  /// 主题模式
  final AppThemeMode themeMode;

  /// 语言
  final String language;

  /// 创建时间
  final DateTime? createdAt;

  /// 更新时间
  final DateTime? updatedAt;

  /// 复制并修改部分属性
  Settings copyWith({
    String? uuid,
    double? defaultVolume,
    double? defaultPlaybackSpeed,
    bool? autoPlayNext,
    AppThemeMode? themeMode,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Settings(
      uuid: uuid ?? this.uuid,
      defaultVolume: defaultVolume ?? this.defaultVolume,
      defaultPlaybackSpeed: defaultPlaybackSpeed ?? this.defaultPlaybackSpeed,
      autoPlayNext: autoPlayNext ?? this.autoPlayNext,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 主题模式枚举
enum AppThemeMode { system, light, dark }
