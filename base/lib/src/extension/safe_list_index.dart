/// Extension for List to get safe index where
extension SafeListIndexExtension<E> on List<E> {
  /// Returns the index of the first element that satisfies the provided
  int? safeIndexWhere(bool Function(E element) test, [int start = 0]) {
    int index = indexWhere(test, start);
    if (index != -1) {
      return index;
    }
    return null;
  }

  /// safeElementAtOrNull
  E? safeElementAtOrNull(int? index) {
    if (index == null || index < 0 || index >= length) {
      return null;
    }
    return elementAtOrNull(index);
  }

  /// safeIndexOfOrNull
  int? safeIndexOfOrNull(E element) {
    int index = indexOf(element);
    if (index == -1) {
      return null;
    }
    return index;
  }
}
