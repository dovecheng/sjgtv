import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sjgtv/domain/entities/source.dart';

part 'source_model.g.dart';

/// 数据源模型（API + Isar 共用）
@Name('Source')
@Collection(accessor: 'sources')
@JsonSerializable()
class SourceModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id? id;

  @JsonKey(name: 'id')
  String uuid;

  String name;
  String url;
  int weight;
  bool disabled;
  List<String> tagIds;
  DateTime? createdAt;
  DateTime? updatedAt;

  SourceModel({
    this.id,
    required this.uuid,
    required this.name,
    required this.url,
    this.weight = 5,
    this.disabled = false,
    this.tagIds = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SourceModelToJson(this);

  /// 转换为领域实体
  Source toEntity() {
    return Source(
      uuid: uuid,
      name: name,
      url: url,
      weight: weight,
      disabled: disabled,
      tagIds: tagIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 从领域实体创建模型
  factory SourceModel.fromEntity(Source entity) {
    return SourceModel(
      uuid: entity.uuid,
      name: entity.name,
      url: entity.url,
      weight: entity.weight,
      disabled: entity.disabled,
      tagIds: entity.tagIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
