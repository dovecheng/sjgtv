extension StreamFirstOfNullExt<T> on Stream<T> {
  /// The first event of this stream or null.
  Future<T?> get firstOfNull async {
    await for (T value in this) {
      return value;
    }
    return null;
  }
}

extension StreamFirstWhereOrNullExt<T> on Stream<T> {
  /// Finds the first event of this stream matching [test] or null.
  Future<T?> firstWhereOrNull(bool Function(T t) test) async {
    await for (T value in this) {
      if (test(value)) {
        return value;
      }
    }
    return null;
  }
}

extension StreamLastOfNullExt<T> on Stream<T> {
  /// The last event of this stream or null.
  Future<T?> get lastOfNull async {
    T? result;
    await for (T value in this) {
      result = value;
    }
    return result;
  }
}

extension StreamLastOrNullWhereExt<T> on Stream<T> {
  /// Finds the last event in this stream matching [test] or null.
  Future<T?> lastWhereOrNull(bool Function(T t) test) async {
    T? result;
    await for (T value in this) {
      if (test(value)) {
        result = value;
      }
    }
    return result;
  }
}

extension StreamWhereNotNullExt<T> on Stream<T?> {
  @Deprecated('Use .nonNulls instead.')
  Stream<T> whereNotNull() => nonNulls;

  /// Returns a new lazy [Stream] with all events which are not null.
  Stream<T> get nonNulls => where((T? t) => t != null).cast();
}

extension StreamWhereTypeExt<T> on Stream<T> {
  ///  Returns a new lazy [Stream] with all events that have type [E].
  Stream<E> whereType<E>() =>
      E == dynamic ? this as Stream<E> : where((T t) => t is E).cast();
}

extension StreamElementAtOrNullExt<T> on Stream<T> {
  /// Returns the value of the [index]th data event of this stream or null.
  Future<T?> elementAtOrNull(int index) async {
    try {
      return await elementAt(index);
    } catch (_) {}
    return null;
  }
}
