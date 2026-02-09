// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteModelCollection on Isar {
  IsarCollection<FavoriteModel> get favorites => this.collection();
}

const FavoriteModelSchema = CollectionSchema(
  name: r'Favorite',
  id: 5577971995748139032,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'movieCoverUrl': PropertySchema(
      id: 1,
      name: r'movieCoverUrl',
      type: IsarType.string,
    ),
    r'movieId': PropertySchema(id: 2, name: r'movieId', type: IsarType.string),
    r'movieRating': PropertySchema(
      id: 3,
      name: r'movieRating',
      type: IsarType.double,
    ),
    r'movieTitle': PropertySchema(
      id: 4,
      name: r'movieTitle',
      type: IsarType.string,
    ),
    r'movieYear': PropertySchema(
      id: 5,
      name: r'movieYear',
      type: IsarType.long,
    ),
    r'sourceName': PropertySchema(
      id: 6,
      name: r'sourceName',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(id: 7, name: r'uuid', type: IsarType.string),
  },

  estimateSize: _favoriteModelEstimateSize,
  serialize: _favoriteModelSerialize,
  deserialize: _favoriteModelDeserialize,
  deserializeProp: _favoriteModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'movieId': IndexSchema(
      id: -1138826636860436442,
      name: r'movieId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'movieId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _favoriteModelGetId,
  getLinks: _favoriteModelGetLinks,
  attach: _favoriteModelAttach,
  version: '3.3.0',
);

int _favoriteModelEstimateSize(
  FavoriteModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.movieCoverUrl.length * 3;
  bytesCount += 3 + object.movieId.length * 3;
  bytesCount += 3 + object.movieTitle.length * 3;
  bytesCount += 3 + object.sourceName.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _favoriteModelSerialize(
  FavoriteModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.movieCoverUrl);
  writer.writeString(offsets[2], object.movieId);
  writer.writeDouble(offsets[3], object.movieRating);
  writer.writeString(offsets[4], object.movieTitle);
  writer.writeLong(offsets[5], object.movieYear);
  writer.writeString(offsets[6], object.sourceName);
  writer.writeString(offsets[7], object.uuid);
}

FavoriteModel _favoriteModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteModel(
    createdAt: reader.readDateTimeOrNull(offsets[0]),
    id: id,
    movieCoverUrl: reader.readString(offsets[1]),
    movieId: reader.readString(offsets[2]),
    movieRating: reader.readDouble(offsets[3]),
    movieTitle: reader.readString(offsets[4]),
    movieYear: reader.readLong(offsets[5]),
    sourceName: reader.readString(offsets[6]),
    uuid: reader.readString(offsets[7]),
  );
  return object;
}

P _favoriteModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteModelGetId(FavoriteModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _favoriteModelGetLinks(FavoriteModel object) {
  return [];
}

void _favoriteModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  FavoriteModel object,
) {
  object.id = id;
}

extension FavoriteModelQueryWhereSort
    on QueryBuilder<FavoriteModel, FavoriteModel, QWhere> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension FavoriteModelQueryWhere
    on QueryBuilder<FavoriteModel, FavoriteModel, QWhereClause> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> uuidEqualTo(
    String uuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'uuid', value: [uuid]),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> uuidNotEqualTo(
    String uuid,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [uuid],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'uuid',
                lower: [],
                upper: [uuid],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause> movieIdEqualTo(
    String movieId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'movieId', value: [movieId]),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  movieIdNotEqualTo(String movieId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'movieId',
                lower: [],
                upper: [movieId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'movieId',
                lower: [movieId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'movieId',
                lower: [movieId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'movieId',
                lower: [],
                upper: [movieId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [null]),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  createdAtEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  createdAtNotEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  createdAtGreaterThan(DateTime? createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [createdAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  createdAtLessThan(DateTime? createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [],
          upper: [createdAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterWhereClause>
  createdAtBetween(
    DateTime? lowerCreatedAt,
    DateTime? upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FavoriteModelQueryFilter
    on QueryBuilder<FavoriteModel, FavoriteModel, QFilterCondition> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> idEqualTo(
    Id? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieCoverUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieCoverUrl', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieCoverUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'movieCoverUrl', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieId', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'movieId', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieRatingEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'movieRating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movieRating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movieRating',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movieRating',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieTitle', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'movieTitle', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  movieYearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieYear', value: value),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  sourceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceName', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  sourceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceName', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition> uuidMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uuid', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterFilterCondition>
  uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'uuid', value: ''),
      );
    });
  }
}

extension FavoriteModelQueryObject
    on QueryBuilder<FavoriteModel, FavoriteModel, QFilterCondition> {}

extension FavoriteModelQueryLinks
    on QueryBuilder<FavoriteModel, FavoriteModel, QFilterCondition> {}

extension FavoriteModelQuerySortBy
    on QueryBuilder<FavoriteModel, FavoriteModel, QSortBy> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByMovieCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByMovieCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByMovieId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByMovieIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByMovieRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieRating', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByMovieRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieRating', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByMovieTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByMovieTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByMovieYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortByMovieYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  sortBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension FavoriteModelQuerySortThenBy
    on QueryBuilder<FavoriteModel, FavoriteModel, QSortThenBy> {
  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByMovieCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByMovieCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieCoverUrl', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByMovieId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByMovieIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByMovieRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieRating', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByMovieRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieRating', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByMovieTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByMovieTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByMovieYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenByMovieYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieYear', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy>
  thenBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension FavoriteModelQueryWhereDistinct
    on QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> {
  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct>
  distinctByMovieCoverUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'movieCoverUrl',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctByMovieId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct>
  distinctByMovieRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieRating');
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctByMovieTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctByMovieYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieYear');
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctBySourceName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteModel, FavoriteModel, QDistinct> distinctByUuid({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension FavoriteModelQueryProperty
    on QueryBuilder<FavoriteModel, FavoriteModel, QQueryProperty> {
  QueryBuilder<FavoriteModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteModel, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FavoriteModel, String, QQueryOperations>
  movieCoverUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieCoverUrl');
    });
  }

  QueryBuilder<FavoriteModel, String, QQueryOperations> movieIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieId');
    });
  }

  QueryBuilder<FavoriteModel, double, QQueryOperations> movieRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieRating');
    });
  }

  QueryBuilder<FavoriteModel, String, QQueryOperations> movieTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieTitle');
    });
  }

  QueryBuilder<FavoriteModel, int, QQueryOperations> movieYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieYear');
    });
  }

  QueryBuilder<FavoriteModel, String, QQueryOperations> sourceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceName');
    });
  }

  QueryBuilder<FavoriteModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      uuid: json['id'] as String,
      movieId: json['movieId'] as String,
      movieTitle: json['movieTitle'] as String,
      movieCoverUrl: json['movieCoverUrl'] as String,
      movieYear: (json['movieYear'] as num).toInt(),
      movieRating: (json['movieRating'] as num).toDouble(),
      sourceName: json['sourceName'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'id': instance.uuid,
      'movieId': instance.movieId,
      'movieTitle': instance.movieTitle,
      'movieCoverUrl': instance.movieCoverUrl,
      'movieYear': instance.movieYear,
      'movieRating': instance.movieRating,
      'sourceName': instance.sourceName,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
