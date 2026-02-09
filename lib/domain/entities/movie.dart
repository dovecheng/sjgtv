/// 电影实体
///
/// 领域层的纯业务对象，不包含任何数据持久化或传输相关的逻辑
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.coverUrl,
    required this.playable,
    required this.isNew,
    required this.url,
  });

  /// 电影唯一标识
  final String id;

  /// 电影标题
  final String title;

  /// 上映年份
  final int year;

  /// 评分（0-10）
  final double rating;

  /// 封面图片 URL
  final String coverUrl;

  /// 是否可播放
  final bool playable;

  /// 是否为新片
  final bool isNew;

  /// 详情链接
  final String url;

  /// 创建副本
  Movie copyWith({
    String? id,
    String? title,
    int? year,
    double? rating,
    String? coverUrl,
    bool? playable,
    bool? isNew,
    String? url,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      coverUrl: coverUrl ?? this.coverUrl,
      playable: playable ?? this.playable,
      isNew: isNew ?? this.isNew,
      url: url ?? this.url,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, year: $year, rating: $rating)';
  }
}
