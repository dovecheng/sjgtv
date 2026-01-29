import 'package:base/base.dart';

/// CachedImageSize
extension DoubleResizeImageExtension on double {
  int? toCachedImageSize() {
    if (isFinite) {
      double devicePixelRatio = AppNavigator
          .context
          .flutterView
          .devicePixelRatio
          .clamp(1, 3);
      return (this * devicePixelRatio).toInt();
    }

    return null;
  }
}

/// CachedImageSize
extension IntResizeImageExtension on int {
  int? toCachedImageSize() {
    if (isFinite) {
      double devicePixelRatio = AppNavigator
          .context
          .flutterView
          .devicePixelRatio
          .clamp(1, 3);
      return (this * devicePixelRatio).toInt();
    }

    return null;
  }
}
