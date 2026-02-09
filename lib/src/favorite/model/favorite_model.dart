import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sjgtv/domain/entities/favorite.dart';

part 'favorite_model.g.dart';

/// 收藏模型（Isar）
@Name('Favorite')
@Collection(accessor: 'favorites')
@JsonSerializable()
class FavoriteModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id? id;

  @Index()
  @JsonKey(name: 'id')
  String uuid;

  @Index()
  String movieId;

  String movieTitle;
  String movieCoverUrl;
  int movieYear;
  double movieRating;
  String sourceName;

  @Index()
  DateTime? createdAt;

  FavoriteModel({
    this.id,
    required this.uuid,
    required this.movieId,
    required this.movieTitle,
    required this.movieCoverUrl,
    required this.movieYear,
    required this.movieRating,
    required this.sourceName,
    this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  /// 转换为领域实体
  Favorite toEntity() {
    return Favorite(
      uuid: uuid,
      movieId: movieId,
      movieTitle: movieTitle,
      movieCoverUrl: movieCoverUrl,
      movieYear: movieYear,
      movieRating: movieRating,
      sourceName: sourceName,
      createdAt: createdAt,
    );
  }

  /// 从领域实体创建模型
  factory FavoriteModel.fromEntity(Favorite entity) {
    return FavoriteModel(
      uuid: entity.uuid,
      movieId: entity.movieId,
      movieTitle: entity.movieTitle,
      movieCoverUrl: entity.movieCoverUrl,
      movieYear: entity.movieYear,
      movieRating: entity.movieRating,
      sourceName: entity.sourceName,
      createdAt: entity.createdAt,
    );
  }
}