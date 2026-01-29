import 'package:json_annotation/json_annotation.dart';

part 'debug_model.g.dart';

/// 调试配置
@JsonSerializable()
class DebugModel {
  /// 是否已启用调试模式
  bool enable;

  /// 代理
  String? proxy;

  /// 代理选项
  List<String>? proxyOptions;

  /// 演示模式
  bool demoMode;

  /// 保持屏幕常亮
  bool keepScreenOn;

  /// 国际化Key提示
  bool translateKeyTips;

  /// 切换语言种类
  bool switchLanguage;

  /// 切换字体缩放
  bool switchTextScale;

  /// 切换主题模式
  bool switchThemeMode;

  /// 动画慢放
  double timeDilation;

  /// 是否启用debug种子颜色
  bool debugSeedColorEnabled;

  /// debug种子颜色
  String? debugSeedColor;

  DebugModel({
    this.enable = false,
    this.proxy,
    this.proxyOptions,
    this.demoMode = false,
    this.keepScreenOn = false,
    this.translateKeyTips = false,
    this.switchLanguage = false,
    this.switchTextScale = false,
    this.switchThemeMode = false,
    this.timeDilation = 1.0,
    this.debugSeedColorEnabled = false,
    this.debugSeedColor,
  });

  factory DebugModel.fromJson(Map<String, dynamic> json) =>
      _$DebugModelFromJson(json);

  Map<String, dynamic> toJson() => _$DebugModelToJson(this);

  DebugModel copyWith({
    bool? enable,
    String? proxy,
    List<String>? proxyOptions,
    bool? demoMode,
    bool? keepScreenOn,
    bool? translateKeyTips,
    bool? switchLanguage,
    bool? switchTextScale,
    bool? switchThemeMode,
    double? timeDilation,
    bool? debugSeedColorEnabled,
    String? debugSeedColor,
  }) => DebugModel(
    enable: enable ?? this.enable,
    proxy: proxy ?? this.proxy,
    proxyOptions: proxyOptions ?? this.proxyOptions?.toList(),
    demoMode: demoMode ?? this.demoMode,
    keepScreenOn: keepScreenOn ?? this.keepScreenOn,
    translateKeyTips: translateKeyTips ?? this.translateKeyTips,
    switchLanguage: switchLanguage ?? this.switchLanguage,
    switchTextScale: switchTextScale ?? this.switchTextScale,
    switchThemeMode: switchThemeMode ?? this.switchThemeMode,
    timeDilation: timeDilation ?? this.timeDilation,
    debugSeedColorEnabled: debugSeedColorEnabled ?? this.debugSeedColorEnabled,
    debugSeedColor: debugSeedColor ?? this.debugSeedColor,
  );
}
