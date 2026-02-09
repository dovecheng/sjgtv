/// 观看历史实体
///
/// 领域层的纯业务对象，不包含任何数据访问细节
class WatchHistory {
  const WatchHistory({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.movieCoverUrl,
    required this.movieYear,
    required this.episodeIndex,
    required this.episodeName,
    required this.playUrl,
    required this.progress,
    required this.duration,
    required this.watchedAt,
    required this.sourceName,
  });

  /// 唯一标识符
  final String id;

  /// 电影 ID
  final String movieId;

  /// 电影标题
  final String movieTitle;

  /// 电影封面 URL
  final String movieCoverUrl;

  /// 电影年份
  final int movieYear;

  /// 剧集索引
  final int episodeIndex;

  /// 剧集名称
  final String episodeName;

  /// 播放 URL
  final String playUrl;

  /// 播放进度（秒）
  final Duration progress;

  /// 总时长（秒）
  final Duration duration;

  /// 观看时间
  final DateTime watchedAt;

  /// 视频源名称
  final String sourceName;

  /// 复制并更新部分字段
  WatchHistory copyWith({
    String? id,
    String? movieId,
    String? movieTitle,
    String? movieCoverUrl,
    int? movieYear,
    int? episodeIndex,
    String? episodeName,
    String? playUrl,
    Duration? progress,
    Duration? duration,
    DateTime? watchedAt,
    String? sourceName,
  }) {
    return WatchHistory(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
      movieCoverUrl: movieCoverUrl ?? this.movieCoverUrl,
      movieYear: movieYear ?? this.movieYear,
      episodeIndex: episodeIndex ?? this.episodeIndex,
      episodeName: episodeName ?? this.episodeName,
      playUrl: playUrl ?? this.playUrl,
      progress: progress ?? this.progress,
      duration: duration ?? this.duration,
      watchedAt: watchedAt ?? this.watchedAt,
      sourceName: sourceName ?? this.sourceName,
    );
  }

  /// 计算观看进度百分比（0-100）
  double get progressPercent {
    if (duration.inSeconds == 0) return 0.0;
    return (progress.inSeconds / duration.inSeconds * 100).clamp(0.0, 100.0);
  }

  /// 是否已观看完成（进度 > 90%）
  bool get isCompleted => progressPercent >= 90.0;
}