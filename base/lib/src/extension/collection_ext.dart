extension CollectionRemoveNulllValueExt on Object? {
  bool _removeNullValue({bool recursive = false, bool removeEmpty = false}) {
    Object? value = this;
    if (value == null) {
      return true;
    } else if (recursive) {
      if (value is Map) {
        value.removeNullValue(recursive: recursive, removeEmpty: removeEmpty);
        if (removeEmpty && value.isEmpty) {
          return true;
        }
      } else if (value is Iterable) {
        if (value is List) {
          value.removeNullValue(recursive: recursive, removeEmpty: removeEmpty);
        } else if (value is Set) {
          value.removeNullValue(recursive: recursive, removeEmpty: removeEmpty);
        }
        if (removeEmpty && value.isEmpty) {
          return true;
        }
      }
    }
    return false;
  }
}

extension ListRemoveNullValueExt<T> on List<T> {
  /// 删除集合中的空值
  ///
  /// * [recursive] 递归删除
  /// * [removeEmpty] 移除空集合
  void removeNullValue({bool recursive = false, bool removeEmpty = false}) =>
      removeWhere(
        (T value) => value._removeNullValue(
          recursive: recursive,
          removeEmpty: removeEmpty,
        ),
      );
}

extension SetRemoveNullValueExt<T> on Set<T> {
  /// 删除集合中的空值
  ///
  /// * [recursive] 递归删除
  /// * [removeEmpty] 移除空集合
  void removeNullValue({bool recursive = false, bool removeEmpty = false}) =>
      removeWhere(
        (T value) => value._removeNullValue(
          recursive: recursive,
          removeEmpty: removeEmpty,
        ),
      );
}

extension MapRemoveNullValueExt<K, V> on Map<K, V> {
  /// 删除集合中的空值
  ///
  /// * [recursive] 递归删除
  /// * [removeEmpty] 移除空集合
  void removeNullValue({bool recursive = false, bool removeEmpty = false}) =>
      removeWhere(
        (K key, V value) => value._removeNullValue(
          recursive: recursive,
          removeEmpty: removeEmpty,
        ),
      );
}

extension IterableMapEntryToMapExt<K, V> on Iterable<MapEntry<K, V>> {
  /// 键值对集合转[Map]
  Map<K, V> toMap() => Map<K, V>.fromEntries(this);
}
