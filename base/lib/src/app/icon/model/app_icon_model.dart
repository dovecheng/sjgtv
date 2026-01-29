import 'package:json_annotation/json_annotation.dart';

part 'app_icon_model.g.dart';

/// 应用图标配置实体类
@JsonSerializable()
class AppIconModel {
  /// 业务统一图标名称
  final String iconName;

  /// iOS图标名称
  ///
  /// 注意: 如需切换为默认图标需要传null
  final String? iosIconName;

  /// 安卓别名
  final String androidIconName;

  /// 是否为默认图标
  final bool isDefault;

  const AppIconModel({
    required this.iconName,
    required this.iosIconName,
    required this.androidIconName,
    this.isDefault = false,
  });

  factory AppIconModel.fromJson(Map<String, dynamic> json) =>
      _$AppIconModelFromJson(json);

  @override
  int get hashCode => iconName.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppIconModel &&
          runtimeType == other.runtimeType &&
          iconName == other.iconName;

  Map<String, dynamic> toJson() => _$AppIconModelToJson(this);
}
