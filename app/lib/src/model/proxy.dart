import 'package:json_annotation/json_annotation.dart';

part 'proxy.g.dart';

/// 代理模型
@JsonSerializable()
class Proxy {
  final String id;
  final String url;
  final String name;
  bool enabled;
  DateTime createdAt;
  DateTime updatedAt;

  Proxy({
    required this.id,
    required this.url,
    required this.name,
    this.enabled = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Proxy.fromJson(Map<String, dynamic> json) => _$ProxyFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyToJson(this);
}
