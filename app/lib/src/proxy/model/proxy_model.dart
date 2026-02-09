import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/proxy.dart';

part 'proxy_model.g.dart';

/// 代理模型（API + Isar 共用）
@Name('Proxy')
@Collection(accessor: 'proxies')
@JsonSerializable()
class ProxyModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id? id;

  @JsonKey(name: 'id')
  String uuid;

  String url;
  String name;
  bool enabled;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProxyModel({
    this.id,
    required this.uuid,
    required this.url,
    required this.name,
    this.enabled = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ProxyModel.fromJson(Map<String, dynamic> json) =>
      _$ProxyModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyModelToJson(this);

  /// 转换为领域实体
  Proxy toEntity() {
    return Proxy(
      uuid: uuid,
      url: url,
      name: name,
      enabled: enabled,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 从领域实体创建模型
  factory ProxyModel.fromEntity(Proxy entity) {
    return ProxyModel(
      uuid: entity.uuid,
      url: entity.url,
      name: entity.name,
      enabled: entity.enabled,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
