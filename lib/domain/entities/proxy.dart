/// 代理实体
///
/// 领域层的纯业务对象，不包含任何数据持久化或传输相关的逻辑
class Proxy {
  const Proxy({
    required this.uuid,
    required this.url,
    required this.name,
    required this.enabled,
    this.createdAt,
    this.updatedAt,
  });

  /// 代理唯一标识
  final String uuid;

  /// 代理 URL
  final String url;

  /// 代理名称
  final String name;

  /// 是否启用
  final bool enabled;

  /// 创建时间
  final DateTime? createdAt;

  /// 更新时间
  final DateTime? updatedAt;

  /// 创建副本
  Proxy copyWith({
    String? uuid,
    String? url,
    String? name,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Proxy(
      uuid: uuid ?? this.uuid,
      url: url ?? this.url,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Proxy && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'Proxy(uuid: $uuid, name: $name, url: $url, enabled: $enabled)';
  }
}
