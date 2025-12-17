// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProjectCollection on Isar {
  IsarCollection<Project> get projects => this.collection();
}

const ProjectSchema = CollectionSchema(
  name: r'Project',
  id: 3302999628838485849,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _projectEstimateSize,
  serialize: _projectSerialize,
  deserialize: _projectDeserialize,
  deserializeProp: _projectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'assets': LinkSchema(
      id: -8948881940225602238,
      name: r'assets',
      target: r'AssetItem',
      single: false,
    ),
    r'properties': LinkSchema(
      id: 7287702992765806929,
      name: r'properties',
      target: r'PropertyItem',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _projectGetId,
  getLinks: _projectGetLinks,
  attach: _projectAttach,
  version: '3.1.0+1',
);

int _projectEstimateSize(
  Project object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _projectSerialize(
  Project object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.name);
}

Project _projectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Project();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.description = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  return object;
}

P _projectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _projectGetId(Project object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _projectGetLinks(Project object) {
  return [object.assets, object.properties];
}

void _projectAttach(IsarCollection<dynamic> col, Id id, Project object) {
  object.id = id;
  object.assets.attach(col, col.isar.collection<AssetItem>(), r'assets', id);
  object.properties
      .attach(col, col.isar.collection<PropertyItem>(), r'properties', id);
}

extension ProjectQueryWhereSort on QueryBuilder<Project, Project, QWhere> {
  QueryBuilder<Project, Project, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProjectQueryWhere on QueryBuilder<Project, Project, QWhereClause> {
  QueryBuilder<Project, Project, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Project, Project, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Project, Project, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Project, Project, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProjectQueryFilter
    on QueryBuilder<Project, Project, QFilterCondition> {
  QueryBuilder<Project, Project, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension ProjectQueryObject
    on QueryBuilder<Project, Project, QFilterCondition> {}

extension ProjectQueryLinks
    on QueryBuilder<Project, Project, QFilterCondition> {
  QueryBuilder<Project, Project, QAfterFilterCondition> assets(
      FilterQuery<AssetItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'assets');
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> assetsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assets', length, true, length, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> assetsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assets', 0, true, 0, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> assetsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assets', 0, false, 999999, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> assetsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assets', 0, true, length, include);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> assetsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assets', length, include, 999999, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> assetsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'assets', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> properties(
      FilterQuery<PropertyItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'properties');
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> propertiesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'properties', length, true, length, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> propertiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'properties', 0, true, 0, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> propertiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'properties', 0, false, 999999, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition>
      propertiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'properties', 0, true, length, include);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition>
      propertiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'properties', length, include, 999999, true);
    });
  }

  QueryBuilder<Project, Project, QAfterFilterCondition> propertiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'properties', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ProjectQuerySortBy on QueryBuilder<Project, Project, QSortBy> {
  QueryBuilder<Project, Project, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ProjectQuerySortThenBy
    on QueryBuilder<Project, Project, QSortThenBy> {
  QueryBuilder<Project, Project, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Project, Project, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ProjectQueryWhereDistinct
    on QueryBuilder<Project, Project, QDistinct> {
  QueryBuilder<Project, Project, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Project, Project, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Project, Project, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension ProjectQueryProperty
    on QueryBuilder<Project, Project, QQueryProperty> {
  QueryBuilder<Project, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Project, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Project, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Project, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssetItemCollection on Isar {
  IsarCollection<AssetItem> get assetItems => this.collection();
}

const AssetItemSchema = CollectionSchema(
  name: r'AssetItem',
  id: 5669538748134736219,
  properties: {
    r'auditDate': PropertySchema(
      id: 0,
      name: r'auditDate',
      type: IsarType.dateTime,
    ),
    r'auditLat': PropertySchema(
      id: 1,
      name: r'auditLat',
      type: IsarType.double,
    ),
    r'auditLong': PropertySchema(
      id: 2,
      name: r'auditLong',
      type: IsarType.double,
    ),
    r'category': PropertySchema(
      id: 3,
      name: r'category',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 4,
      name: r'description',
      type: IsarType.string,
    ),
    r'obsField': PropertySchema(
      id: 5,
      name: r'obsField',
      type: IsarType.string,
    ),
    r'photoPaths': PropertySchema(
      id: 6,
      name: r'photoPaths',
      type: IsarType.stringList,
    ),
    r'plate': PropertySchema(
      id: 7,
      name: r'plate',
      type: IsarType.string,
    ),
    r'serialNumber': PropertySchema(
      id: 8,
      name: r'serialNumber',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.byte,
      enumMap: _AssetItemstatusEnumValueMap,
    )
  },
  estimateSize: _assetItemEstimateSize,
  serialize: _assetItemSerialize,
  deserialize: _assetItemDeserialize,
  deserializeProp: _assetItemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _assetItemGetId,
  getLinks: _assetItemGetLinks,
  attach: _assetItemAttach,
  version: '3.1.0+1',
);

int _assetItemEstimateSize(
  AssetItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.obsField;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.photoPaths;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.plate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.serialNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _assetItemSerialize(
  AssetItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.auditDate);
  writer.writeDouble(offsets[1], object.auditLat);
  writer.writeDouble(offsets[2], object.auditLong);
  writer.writeString(offsets[3], object.category);
  writer.writeString(offsets[4], object.description);
  writer.writeString(offsets[5], object.obsField);
  writer.writeStringList(offsets[6], object.photoPaths);
  writer.writeString(offsets[7], object.plate);
  writer.writeString(offsets[8], object.serialNumber);
  writer.writeByte(offsets[9], object.status.index);
}

AssetItem _assetItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssetItem();
  object.auditDate = reader.readDateTimeOrNull(offsets[0]);
  object.auditLat = reader.readDoubleOrNull(offsets[1]);
  object.auditLong = reader.readDoubleOrNull(offsets[2]);
  object.category = reader.readString(offsets[3]);
  object.description = reader.readString(offsets[4]);
  object.id = id;
  object.obsField = reader.readStringOrNull(offsets[5]);
  object.photoPaths = reader.readStringList(offsets[6]);
  object.plate = reader.readStringOrNull(offsets[7]);
  object.serialNumber = reader.readStringOrNull(offsets[8]);
  object.status =
      _AssetItemstatusValueEnumMap[reader.readByteOrNull(offsets[9])] ??
          AuditStatus.pending;
  return object;
}

P _assetItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringList(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_AssetItemstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          AuditStatus.pending) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AssetItemstatusEnumValueMap = {
  'pending': 0,
  'found': 1,
  'notFound': 2,
  'seized': 3,
};
const _AssetItemstatusValueEnumMap = {
  0: AuditStatus.pending,
  1: AuditStatus.found,
  2: AuditStatus.notFound,
  3: AuditStatus.seized,
};

Id _assetItemGetId(AssetItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _assetItemGetLinks(AssetItem object) {
  return [];
}

void _assetItemAttach(IsarCollection<dynamic> col, Id id, AssetItem object) {
  object.id = id;
}

extension AssetItemQueryWhereSort
    on QueryBuilder<AssetItem, AssetItem, QWhere> {
  QueryBuilder<AssetItem, AssetItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssetItemQueryWhere
    on QueryBuilder<AssetItem, AssetItem, QWhereClause> {
  QueryBuilder<AssetItem, AssetItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<AssetItem, AssetItem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AssetItemQueryFilter
    on QueryBuilder<AssetItem, AssetItem, QFilterCondition> {
  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'auditDate',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      auditDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'auditDate',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'auditDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      auditDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'auditDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'auditDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'auditDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'auditLat',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      auditLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'auditLat',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'auditLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'auditLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'auditLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'auditLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLongIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'auditLong',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      auditLongIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'auditLong',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLongEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'auditLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      auditLongGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'auditLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLongLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'auditLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> auditLongBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'auditLong',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'obsField',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      obsFieldIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'obsField',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'obsField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'obsField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'obsField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'obsField',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'obsField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'obsField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'obsField',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'obsField',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> obsFieldIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'obsField',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      obsFieldIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'obsField',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> photoPathsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoPaths',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoPaths',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoPaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoPaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      photoPathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plate',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plate',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'plate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plate',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> plateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'plate',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serialNumber',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serialNumber',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> serialNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serialNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serialNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serialNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> serialNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serialNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serialNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serialNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serialNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> serialNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serialNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serialNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition>
      serialNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serialNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> statusEqualTo(
      AuditStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> statusGreaterThan(
    AuditStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> statusLessThan(
    AuditStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterFilterCondition> statusBetween(
    AuditStatus lower,
    AuditStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AssetItemQueryObject
    on QueryBuilder<AssetItem, AssetItem, QFilterCondition> {}

extension AssetItemQueryLinks
    on QueryBuilder<AssetItem, AssetItem, QFilterCondition> {}

extension AssetItemQuerySortBy on QueryBuilder<AssetItem, AssetItem, QSortBy> {
  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByAuditDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditDate', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByAuditDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditDate', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByAuditLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLat', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByAuditLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLat', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByAuditLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLong', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByAuditLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLong', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByObsField() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'obsField', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByObsFieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'obsField', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortBySerialNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serialNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortBySerialNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serialNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension AssetItemQuerySortThenBy
    on QueryBuilder<AssetItem, AssetItem, QSortThenBy> {
  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByAuditDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditDate', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByAuditDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditDate', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByAuditLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLat', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByAuditLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLat', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByAuditLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLong', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByAuditLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'auditLong', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByObsField() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'obsField', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByObsFieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'obsField', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenBySerialNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serialNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenBySerialNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serialNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension AssetItemQueryWhereDistinct
    on QueryBuilder<AssetItem, AssetItem, QDistinct> {
  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByAuditDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'auditDate');
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByAuditLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'auditLat');
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByAuditLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'auditLong');
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByObsField(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'obsField', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByPhotoPaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoPaths');
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByPlate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctBySerialNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serialNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetItem, AssetItem, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension AssetItemQueryProperty
    on QueryBuilder<AssetItem, AssetItem, QQueryProperty> {
  QueryBuilder<AssetItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AssetItem, DateTime?, QQueryOperations> auditDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'auditDate');
    });
  }

  QueryBuilder<AssetItem, double?, QQueryOperations> auditLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'auditLat');
    });
  }

  QueryBuilder<AssetItem, double?, QQueryOperations> auditLongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'auditLong');
    });
  }

  QueryBuilder<AssetItem, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<AssetItem, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<AssetItem, String?, QQueryOperations> obsFieldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'obsField');
    });
  }

  QueryBuilder<AssetItem, List<String>?, QQueryOperations>
      photoPathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoPaths');
    });
  }

  QueryBuilder<AssetItem, String?, QQueryOperations> plateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plate');
    });
  }

  QueryBuilder<AssetItem, String?, QQueryOperations> serialNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serialNumber');
    });
  }

  QueryBuilder<AssetItem, AuditStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPropertyItemCollection on Isar {
  IsarCollection<PropertyItem> get propertyItems => this.collection();
}

