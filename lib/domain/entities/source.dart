/// 视频源实体
///
/// 领域层的纯业务对象，不包含任何数据持久化或传输相关的逻辑
class Source {
  const Source({
    required this.uuid,
    required this.name,
    required this.url,
    required this.weight,
    required this.disabled,
    required this.tagIds,
    this.createdAt,
    this.updatedAt,
  });

  /// 视频源唯一标识
  final String uuid;

  /// 视频源名称
  final String name;

  /// 视频源 URL
  final String url;

  /// 权重（用于排序）
  final int weight;

  /// 是否禁用
  final bool disabled;

  /// 关联的标签 ID 列表
  final List<String> tagIds;

  /// 创建时间
  final DateTime? createdAt;

  /// 更新时间
  final DateTime? updatedAt;

  /// 创建副本
  Source copyWith({
    String? uuid,
    String? name,
    String? url,
    int? weight,
    bool? disabled,
    List<String>? tagIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Source(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      url: url ?? this.url,
      weight: weight ?? this.weight,
      disabled: disabled ?? this.disabled,
      tagIds: tagIds ?? this.tagIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Source && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'Source(uuid: $uuid, name: $name, url: $url, weight: $weight, disabled: $disabled)';
  }
}