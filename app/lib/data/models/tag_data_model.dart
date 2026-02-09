import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/tag.dart';

part 'tag_data_model.g.dart';

/// 标签模型（API + Isar 共用）
@Name('Tag')
@Collection(accessor: 'tags')
@JsonSerializable()
class TagDataModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id? id;

  @JsonKey(name: 'id')
  String uuid;

  String name;
  String color;
  int order;
  DateTime? createdAt;
  DateTime? updatedAt;

  TagDataModel({
    this.id,
    required this.uuid,
    required this.name,
    this.color = '#4285F4',
    this.order = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory TagDataModel.fromJson(Map<String, dynamic> json) =>
      _$TagDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagDataModelToJson(this);

  /// 转换为领域实体
  Tag toEntity() {
    return Tag(
      uuid: uuid,
      name: name,
      color: color,
      order: order,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 从领域实体创建模型
  factory TagDataModel.fromEntity(Tag entity) {
    return TagDataModel(
      uuid: entity.uuid,
      name: entity.name,
      color: entity.color,
      order: entity.order,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}