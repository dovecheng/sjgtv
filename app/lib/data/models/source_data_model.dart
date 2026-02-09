import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/source.dart';

part 'source_data_model.g.dart';

/// 数据源模型（API + Isar 共用）
@Name('Source')
@Collection(accessor: 'sources')
@JsonSerializable()
class SourceDataModel {
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

  SourceDataModel({
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

  factory SourceDataModel.fromJson(Map<String, dynamic> json) =>
      _$SourceDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SourceDataModelToJson(this);

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
  factory SourceDataModel.fromEntity(Source entity) {
    return SourceDataModel(
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