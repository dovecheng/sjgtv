/// 标签实体
///
/// 领域层的纯业务对象，不包含任何数据持久化或传输相关的逻辑
class Tag {
  const Tag({
    required this.uuid,
    required this.name,
    required this.color,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });

  /// 标签唯一标识
  final String uuid;

  /// 标签名称
  final String name;

  /// 标签颜色（十六进制）
  final String color;

  /// 排序顺序
  final int order;

  /// 创建时间
  final DateTime? createdAt;

  /// 更新时间
  final DateTime? updatedAt;

  /// 创建副本
  Tag copyWith({
    String? uuid,
    String? name,
    String? color,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tag(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      color: color ?? this.color,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'Tag(uuid: $uuid, name: $name, color: $color, order: $order)';
  }
}