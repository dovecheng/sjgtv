// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_language_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetL10nLanguageModelCollection on Isar {
  IsarCollection<L10nLanguageModel> get l10nLanguage => this.collection();
}

const L10nLanguageModelSchema = CollectionSchema(
  name: r'l10n_language',
  id: 2828632223020235378,
  properties: {
    r'displayName': PropertySchema(
      id: 0,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'isDefault': PropertySchema(
      id: 1,
      name: r'isDefault',
      type: IsarType.bool,
    ),
    r'isSelected': PropertySchema(
      id: 2,
      name: r'isSelected',
      type: IsarType.bool,
    ),
    r'languageTag': PropertySchema(
      id: 3,
      name: r'languageTag',
      type: IsarType.string,
    ),
  },

  estimateSize: _l10nLanguageModelEstimateSize,
  serialize: _l10nLanguageModelSerialize,
  deserialize: _l10nLanguageModelDeserialize,
  deserializeProp: _l10nLanguageModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _l10nLanguageModelGetId,
  getLinks: _l10nLanguageModelGetLinks,
  attach: _l10nLanguageModelAttach,
  version: '3.3.0',
);

int _l10nLanguageModelEstimateSize(
  L10nLanguageModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.languageTag.length * 3;
  return bytesCount;
}

void _l10nLanguageModelSerialize(
  L10nLanguageModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.displayName);
  writer.writeBool(offsets[1], object.isDefault);
  writer.writeBool(offsets[2], object.isSelected);
  writer.writeString(offsets[3], object.languageTag);
}

L10nLanguageModel _l10nLanguageModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = L10nLanguageModel(
    displayName: reader.readString(offsets[0]),
    id: id,
    isDefault: reader.readBoolOrNull(offsets[1]),
    isSelected: reader.readBoolOrNull(offsets[2]),
    languageTag: reader.readString(offsets[3]),
  );
  return object;
}

P _l10nLanguageModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _l10nLanguageModelGetId(L10nLanguageModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _l10nLanguageModelGetLinks(
  L10nLanguageModel object,
) {
  return [];
}

void _l10nLanguageModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  L10nLanguageModel object,
) {
  object.id = id;
}

extension L10nLanguageModelQueryWhereSort
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QWhere> {
  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension L10nLanguageModelQueryWhere
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QWhereClause> {
  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterWhereClause>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterWhereClause>
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

extension L10nLanguageModelQueryFilter
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QFilterCondition> {
  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'displayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  isDefaultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isDefault'),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  isDefaultIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isDefault'),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  isDefaultEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isDefault', value: value),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  isSelectedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isSelected'),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  isSelectedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isSelected'),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  isSelectedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSelected', value: value),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
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

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  languageTagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'languageTag', value: ''),
      );
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterFilterCondition>
  languageTagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'languageTag', value: ''),
      );
    });
  }
}

extension L10nLanguageModelQueryObject
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QFilterCondition> {}

extension L10nLanguageModelQueryLinks
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QFilterCondition> {}

extension L10nLanguageModelQuerySortBy
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QSortBy> {
  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByLanguageTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  sortByLanguageTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.desc);
    });
  }
}

extension L10nLanguageModelQuerySortThenBy
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QSortThenBy> {
  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByLanguageTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.asc);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QAfterSortBy>
  thenByLanguageTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageTag', Sort.desc);
    });
  }
}

extension L10nLanguageModelQueryWhereDistinct
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QDistinct> {
  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QDistinct>
  distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QDistinct>
  distinctByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDefault');
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QDistinct>
  distinctByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSelected');
    });
  }

  QueryBuilder<L10nLanguageModel, L10nLanguageModel, QDistinct>
  distinctByLanguageTag({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageTag', caseSensitive: caseSensitive);
    });
  }
}

extension L10nLanguageModelQueryProperty
    on QueryBuilder<L10nLanguageModel, L10nLanguageModel, QQueryProperty> {
  QueryBuilder<L10nLanguageModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<L10nLanguageModel, String, QQueryOperations>
  displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<L10nLanguageModel, bool?, QQueryOperations> isDefaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDefault');
    });
  }

  QueryBuilder<L10nLanguageModel, bool?, QQueryOperations>
  isSelectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSelected');
    });
  }

  QueryBuilder<L10nLanguageModel, String, QQueryOperations>
  languageTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageTag');
    });
  }
}
