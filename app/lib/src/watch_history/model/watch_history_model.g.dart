// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_history_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWatchHistoryModelCollection on Isar {
  IsarCollection<WatchHistoryModel> get watchHistories => this.collection();
}

const WatchHistoryModelSchema = CollectionSchema(
  name: r'WatchHistory',
  id: -8125359517487482628,
  properties: {
    r'durationSeconds': PropertySchema(
      id: 0,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'episodeIndex': PropertySchema(
      id: 1,
      name: r'episodeIndex',
      type: IsarType.long,
    ),
    r'episodeName': PropertySchema(
      id: 2,
      name: r'episodeName',
      type: IsarType.string,
    ),
    r'movieCoverUrl': PropertySchema(
      id: 3,
      name: r'movieCoverUrl',
      type: IsarType.string,
    ),
    r'movieId': PropertySchema(id: 4, name: r'movieId', type: IsarType.string),
    r'movieTitle': PropertySchema(
      id: 5,
      name: r'movieTitle',
      type: IsarType.string,
    ),
    r'movieYear': PropertySchema(
      id: 6,
      name: r'movieYear',
      type: IsarType.long,
    ),
    r'playUrl': PropertySchema(id: 7, name: r'playUrl', type: IsarType.string),
    r'progressSeconds': PropertySchema(
      id: 8,
      name: r'progressSeconds',
      type: IsarType.long,
    ),
    r'sourceName': PropertySchema(
      id: 9,
      name: r'sourceName',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(id: 10, name: r'uuid', type: IsarType.string),
    r'watchedAt': PropertySchema(
      id: 11,
      name: r'watchedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _watchHistoryModelEstimateSize,
  serialize: _watchHistoryModelSerialize,
  deserialize: _watchHistoryModelDeserialize,
  deserializeProp: _watchHistoryModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _watchHistoryModelGetId,
  getLinks: _watchHistoryModelGetLinks,
  attach: _watchHistoryModelAttach,
  version: '3.3.0',
);

int _watchHistoryModelEstimateSize(
  WatchHistoryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.episodeName.length * 3;
  bytesCount += 3 + object.movieCoverUrl.length * 3;
  bytesCount += 3 + object.movieId.length * 3;
  bytesCount += 3 + object.movieTitle.length * 3;
  bytesCount += 3 + object.playUrl.length * 3;
  bytesCount += 3 + object.sourceName.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _watchHistoryModelSerialize(
  WatchHistoryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationSeconds);
  writer.writeLong(offsets[1], object.episodeIndex);
  writer.writeString(offsets[2], object.episodeName);
  writer.writeString(offsets[3], object.movieCoverUrl);
  writer.writeString(offsets[4], object.movieId);
  writer.writeString(offsets[5], object.movieTitle);
  writer.writeLong(offsets[6], object.movieYear);
  writer.writeString(offsets[7], object.playUrl);
  writer.writeLong(offsets[8], object.progressSeconds);
  writer.writeString(offsets[9], object.sourceName);
  writer.writeString(offsets[10], object.uuid);
  writer.writeDateTime(offsets[11], object.watchedAt);
}

WatchHistoryModel _watchHistoryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WatchHistoryModel(
    durationSeconds: reader.readLong(offsets[0]),
    episodeIndex: reader.readLong(offsets[1]),
    episodeName: reader.readString(offsets[2]),
    id: id,
    movieCoverUrl: reader.readString(offsets[3]),
    movieId: reader.readString(offsets[4]),
    movieTitle: reader.readString(offsets[5]),
    movieYear: reader.readLong(offsets[6]),
    playUrl: reader.readString(offsets[7]),
    progressSeconds: reader.readLong(offsets[8]),
    sourceName: reader.readString(offsets[9]),
    uuid: reader.readString(offsets[10]),
    watchedAt: reader.readDateTime(offsets[11]),
  );
  return object;
}

P _watchHistoryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _watchHistoryModelGetId(WatchHistoryModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _watchHistoryModelGetLinks(
  WatchHistoryModel object,
) {
  return [];
}

void _watchHistoryModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  WatchHistoryModel object,
) {
  object.id = id;
}

extension WatchHistoryModelQueryWhereSort
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QWhere> {
  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WatchHistoryModelQueryWhere
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QWhereClause> {
  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WatchHistoryModelQueryFilter
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QFilterCondition> {
  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationSeconds', value: value),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  durationSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  durationSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'episodeIndex', value: value),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'episodeIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'episodeIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'episodeIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'episodeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'episodeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'episodeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'episodeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'episodeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'episodeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'episodeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'episodeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'episodeName', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  episodeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'episodeName', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  idGreaterThan(Id? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  idLessThan(Id? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'movieCoverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movieCoverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movieCoverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movieCoverUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'movieCoverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'movieCoverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'movieCoverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'movieCoverUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieCoverUrl', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieCoverUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'movieCoverUrl', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'movieId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movieId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movieId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movieId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'movieId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'movieId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'movieId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'movieId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieId', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'movieId', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'movieTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movieTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movieTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movieTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'movieTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'movieTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'movieTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'movieTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieTitle', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'movieTitle', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieYearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieYear', value: value),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieYearGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movieYear',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieYearLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movieYear',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  movieYearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movieYear',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'playUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'playUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'playUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'playUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'playUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playUrl', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  playUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'playUrl', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  progressSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressSeconds', value: value),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  progressSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  progressSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  progressSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceName', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  sourceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceName', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uuid',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'uuid',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'uuid',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  watchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'watchedAt', value: value),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  watchedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'watchedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  watchedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'watchedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterFilterCondition>
  watchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'watchedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension WatchHistoryModelQueryObject
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QFilterCondition> {}

extension WatchHistoryModelQueryLinks
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QFilterCondition> {}

extension WatchHistoryModelQuerySortBy
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QSortBy> {
  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByEpisodeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeName', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByEpisodeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeName', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByMovieYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByPlayUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playUrl', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByPlayUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playUrl', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByProgressSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressSeconds', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByProgressSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressSeconds', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  sortByWatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.desc);
    });
  }
}

extension WatchHistoryModelQuerySortThenBy
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QSortThenBy> {
  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByEpisodeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeName', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByEpisodeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeName', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByMovieYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByPlayUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playUrl', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByPlayUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playUrl', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByProgressSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressSeconds', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByProgressSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressSeconds', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.asc);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QAfterSortBy>
  thenByWatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchedAt', Sort.desc);
    });
  }
}

