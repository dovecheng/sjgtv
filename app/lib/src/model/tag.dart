import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

/// 标签模型
@JsonSerializable()
class Tag {
  final String id;
  String name;
  String color;
  int order;
  DateTime createdAt;
  DateTime updatedAt;

  Tag({
    required this.id,
    required this.name,
    this.color = '#4285F4',
    required this.order,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
