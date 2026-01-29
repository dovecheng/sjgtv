// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_translation_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetL10nTranslationModelCollection on Isar {
  IsarCollection<L10nTranslationModel> get l10nTransaction => this.collection();
}

const L10nTranslationModelSchema = CollectionSchema(
  name: r'l10n_translation',
  id: -3988185333484710647,
  properties: {
    r'languageTag': PropertySchema(
      id: 0,
      name: r'languageTag',
      type: IsarType.string,
    ),
    r'stringify': PropertySchema(
      id: 1,
      name: r'stringify',
      type: IsarType.string,
    ),
  },

  estimateSize: _l10nTranslationModelEstimateSize,
  serialize: _l10nTranslationModelSerialize,
  deserialize: _l10nTranslationModelDeserialize,
  deserializeProp: _l10nTranslationModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _l10nTranslationModelGetId,
  getLinks: _l10nTranslationModelGetLinks,
  attach: _l10nTranslationModelAttach,
  version: '3.3.0',
);

int _l10nTranslationModelEstimateSize(
  L10nTranslationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.languageTag.length * 3;
  bytesCount += 3 + object.stringify.length * 3;
  return bytesCount;
}

void _l10nTranslationModelSerialize(
  L10nTranslationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.languageTag);
  writer.writeString(offsets[1], object.stringify);
}

L10nTranslationModel _l10nTranslationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = L10nTranslationModel(
    id: id,
    languageTag: reader.readString(offsets[0]),
  );
  object.stringify = reader.readString(offsets[1]);
  return object;
}

P _l10nTranslationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _l10nTranslationModelGetId(L10nTranslationModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _l10nTranslationModelGetLinks(
  L10nTranslationModel object,
) {
  return [];
}

void _l10nTranslationModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  L10nTranslationModel object,
) {
  object.id = id;
}

extension L10nTranslationModelQueryWhereSort
    on QueryBuilder<L10nTranslationModel, L10nTranslationModel, QWhere> {
  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension L10nTranslationModelQueryWhere
    on QueryBuilder<L10nTranslationModel, L10nTranslationModel, QWhereClause> {
  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterWhereClause>
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

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterWhereClause>
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

extension L10nTranslationModelQueryFilter
    on
        QueryBuilder<
          L10nTranslationModel,
          L10nTranslationModel,
          QFilterCondition
        > {
  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'languageTag',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'languageTag',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'languageTag',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'languageTag',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'languageTag',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'languageTag',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'languageTag',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'languageTag',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'languageTag', value: ''),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  languageTagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'languageTag', value: ''),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stringify',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stringify',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stringify',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stringify',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stringify',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stringify',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stringify',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stringify',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stringify', value: ''),
      );
    });
  }

  QueryBuilder<
    L10nTranslationModel,
    L10nTranslationModel,
    QAfterFilterCondition
  >
  stringifyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stringify', value: ''),
      );
    });
  }
}

extension L10nTranslationModelQueryObject
    on
        QueryBuilder<
          L10nTranslationModel,
          L10nTranslationModel,
          QFilterCondition
        > {}

extension L10nTranslationModelQueryLinks
    on
        QueryBuilder<
          L10nTranslationModel,
          L10nTranslationModel,
          QFilterCondition
        > {}

extension L10nTranslationModelQuerySortBy
    on QueryBuilder<L10nTranslationModel, L10nTranslationModel, QSortBy> {
  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  sortByLanguageTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.asc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  sortByLanguageTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.desc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  sortByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.asc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  sortByStringifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.desc);
    });
  }
}

extension L10nTranslationModelQuerySortThenBy
    on QueryBuilder<L10nTranslationModel, L10nTranslationModel, QSortThenBy> {
  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  thenByLanguageTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.asc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  thenByLanguageTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.desc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  thenByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.asc);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QAfterSortBy>
  thenByStringifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.desc);
    });
  }
}

extension L10nTranslationModelQueryWhereDistinct
    on QueryBuilder<L10nTranslationModel, L10nTranslationModel, QDistinct> {
  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QDistinct>
  distinctByLanguageTag({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageTag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<L10nTranslationModel, L10nTranslationModel, QDistinct>
  distinctByStringify({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stringify', caseSensitive: caseSensitive);
    });
  }
}

extension L10nTranslationModelQueryProperty
    on
        QueryBuilder<
          L10nTranslationModel,
          L10nTranslationModel,
          QQueryProperty
        > {
  QueryBuilder<L10nTranslationModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<L10nTranslationModel, String, QQueryOperations>
  languageTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageTag');
    });
  }

  QueryBuilder<L10nTranslationModel, String, QQueryOperations>
  stringifyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stringify');
    });
  }
}