extension WatchHistoryModelQueryWhereDistinct
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct> {
  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeIndex');
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByEpisodeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByMovieCoverUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'movieCoverUrl',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByMovieId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByMovieTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByMovieYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieYear');
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByPlayUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByProgressSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressSeconds');
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctBySourceName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct> distinctByUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchHistoryModel, WatchHistoryModel, QDistinct>
  distinctByWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'watchedAt');
    });
  }
}

extension WatchHistoryModelQueryProperty
    on QueryBuilder<WatchHistoryModel, WatchHistoryModel, QQueryProperty> {
  QueryBuilder<WatchHistoryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WatchHistoryModel, int, QQueryOperations>
  durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<WatchHistoryModel, int, QQueryOperations>
  episodeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeIndex');
    });
  }

  QueryBuilder<WatchHistoryModel, String, QQueryOperations>
  episodeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeName');
    });
  }

  QueryBuilder<WatchHistoryModel, String, QQueryOperations>
  movieCoverUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieCoverUrl');
    });
  }

  QueryBuilder<WatchHistoryModel, String, QQueryOperations> movieIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieId');
    });
  }

  QueryBuilder<WatchHistoryModel, String, QQueryOperations>
  movieTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieTitle');
    });
  }

  QueryBuilder<WatchHistoryModel, int, QQueryOperations> movieYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieYear');
    });
  }

  QueryBuilder<WatchHistoryModel, String, QQueryOperations> playUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playUrl');
    });
  }

  QueryBuilder<WatchHistoryModel, int, QQueryOperations>
  progressSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressSeconds');
    });
  }

  QueryBuilder<WatchHistoryModel, String, QQueryOperations>
  sourceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceName');
    });
  }

  QueryBuilder<WatchHistoryModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<WatchHistoryModel, DateTime, QQueryOperations>
  watchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'watchedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchHistoryModel _$WatchHistoryModelFromJson(Map<String, dynamic> json) =>
    WatchHistoryModel(
      uuid: json['id'] as String,
      movieId: json['movieId'] as String,
      movieTitle: json['movieTitle'] as String,
      movieCoverUrl: json['movieCoverUrl'] as String,
      movieYear: (json['movieYear'] as num).toInt(),
      episodeIndex: (json['episodeIndex'] as num).toInt(),
      episodeName: json['episodeName'] as String,
      playUrl: json['playUrl'] as String,
      progressSeconds: (json['progressSeconds'] as num).toInt(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      watchedAt: DateTime.parse(json['watchedAt'] as String),
      sourceName: json['sourceName'] as String,
    );

Map<String, dynamic> _$WatchHistoryModelToJson(WatchHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.uuid,
      'movieId': instance.movieId,
      'movieTitle': instance.movieTitle,
      'movieCoverUrl': instance.movieCoverUrl,
      'movieYear': instance.movieYear,
      'episodeIndex': instance.episodeIndex,
      'episodeName': instance.episodeName,
      'playUrl': instance.playUrl,
      'progressSeconds': instance.progressSeconds,
      'durationSeconds': instance.durationSeconds,
      'watchedAt': instance.watchedAt.toIso8601String(),
      'sourceName': instance.sourceName,
    };
