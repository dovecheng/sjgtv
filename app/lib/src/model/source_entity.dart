import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'source_entity.g.dart';

/// 数据源 Isar 实体（与 [Source] 域模型对应）
@collection
@JsonSerializable()
class SourceEntity {
  SourceEntity();

  Id id = Isar.autoIncrement;

  late String uuid;
  late String name;
  late String url;
  int weight = 5;
  bool disabled = false;
  List<String> tagIds = [];
  late DateTime createdAt;
  late DateTime updatedAt;

  factory SourceEntity.fromJson(Map<String, dynamic> json) =>
      _$SourceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SourceEntityToJson(this);
}
