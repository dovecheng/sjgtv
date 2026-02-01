/// [Duration] 扩展：限制在 [min, max] 范围内
extension DurationClampExt on Duration {
  /// 将 Duration 限制在 [min, max] 范围内
  Duration clamp(Duration min, Duration max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}