const PropertyItemSchema = CollectionSchema(
  name: r'PropertyItem',
  id: 8803450964284793605,
  properties: {
    r'city': PropertySchema(
      id: 0,
      name: r'city',
      type: IsarType.string,
    ),
    r'dronePhotoPaths': PropertySchema(
      id: 1,
      name: r'dronePhotoPaths',
      type: IsarType.stringList,
    ),
    r'matricula': PropertySchema(
      id: 2,
      name: r'matricula',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'referenceLat': PropertySchema(
      id: 4,
      name: r'referenceLat',
      type: IsarType.double,
    ),
    r'referenceLong': PropertySchema(
      id: 5,
      name: r'referenceLong',
      type: IsarType.double,
    )
  },
  estimateSize: _propertyItemEstimateSize,
  serialize: _propertyItemSerialize,
  deserialize: _propertyItemDeserialize,
  deserializeProp: _propertyItemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _propertyItemGetId,
  getLinks: _propertyItemGetLinks,
  attach: _propertyItemAttach,
  version: '3.1.0+1',
);

int _propertyItemEstimateSize(
  PropertyItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.city.length * 3;
  {
    final list = object.dronePhotoPaths;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.matricula.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _propertyItemSerialize(
  PropertyItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.city);
  writer.writeStringList(offsets[1], object.dronePhotoPaths);
  writer.writeString(offsets[2], object.matricula);
  writer.writeString(offsets[3], object.name);
  writer.writeDouble(offsets[4], object.referenceLat);
  writer.writeDouble(offsets[5], object.referenceLong);
}

PropertyItem _propertyItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PropertyItem();
  object.city = reader.readString(offsets[0]);
  object.dronePhotoPaths = reader.readStringList(offsets[1]);
  object.id = id;
  object.matricula = reader.readString(offsets[2]);
  object.name = reader.readString(offsets[3]);
  object.referenceLat = reader.readDoubleOrNull(offsets[4]);
  object.referenceLong = reader.readDoubleOrNull(offsets[5]);
  return object;
}

P _propertyItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _propertyItemGetId(PropertyItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _propertyItemGetLinks(PropertyItem object) {
  return [];
}

void _propertyItemAttach(
    IsarCollection<dynamic> col, Id id, PropertyItem object) {
  object.id = id;
}

extension PropertyItemQueryWhereSort
    on QueryBuilder<PropertyItem, PropertyItem, QWhere> {
  QueryBuilder<PropertyItem, PropertyItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PropertyItemQueryWhere
    on QueryBuilder<PropertyItem, PropertyItem, QWhereClause> {
  QueryBuilder<PropertyItem, PropertyItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<PropertyItem, PropertyItem, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PropertyItemQueryFilter
    on QueryBuilder<PropertyItem, PropertyItem, QFilterCondition> {
  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> cityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      cityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> cityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> cityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> cityContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> cityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dronePhotoPaths',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dronePhotoPaths',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dronePhotoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dronePhotoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dronePhotoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dronePhotoPaths',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dronePhotoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dronePhotoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dronePhotoPaths',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dronePhotoPaths',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dronePhotoPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dronePhotoPaths',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dronePhotoPaths',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dronePhotoPaths',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dronePhotoPaths',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dronePhotoPaths',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dronePhotoPaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      dronePhotoPathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dronePhotoPaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matricula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matricula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matricula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matricula',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matricula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matricula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matricula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matricula',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matricula',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      matriculaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matricula',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'referenceLat',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'referenceLat',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referenceLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referenceLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referenceLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLongIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'referenceLong',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLongIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'referenceLong',
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLongEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLongGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referenceLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLongLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referenceLong',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterFilterCondition>
      referenceLongBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referenceLong',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PropertyItemQueryObject
    on QueryBuilder<PropertyItem, PropertyItem, QFilterCondition> {}

extension PropertyItemQueryLinks
    on QueryBuilder<PropertyItem, PropertyItem, QFilterCondition> {}

extension PropertyItemQuerySortBy
    on QueryBuilder<PropertyItem, PropertyItem, QSortBy> {
  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByMatricula() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricula', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByMatriculaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricula', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByReferenceLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLat', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy>
      sortByReferenceLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLat', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> sortByReferenceLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLong', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy>
      sortByReferenceLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLong', Sort.desc);
    });
  }
}

extension PropertyItemQuerySortThenBy
    on QueryBuilder<PropertyItem, PropertyItem, QSortThenBy> {
  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByMatricula() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricula', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByMatriculaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matricula', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByReferenceLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLat', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy>
      thenByReferenceLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLat', Sort.desc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy> thenByReferenceLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLong', Sort.asc);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QAfterSortBy>
      thenByReferenceLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceLong', Sort.desc);
    });
  }
}

extension PropertyItemQueryWhereDistinct
    on QueryBuilder<PropertyItem, PropertyItem, QDistinct> {
  QueryBuilder<PropertyItem, PropertyItem, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QDistinct>
      distinctByDronePhotoPaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dronePhotoPaths');
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QDistinct> distinctByMatricula(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matricula', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QDistinct> distinctByReferenceLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referenceLat');
    });
  }

  QueryBuilder<PropertyItem, PropertyItem, QDistinct>
      distinctByReferenceLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referenceLong');
    });
  }
}

extension PropertyItemQueryProperty
    on QueryBuilder<PropertyItem, PropertyItem, QQueryProperty> {
  QueryBuilder<PropertyItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PropertyItem, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<PropertyItem, List<String>?, QQueryOperations>
      dronePhotoPathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dronePhotoPaths');
    });
  }

  QueryBuilder<PropertyItem, String, QQueryOperations> matriculaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matricula');
    });
  }

  QueryBuilder<PropertyItem, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PropertyItem, double?, QQueryOperations> referenceLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceLat');
    });
  }

  QueryBuilder<PropertyItem, double?, QQueryOperations>
      referenceLongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceLong');
    });
  }
}
