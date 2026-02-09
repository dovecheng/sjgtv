import '../../../core/converter/converter.dart';
import '../../../domain/entities/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_data_model.g.dart';

/// 电影模型（豆瓣 API 数据）
@JsonSerializable()
class MovieDataModel {
  @JsonKey(fromJson: StringConverter.toStringifyOrEmpty)
  final String id;
  @JsonKey(fromJson: StringConverter.toStringifyOrEmpty)
  final String title;
  @JsonKey(readValue: _readYear)
  final int year;
  @JsonKey(name: 'rate', fromJson: DoubleConverter.toDoubleOrZero)
  final double rating;
  @JsonKey(name: 'cover', fromJson: StringConverter.toStringifyOrNull)
  final String? coverUrl;
  @JsonKey(fromJson: BoolConverter.toBoolOrFalse)
  final bool playable;
  @JsonKey(name: 'is_new', fromJson: BoolConverter.toBoolOrFalse)
  final bool isNew;
  @JsonKey(
    name: 'url',
    fromJson: _urlFromJson,
  )
  final String url;

  MovieDataModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    this.coverUrl,
    required this.playable,
    required this.isNew,
    required this.url,
  });

  factory MovieDataModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDataModelToJson(this);

  /// 转换为领域实体
  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      year: year,
      rating: rating,
      coverUrl: coverUrl ?? '',
      playable: playable,
      isNew: isNew,
      url: url,
    );
  }

  /// 从领域实体创建模型
  factory MovieDataModel.fromEntity(Movie entity) {
    return MovieDataModel(
      id: entity.id,
      title: entity.title,
      year: entity.year,
      rating: entity.rating,
      coverUrl: entity.coverUrl,
      playable: entity.playable,
      isNew: entity.isNew,
      url: entity.url,
    );
  }

  static int _readYear(dynamic json, String key) {
    final Object? title = (json as Map)['title'];
    final String s = title?.toString() ?? '';
    final RegExpMatch? match = RegExp(r'\((\d{4})\)$').firstMatch(s);
    if (match != null) {
      final int? y = int.tryParse(match.group(1) ?? '');
      if (y != null) return y;
    }
    return DateTime.now().year;
  }

  static String _urlFromJson(Object? v) =>
      (v != null && v.toString().isNotEmpty)
          ? v.toString()
          : 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2897743122.jpg';
}