/// 应用常量定义
class AppConstants {
  AppConstants._();

  // 应用信息
  static const String appName = 'SJGTV';
  static const String appVersion = '1.0.0';

  // 网络相关
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 15);

  // UI 相关
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double focusBorderWidth = 3.0;
  static const double focusScaleFactor = 1.08;

  // 布局相关
  static const double horizontalPadding = 24.0;
  static const double verticalPadding = 16.0;
  static const double gridSpacing = 16.0;
  static const int gridCrossAxisCount = 5;

  // 动画相关
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // 播放器相关
  static const int defaultVolume = 100;
  static const double defaultPlaybackSpeed = 1.0;
  static const Duration skipForwardDuration = Duration(seconds: 10);
  static const Duration skipBackwardDuration = Duration(seconds: 10);

  // 分页相关
  static const int defaultPageSize = 20;

  // 本地服务端口
  static const int localServerPort = 8023;
}

/// 存储键常量
class StorageKeys {
  StorageKeys._();

  static const String videoSources = 'video_sources';
  static const String proxies = 'proxies';
  static const String tags = 'tags';
  static const String recentVideos = 'recent_videos';
  static const String favorites = 'favorites';
  static const String settings = 'settings';
}

/// API 端点常量
class ApiEndpoints {
  ApiEndpoints._();

  static const String doubanMovieSearch =
      'https://movie.douban.com/j/search_subjects';
  static const String defaultConfigUrl = 'https://ktv.aini.us.kg/config.json';
}