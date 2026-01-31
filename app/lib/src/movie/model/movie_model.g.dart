// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  id: StringConverter.toStringifyOrEmpty(json['id']),
  title: StringConverter.toStringifyOrEmpty(json['title']),
  year: (MovieModel._readYear(json, 'year') as num).toInt(),
  rating: DoubleConverter.toDoubleOrZero(json['rate']),
  coverUrl: StringConverter.toStringifyOrNull(json['cover']),
  playable: BoolConverter.toBoolOrFalse(json['playable']),
  isNew: BoolConverter.toBoolOrFalse(json['is_new']),
  url: MovieModel._urlFromJson(json['url']),
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'rate': instance.rating,
      'cover': instance.coverUrl,
      'playable': instance.playable,
      'is_new': instance.isNew,
      'url': instance.url,
    };
