// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebugModel _$DebugModelFromJson(Map<String, dynamic> json) => DebugModel(
  enable: json['enable'] as bool? ?? false,
  proxy: json['proxy'] as String?,
  proxyOptions: (json['proxyOptions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  demoMode: json['demoMode'] as bool? ?? false,
  keepScreenOn: json['keepScreenOn'] as bool? ?? false,
  translateKeyTips: json['translateKeyTips'] as bool? ?? false,
  switchLanguage: json['switchLanguage'] as bool? ?? false,
  switchTextScale: json['switchTextScale'] as bool? ?? false,
  switchThemeMode: json['switchThemeMode'] as bool? ?? false,
  timeDilation: (json['timeDilation'] as num?)?.toDouble() ?? 1.0,
  debugSeedColorEnabled: json['debugSeedColorEnabled'] as bool? ?? false,
  debugSeedColor: json['debugSeedColor'] as String?,
);

Map<String, dynamic> _$DebugModelToJson(DebugModel instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'proxy': instance.proxy,
      'proxyOptions': instance.proxyOptions,
      'demoMode': instance.demoMode,
      'keepScreenOn': instance.keepScreenOn,
      'translateKeyTips': instance.translateKeyTips,
      'switchLanguage': instance.switchLanguage,
      'switchTextScale': instance.switchTextScale,
      'switchThemeMode': instance.switchThemeMode,
      'timeDilation': instance.timeDilation,
      'debugSeedColorEnabled': instance.debugSeedColorEnabled,
      'debugSeedColor': instance.debugSeedColor,
    };
