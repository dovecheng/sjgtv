/// 电影模型（豆瓣 API 数据）
class Movie {
  final String id;
  final String title;
  final int year;
  final double rating;
  final String? coverUrl;
  final bool playable;
  final bool isNew;
  final String url;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    this.coverUrl,
    required this.playable,
    required this.isNew,
    required this.url,
  });
}
