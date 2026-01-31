import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_entity.g.dart';

/// 标签 Isar 实体（与 [Tag] 域模型对应）
@collection
@JsonSerializable()
class TagEntity {
  TagEntity();

  Id id = Isar.autoIncrement;

  late String uuid;
  late String name;
  String color = '#4285F4';
  int order = 0;
  late DateTime createdAt;
  late DateTime updatedAt;

  factory TagEntity.fromJson(Map<String, dynamic> json) =>
      _$TagEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TagEntityToJson(this);
}
