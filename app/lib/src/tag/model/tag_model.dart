import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

/// 标签模型（API + Isar 共用）
@Name('Tag')
@Collection(accessor: 'tags')
@JsonSerializable()
class TagModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id? id;

  @JsonKey(name: 'id')
  String uuid;

  String name;
  String color;
  int order;
  DateTime? createdAt;
  DateTime? updatedAt;

  TagModel({
    this.id,
    required this.uuid,
    required this.name,
    this.color = '#4285F4',
    this.order = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);
}
