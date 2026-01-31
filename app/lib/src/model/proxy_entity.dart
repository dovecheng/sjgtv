import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'proxy_entity.g.dart';

/// 代理 Isar 实体（与 [Proxy] 域模型对应）
@collection
@JsonSerializable()
class ProxyEntity {
  ProxyEntity();

  Id id = Isar.autoIncrement;

  late String uuid;
  late String url;
  late String name;
  bool enabled = true;
  late DateTime createdAt;
  late DateTime updatedAt;

  factory ProxyEntity.fromJson(Map<String, dynamic> json) =>
      _$ProxyEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyEntityToJson(this);
}
