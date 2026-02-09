/// 收藏实体
///
/// 表示用户收藏的电影
class Favorite {
  const Favorite({
    required this.uuid,
    required this.movieId,
    required this.movieTitle,
    required this.movieCoverUrl,
    required this.movieYear,
    required this.movieRating,
    required this.sourceName,
    this.createdAt,
  });

  /// 唯一标识
  final String uuid;

  /// 电影ID
  final String movieId;

  /// 电影标题
  final String movieTitle;

  /// 封面URL
  final String movieCoverUrl;

  /// 年份
  final int movieYear;

  /// 评分
  final double movieRating;

  /// 源名称
  final String sourceName;

  /// 创建时间
  final DateTime? createdAt;

  /// 复制并修改部分属性
  Favorite copyWith({
    String? uuid,
    String? movieId,
    String? movieTitle,
    String? movieCoverUrl,
    int? movieYear,
    double? movieRating,
    String? sourceName,
    DateTime? createdAt,
  }) {
    return Favorite(
      uuid: uuid ?? this.uuid,
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
      movieCoverUrl: movieCoverUrl ?? this.movieCoverUrl,
      movieYear: movieYear ?? this.movieYear,
      movieRating: movieRating ?? this.movieRating,
      sourceName: sourceName ?? this.sourceName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
