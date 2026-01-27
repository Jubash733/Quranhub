// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_tadabbur_cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAiTadabburCacheModelCollection on Isar {
  IsarCollection<AiTadabburCacheModel> get aiTadabburCacheModels =>
      this.collection();
}

const AiTadabburCacheModelSchema = CollectionSchema(
  name: r'AiTadabburCacheModel',
  id: -3357320021631465364,
  properties: {
    r'ayah': PropertySchema(
      id: 0,
      name: r'ayah',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
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
    r'promptType': PropertySchema(
      id: 4,
      name: r'promptType',
      type: IsarType.string,
    ),
    r'promptVersion': PropertySchema(
      id: 5,
      name: r'promptVersion',
      type: IsarType.string,
    ),
    r'response': PropertySchema(
      id: 6,
      name: r'response',
      type: IsarType.string,
    ),
    r'surah': PropertySchema(
      id: 7,
      name: r'surah',
      type: IsarType.long,
    )
  },
  estimateSize: _aiTadabburCacheModelEstimateSize,
  serialize: _aiTadabburCacheModelSerialize,
  deserialize: _aiTadabburCacheModelDeserialize,
  deserializeProp: _aiTadabburCacheModelDeserializeProp,
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
  getId: _aiTadabburCacheModelGetId,
  getLinks: _aiTadabburCacheModelGetLinks,
  attach: _aiTadabburCacheModelAttach,
  version: '3.1.0+1',
);

int _aiTadabburCacheModelEstimateSize(
  AiTadabburCacheModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.languageCode.length * 3;
  bytesCount += 3 + object.promptType.length * 3;
  bytesCount += 3 + object.promptVersion.length * 3;
  bytesCount += 3 + object.response.length * 3;
  return bytesCount;
}

void _aiTadabburCacheModelSerialize(
  AiTadabburCacheModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayah);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.key);
  writer.writeString(offsets[3], object.languageCode);
  writer.writeString(offsets[4], object.promptType);
  writer.writeString(offsets[5], object.promptVersion);
  writer.writeString(offsets[6], object.response);
  writer.writeLong(offsets[7], object.surah);
}

AiTadabburCacheModel _aiTadabburCacheModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AiTadabburCacheModel();
  object.ayah = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.key = reader.readString(offsets[2]);
  object.languageCode = reader.readString(offsets[3]);
  object.promptType = reader.readString(offsets[4]);
  object.promptVersion = reader.readString(offsets[5]);
  object.response = reader.readString(offsets[6]);
  object.surah = reader.readLong(offsets[7]);
  return object;
}

P _aiTadabburCacheModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _aiTadabburCacheModelGetId(AiTadabburCacheModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aiTadabburCacheModelGetLinks(
    AiTadabburCacheModel object) {
  return [];
}

void _aiTadabburCacheModelAttach(
    IsarCollection<dynamic> col, Id id, AiTadabburCacheModel object) {
  object.id = id;
}

extension AiTadabburCacheModelByIndex on IsarCollection<AiTadabburCacheModel> {
  Future<AiTadabburCacheModel?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  AiTadabburCacheModel? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<AiTadabburCacheModel?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<AiTadabburCacheModel?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(AiTadabburCacheModel object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(AiTadabburCacheModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AiTadabburCacheModel> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<AiTadabburCacheModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension AiTadabburCacheModelQueryWhereSort
    on QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QWhere> {
  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AiTadabburCacheModelQueryWhere
    on QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QWhereClause> {
  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhereClause>
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterWhereClause>
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

extension AiTadabburCacheModelQueryFilter on QueryBuilder<AiTadabburCacheModel,
    AiTadabburCacheModel, QFilterCondition> {
  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> ayahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayah',
        value: value,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> ayahGreaterThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> ayahLessThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> ayahBetween(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyEqualTo(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyGreaterThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyLessThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyBetween(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyStartsWith(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyEndsWith(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeEqualTo(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeGreaterThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeLessThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeBetween(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeStartsWith(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeEndsWith(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'languageCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'promptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'promptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'promptType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'promptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'promptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      promptTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'promptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      promptTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'promptType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptType',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'promptType',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'promptVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'promptVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'promptVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'promptVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'promptVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      promptVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'promptVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      promptVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'promptVersion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> promptVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'promptVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'response',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      responseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'response',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
          QAfterFilterCondition>
      responseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'response',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'response',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> responseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'response',
        value: '',
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> surahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surah',
        value: value,
      ));
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> surahGreaterThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> surahLessThan(
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

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel,
      QAfterFilterCondition> surahBetween(
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
}

extension AiTadabburCacheModelQueryObject on QueryBuilder<AiTadabburCacheModel,
    AiTadabburCacheModel, QFilterCondition> {}

extension AiTadabburCacheModelQueryLinks on QueryBuilder<AiTadabburCacheModel,
    AiTadabburCacheModel, QFilterCondition> {}

extension AiTadabburCacheModelQuerySortBy
    on QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QSortBy> {
  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByPromptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptType', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByPromptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptType', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByPromptVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByPromptVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortByResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortBySurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      sortBySurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.desc);
    });
  }
}

extension AiTadabburCacheModelQuerySortThenBy
    on QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QSortThenBy> {
  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayah', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByPromptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptType', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByPromptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptType', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByPromptVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByPromptVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptVersion', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenByResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'response', Sort.desc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenBySurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.asc);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QAfterSortBy>
      thenBySurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surah', Sort.desc);
    });
  }
}

extension AiTadabburCacheModelQueryWhereDistinct
    on QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct> {
  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctByAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayah');
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctByLanguageCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctByPromptType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promptType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctByPromptVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promptVersion',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctByResponse({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'response', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiTadabburCacheModel, AiTadabburCacheModel, QDistinct>
      distinctBySurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surah');
    });
  }
}

extension AiTadabburCacheModelQueryProperty on QueryBuilder<
    AiTadabburCacheModel, AiTadabburCacheModel, QQueryProperty> {
  QueryBuilder<AiTadabburCacheModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AiTadabburCacheModel, int, QQueryOperations> ayahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayah');
    });
  }

  QueryBuilder<AiTadabburCacheModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AiTadabburCacheModel, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AiTadabburCacheModel, String, QQueryOperations>
      languageCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageCode');
    });
  }

  QueryBuilder<AiTadabburCacheModel, String, QQueryOperations>
      promptTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promptType');
    });
  }

  QueryBuilder<AiTadabburCacheModel, String, QQueryOperations>
      promptVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promptVersion');
    });
  }

  QueryBuilder<AiTadabburCacheModel, String, QQueryOperations>
      responseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'response');
    });
  }

  QueryBuilder<AiTadabburCacheModel, int, QQueryOperations> surahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surah');
    });
  }
}
