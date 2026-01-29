import 'dart:collection';

/// 包装请求结果节点.
///
/// 记录当前解析节点, 遇到解析错误时可以获取正在解析的节点位置.
abstract base class ApiDiagnosisModel<T> {
  /// 原始数据
  final T raw;

  /// 当前节点位置
  final Object? key;

  /// 子节点位置
  Object? _subKey;

  /// 父节点
  final ApiDiagnosisModel<Object?>? parent;

  /// 当前解析节点, 只会在[root]中保存.
  ApiDiagnosisModel<Object?>? _current;

  ApiDiagnosisModel(this.raw, {this.key, this.parent});

  /// 获取当前解析节点, 只会从[root]中获取.
  ApiDiagnosisModel<Object?> get current => root._current ?? root;

  /// 获取当前解析路径, 用于诊断解析错误的原因.
  String get path => <Object>[?parent?.path, ?key, ?subKey].join('/');

  /// 根节点
  ApiDiagnosisModel<Object?> get root => parent?.root ?? this;

  /// 获取子节点位置
  Object? get subKey => _subKey;

  /// 递归解除包装, 一般不需要调用, 因为解析后[List.of]会构建一个新的.
  static dynamic unwrap(Object? node) =>
      node is ApiDiagnosisModel ? unwrap(node.raw) : node;

  /// 包装集合或字典
  ///
  /// 基础数据不会包装, 但会在父节点中记录当前子节点位置.
  static dynamic wrap(
    Object? raw, {
    Object? key,
    ApiDiagnosisModel<Object?>? parent,
  }) {
    if (raw is ApiDiagnosisModel) {
      raw.root._current = raw;
      parent?._subKey = null;
      return raw;
    } else if (raw is List) {
      ApiListDiagnosisModel<Object?> node = ApiListDiagnosisModel<Object?>(
        raw,
        key: key,
        parent: parent,
      );
      parent?.root._current = node;
      parent?._subKey = null;
      return node;
    } else if (raw is Map) {
      Function factory = raw is Map<String, dynamic>
          ? ApiMapDiagnosisModel<String, dynamic>.new
          : ApiMapDiagnosisModel.new;
      ApiDiagnosisModel<Object?> node = factory(raw, key: key, parent: parent);
      parent?.root._current = node;
      parent?._subKey = null;
      return node;
    } else {
      parent?.root._current = parent;
      parent?._subKey = key;
      return raw;
    }
  }
}

/// 包装请求结果节点, 用于包装字典结构.
final class ApiMapDiagnosisModel<K, V> extends ApiDiagnosisModel<Map<K, V>>
    with MapMixin<K, V> {
  ApiMapDiagnosisModel(super.raw, {super.key, super.parent});

  @override
  Iterable<K> get keys => raw.keys;

  @override
  V operator [](Object? key) =>
      ApiDiagnosisModel.wrap(raw[key], key: key, parent: this);

  @override
  void operator []=(K key, V value) =>
      raw[key] = ApiDiagnosisModel.wrap(value, key: key, parent: this);

  @override
  void clear() => raw.clear();

  @override
  remove(Object? key) => raw.remove(key);
}

/// 包装请求结果节点, 用于包装列表结构.
final class ApiListDiagnosisModel<T> extends ApiDiagnosisModel<List<T>>
    with ListMixin<T> {
  ApiListDiagnosisModel(super.raw, {super.key, super.parent});

  @override
  int get length => raw.length;

  @override
  set length(int value) => raw.length = value;

  @override
  operator [](int index) =>
      ApiDiagnosisModel.wrap(raw[index], key: index, parent: this);

  @override
  void operator []=(int index, T value) =>
      raw[index] = ApiDiagnosisModel.wrap(value, key: index, parent: this);
}
