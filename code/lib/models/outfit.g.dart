// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOutfitCollection on Isar {
  IsarCollection<Outfit> get outfits => this.collection();
}

const OutfitSchema = CollectionSchema(
  name: r'Outfit',
  id: 7905824818897559872,
  properties: {
    r'isForGloomy': PropertySchema(
      id: 0,
      name: r'isForGloomy',
      type: IsarType.bool,
    ),
    r'isForRainy': PropertySchema(
      id: 1,
      name: r'isForRainy',
      type: IsarType.bool,
    ),
    r'isForSunny': PropertySchema(
      id: 2,
      name: r'isForSunny',
      type: IsarType.bool,
    )
  },
  estimateSize: _outfitEstimateSize,
  serialize: _outfitSerialize,
  deserialize: _outfitDeserialize,
  deserializeProp: _outfitDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'clothingItems': LinkSchema(
      id: -1300729580494205270,
      name: r'clothingItems',
      target: r'ClothingItem',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _outfitGetId,
  getLinks: _outfitGetLinks,
  attach: _outfitAttach,
  version: '3.1.8',
);

int _outfitEstimateSize(
  Outfit object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _outfitSerialize(
  Outfit object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isForGloomy);
  writer.writeBool(offsets[1], object.isForRainy);
  writer.writeBool(offsets[2], object.isForSunny);
}

Outfit _outfitDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Outfit(
    id: id,
    isForGloomy: reader.readBoolOrNull(offsets[0]) ?? false,
    isForRainy: reader.readBoolOrNull(offsets[1]) ?? false,
    isForSunny: reader.readBoolOrNull(offsets[2]) ?? false,
  );
  return object;
}

P _outfitDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _outfitGetId(Outfit object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _outfitGetLinks(Outfit object) {
  return [object.clothingItems];
}

void _outfitAttach(IsarCollection<dynamic> col, Id id, Outfit object) {
  object.id = id;
  object.clothingItems
      .attach(col, col.isar.collection<ClothingItem>(), r'clothingItems', id);
}

extension OutfitQueryWhereSort on QueryBuilder<Outfit, Outfit, QWhere> {
  QueryBuilder<Outfit, Outfit, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OutfitQueryWhere on QueryBuilder<Outfit, Outfit, QWhereClause> {
  QueryBuilder<Outfit, Outfit, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Outfit, Outfit, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterWhereClause> idBetween(
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

extension OutfitQueryFilter on QueryBuilder<Outfit, Outfit, QFilterCondition> {
  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> isForGloomyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isForGloomy',
        value: value,
      ));
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> isForRainyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isForRainy',
        value: value,
      ));
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> isForSunnyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isForSunny',
        value: value,
      ));
    });
  }
}

extension OutfitQueryObject on QueryBuilder<Outfit, Outfit, QFilterCondition> {}

extension OutfitQueryLinks on QueryBuilder<Outfit, Outfit, QFilterCondition> {
  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> clothingItems(
      FilterQuery<ClothingItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'clothingItems');
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition>
      clothingItemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'clothingItems', length, true, length, true);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition> clothingItemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'clothingItems', 0, true, 0, true);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition>
      clothingItemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'clothingItems', 0, false, 999999, true);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition>
      clothingItemsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'clothingItems', 0, true, length, include);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition>
      clothingItemsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'clothingItems', length, include, 999999, true);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterFilterCondition>
      clothingItemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'clothingItems', lower, includeLower, upper, includeUpper);
    });
  }
}

extension OutfitQuerySortBy on QueryBuilder<Outfit, Outfit, QSortBy> {
  QueryBuilder<Outfit, Outfit, QAfterSortBy> sortByIsForGloomy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForGloomy', Sort.asc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> sortByIsForGloomyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForGloomy', Sort.desc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> sortByIsForRainy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForRainy', Sort.asc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> sortByIsForRainyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForRainy', Sort.desc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> sortByIsForSunny() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSunny', Sort.asc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> sortByIsForSunnyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSunny', Sort.desc);
    });
  }
}

extension OutfitQuerySortThenBy on QueryBuilder<Outfit, Outfit, QSortThenBy> {
  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenByIsForGloomy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForGloomy', Sort.asc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenByIsForGloomyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForGloomy', Sort.desc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenByIsForRainy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForRainy', Sort.asc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenByIsForRainyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForRainy', Sort.desc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenByIsForSunny() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSunny', Sort.asc);
    });
  }

  QueryBuilder<Outfit, Outfit, QAfterSortBy> thenByIsForSunnyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isForSunny', Sort.desc);
    });
  }
}

extension OutfitQueryWhereDistinct on QueryBuilder<Outfit, Outfit, QDistinct> {
  QueryBuilder<Outfit, Outfit, QDistinct> distinctByIsForGloomy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isForGloomy');
    });
  }

  QueryBuilder<Outfit, Outfit, QDistinct> distinctByIsForRainy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isForRainy');
    });
  }

  QueryBuilder<Outfit, Outfit, QDistinct> distinctByIsForSunny() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isForSunny');
    });
  }
}

extension OutfitQueryProperty on QueryBuilder<Outfit, Outfit, QQueryProperty> {
  QueryBuilder<Outfit, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Outfit, bool, QQueryOperations> isForGloomyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isForGloomy');
    });
  }

  QueryBuilder<Outfit, bool, QQueryOperations> isForRainyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isForRainy');
    });
  }

  QueryBuilder<Outfit, bool, QQueryOperations> isForSunnyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isForSunny');
    });
  }
}
