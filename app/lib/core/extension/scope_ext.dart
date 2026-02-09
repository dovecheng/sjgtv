/// kotlin flavor extensions
extension ObjectScopeExt<T> on T {
  /// 调用代码块并返回结果
  ///
  /// 示例:
  ///
  /// ```dart
  /// String? result = obj?.let((it) => '${it.firstName} ${it.lastName}');
  /// ```
  R let<R>(R Function(T it) fn) => fn(this);

  /// 调用代码块并返回自身
  ///
  /// 示例:
  ///
  /// ```dart
  /// Map<String, String> map = {}.also((it){
  ///   it['key'] = 'value';
  /// });
  /// ```
  T also(void Function(T it) fn) {
    fn(this);
    return this;
  }

  /// 如果表达式为true，则返回它，否则返回null
  ///
  /// 示例:
  ///
  /// ```dart
  /// state.takeIf((it) => it.mounted)?.let((it) => it.setState((){}));
  /// ```
  T? takeIf(bool Function(T it) fn) => fn(this) ? this : null;

  /// 如果表达式为true，则返回null，否则返回它
  ///
  /// 示例:
  ///
  /// ```dart
  /// controller.takeUnless((it) => it.isDisposed)?.let((it) => it.dispose());
  /// ```
  T? takeUnless(bool Function(T it) fn) => fn(this) ? null : this;
}
