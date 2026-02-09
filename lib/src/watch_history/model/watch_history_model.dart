import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';

part 'watch_history_model.g.dart';

/// 观看历史模型（Isar + JSON）
@Name('WatchHistory')
@Collection(accessor: 'watchHistories')
@JsonSerializable()
class WatchHistoryModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id? id;

  @Index()
  @JsonKey(name: 'id')
  String uuid;

  /// 电影 ID
  @Index()
  String movieId;

  /// 电影标题
  String movieTitle;

  /// 电影封面 URL
  String movieCoverUrl;

  /// 电影年份
  int movieYear;

  /// 剧集索引
  int episodeIndex;

  /// 剧集名称
  String episodeName;

  /// 播放 URL
  String playUrl;

  /// 播放进度（秒）
  int progressSeconds;

  /// 总时长（秒）
  int durationSeconds;

  /// 观看时间
  @Index()
  DateTime watchedAt;

  /// 视频源名称
  String sourceName;

  WatchHistoryModel({
    this.id,
    required this.uuid,
    required this.movieId,
    required this.movieTitle,
    required this.movieCoverUrl,
    required this.movieYear,
    required this.episodeIndex,
    required this.episodeName,
    required this.playUrl,
    required this.progressSeconds,
    required this.durationSeconds,
    required this.watchedAt,
    required this.sourceName,
  });

  factory WatchHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$WatchHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$WatchHistoryModelToJson(this);

  /// 转换为领域实体
  WatchHistory toEntity() {
    return WatchHistory(
      id: uuid,
      movieId: movieId,
      movieTitle: movieTitle,
      movieCoverUrl: movieCoverUrl,
      movieYear: movieYear,
      episodeIndex: episodeIndex,
      episodeName: episodeName,
      playUrl: playUrl,
      progress: Duration(seconds: progressSeconds),
      duration: Duration(seconds: durationSeconds),
      watchedAt: watchedAt,
      sourceName: sourceName,
    );
  }

  /// 从领域实体创建模型
  factory WatchHistoryModel.fromEntity(WatchHistory entity) {
    return WatchHistoryModel(
      uuid: entity.id,
      movieId: entity.movieId,
      movieTitle: entity.movieTitle,
      movieCoverUrl: entity.movieCoverUrl,
      movieYear: entity.movieYear,
      episodeIndex: entity.episodeIndex,
      episodeName: entity.episodeName,
      playUrl: entity.playUrl,
      progressSeconds: entity.progress.inSeconds,
      durationSeconds: entity.duration.inSeconds,
      watchedAt: entity.watchedAt,
      sourceName: entity.sourceName,
    );
  }
}
