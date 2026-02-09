import 'package:collection/collection.dart';
import 'package:isar_community/isar.dart';

extension QueryExt<T> on Query<T> {
  /// 观察单个非空对象, 该方法会忽略delete操作和查询结果为空
  ///
  /// [fireImmediately] 是否立即执行一次查询
  Stream<T> watchFirst({bool fireImmediately = false}) =>
      watch(fireImmediately: fireImmediately)
          .where((List<T> event) => event.isNotEmpty)
          .map((List<T> event) => event.first);

  /// 观察单个对象, 如果为空, 如果为空可能被delete或查询结果为空
  ///
  /// [fireImmediately] 是否立即执行一次查询
  Stream<T?> watchFirstOrNull({bool fireImmediately = false}) => watch(
    fireImmediately: fireImmediately,
  ).map((List<T> event) => event.firstOrNull);
}

extension QueryBuilderExt<OBJ, R> on QueryBuilder<OBJ, R, QQueryOperations> {
  /// 观察单个非空对象, 该方法会忽略delete操作和查询结果为空
  ///
  /// [fireImmediately] 是否立即执行一次查询
  Stream<R> watchFirst({bool fireImmediately = false}) =>
      watch(fireImmediately: fireImmediately)
          .where((List<R> event) => event.isNotEmpty)
          .map((List<R> event) => event.first);

  /// 观察单个对象, 如果为空, 如果为空可能被delete或查询结果为空
  ///
  /// [fireImmediately] 是否立即执行一次查询
  Stream<R?> watchFirstOrNull({bool fireImmediately = false}) => watch(
    fireImmediately: fireImmediately,
  ).map((List<R> event) => event.firstOrNull);
}
