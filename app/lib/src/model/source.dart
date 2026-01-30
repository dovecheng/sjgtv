import 'package:json_annotation/json_annotation.dart';

part 'source.g.dart';

/// 数据源模型
@JsonSerializable()
class Source {
  final String id;
  final String name;
  final String url;
  final int weight;
  bool disabled;
  List<String> tagIds;
  DateTime createdAt;
  DateTime updatedAt;

  Source({
    required this.id,
    required this.name,
    required this.url,
    this.weight = 5,
    this.disabled = false,
    this.tagIds = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}
