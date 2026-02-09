import '../../core/extension/extension.dart';
import 'package:collection/collection.dart';

extension EnumByIndexExt<T extends Enum> on List<T> {
  /// 根据[index]查找枚举, 非空
  T byIndexOrFirst(int? index) => byIndexOrNull(index) ?? first;

  /// 根据[index]查找枚举, 可空
  T? byIndexOrNull(int? index) => index
      ?.takeIf((int it) => it >= 0 && it < length)
      ?.let((int it) => this[it]);
}

extension EnumByNameExt<T extends Enum> on Iterable<T> {
  /// 根据[name]查找枚举, 非空
  T byNameOrFirst(String? name) => byNameOrNull(name) ?? first;

  /// 根据[name]查找枚举, 可空
  T? byNameOrNull(String? name) =>
      name?.let((String it) => firstWhereOrNull((T e) => e.name == it));
}

extension EnumByValueExt<T extends Enum> on Iterable<T> {
  /// 根据[value]查找枚举, 非空
  T byValueOrFirst(Comparable<Object?>? value) => byValueOrNull(value) ?? first;

  /// 根据[value]查找枚举, 可空
  T? byValueOrNull(Comparable<Object?>? value) => value?.let(
    (Comparable<Object?> it) =>
        firstWhereOrNull((Enum e) => (e as dynamic).value == it),
  );
}

extension EnumFirstWhereOrFirstExt<T extends Enum> on Iterable<T> {
  /// 根据[test]方法查找枚举, 非空
  T firstWhereOrFirst(bool Function(T element) test) =>
      firstWhereOrNull(test) ?? first;
}
