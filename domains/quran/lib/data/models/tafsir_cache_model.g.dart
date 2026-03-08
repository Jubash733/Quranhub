// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsir_cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTafsirCacheModelCollection on Isar {
  IsarCollection<TafsirCacheModel> get tafsirCacheModels => this.collection();
}

const TafsirCacheModelSchema = CollectionSchema(
  name: r'TafsirCacheModel',
  id: 4011746748314327400,
  properties: {
    r'ayah': PropertySchema(
      id: 0,
      name: r'ayah',
      type: IsarType.long,
    ),
    r'edition': PropertySchema(
      id: 1,
      name: r'edition',
      type: IsarType.string,
    ),
    r'key': PropertySchema(
      id: 2,
      name: r'key',
      type: IsarType.string,
    ),
    r'languageCode': PropertySchema(
      id: 3,
      name: r'languageCode',
      type: IsarType.string,
    ),
    r'surah': PropertySchema(
      id: 4,
      name: r'surah',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 5,
      name: r'text',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _tafsirCacheModelEstimateSize,
  serialize: _tafsirCacheModelSerialize,
  deserialize: _tafsirCacheModelDeserialize,
  deserializeProp: _tafsirCacheModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tafsirCacheModelGetId,
  getLinks: _tafsirCacheModelGetLinks,
  attach: _tafsirCacheModelAttach,
  version: '3.1.0+1',
);

int _tafsirCacheModelEstimateSize(
  TafsirCacheModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.edition.length * 3;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.languageCode.length * 3;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _tafsirCacheModelSerialize(
  TafsirCacheModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayah);
  writer.writeString(offsets[1], object.edition);
  writer.writeString(offsets[2], object.key);
  writer.writeString(offsets[3], object.languageCode);
  writer.writeLong(offsets[4], object.surah);
  writer.writeString(offsets[5], object.text);
  writer.writeDateTime(offsets[6], object.updatedAt);
}

TafsirCacheModel _tafsirCacheModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TafsirCacheModel();
  object.ayah = reader.readLong(offsets[0]);
  object.edition = reader.readString(offsets[1]);
  object.id = id;
  object.key = reader.readString(offsets[2]);
  object.languageCode = reader.readString(offsets[3]);
  object.surah = reader.readLong(offsets[4]);
  object.text = reader.readString(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  return object;
}

P _tafsirCacheModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tafsirCacheModelGetId(TafsirCacheModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tafsirCacheModelGetLinks(TafsirCacheModel object) {
  return [];
}

void _tafsirCacheModelAttach(
    IsarCollection<dynamic> col, Id id, TafsirCacheModel object) {
  object.id = id;
}

extension TafsirCacheModelByIndex on IsarCollection<TafsirCacheModel> {
  Future<TafsirCacheModel?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  TafsirCacheModel? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<TafsirCacheModel?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<TafsirCacheModel?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(TafsirCacheModel object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(TafsirCacheModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<TafsirCacheModel> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<TafsirCacheModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension TafsirCacheModelQueryWhereSort
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QWhere> {
  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TafsirCacheModelQueryWhere
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QWhereClause> {
  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhereClause>
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

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterWhereClause>
      keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TafsirCacheModelQueryFilter
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QFilterCondition> {
  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      ayahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayah',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      ayahGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayah',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      ayahLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayah',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      ayahBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayah',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'edition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'edition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'edition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'edition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'edition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'edition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'edition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'edition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'edition',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      editionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'edition',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'languageCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'languageCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      surahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surah',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      surahGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surah',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      surahLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surah',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      surahBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surah',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TafsirCacheModelQueryObject
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QFilterCondition> {}

extension TafsirCacheModelQueryLinks
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QFilterCondition> {}

extension TafsirCacheModelQuerySortBy
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QSortBy> {
  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> sortByAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByEdition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'edition', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByEditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'edition', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> sortBySurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortBySurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TafsirCacheModelQuerySortThenBy
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QSortThenBy> {
  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> thenByAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByEdition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'edition', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByEditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'edition', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> thenBySurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenBySurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TafsirCacheModelQueryWhereDistinct
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct> {
  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct> distinctByAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayah');
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct> distinctByEdition(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'edition', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct>
      distinctByLanguageCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct>
      distinctBySurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surah');
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TafsirCacheModel, TafsirCacheModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TafsirCacheModelQueryProperty
    on QueryBuilder<TafsirCacheModel, TafsirCacheModel, QQueryProperty> {
  QueryBuilder<TafsirCacheModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TafsirCacheModel, int, QQueryOperations> ayahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayah');
    });
  }

  QueryBuilder<TafsirCacheModel, String, QQueryOperations> editionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'edition');
    });
  }

  QueryBuilder<TafsirCacheModel, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<TafsirCacheModel, String, QQueryOperations>
      languageCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageCode');
    });
  }

  QueryBuilder<TafsirCacheModel, int, QQueryOperations> surahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surah');
    });
  }

  QueryBuilder<TafsirCacheModel, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<TafsirCacheModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
