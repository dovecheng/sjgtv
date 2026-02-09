// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDataModel _$MovieDataModelFromJson(Map<String, dynamic> json) =>
    MovieDataModel(
      id: StringConverter.toStringifyOrEmpty(json['id']),
      title: StringConverter.toStringifyOrEmpty(json['title']),
      year: (MovieDataModel._readYear(json, 'year') as num).toInt(),
      rating: DoubleConverter.toDoubleOrZero(json['rate']),
      coverUrl: StringConverter.toStringifyOrNull(json['cover']),
      playable: BoolConverter.toBoolOrFalse(json['playable']),
      isNew: BoolConverter.toBoolOrFalse(json['is_new']),
      url: MovieDataModel._urlFromJson(json['url']),
    );

Map<String, dynamic> _$MovieDataModelToJson(MovieDataModel instance) =>
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
