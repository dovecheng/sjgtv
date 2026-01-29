// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_icon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppIconModel _$AppIconModelFromJson(Map<String, dynamic> json) => AppIconModel(
  iconName: json['iconName'] as String,
  iosIconName: json['iosIconName'] as String?,
  androidIconName: json['androidIconName'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$AppIconModelToJson(AppIconModel instance) =>
    <String, dynamic>{
      'iconName': instance.iconName,
      'iosIconName': instance.iosIconName,
      'androidIconName': instance.androidIconName,
      'isDefault': instance.isDefault,
    };
