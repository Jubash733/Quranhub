// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLibraryItemModelCollection on Isar {
  IsarCollection<LibraryItemModel> get libraryItemModels => this.collection();
}

const LibraryItemModelSchema = CollectionSchema(
  name: r'LibraryItemModel',
  id: 957899915745134290,
  properties: {
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'categoryKey': PropertySchema(
      id: 1,
      name: r'categoryKey',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'downloadTaskId': PropertySchema(
      id: 3,
      name: r'downloadTaskId',
      type: IsarType.string,
    ),
    r'downloadUrl': PropertySchema(
      id: 4,
      name: r'downloadUrl',
      type: IsarType.string,
    ),
    r'downloadedBytes': PropertySchema(
      id: 5,
      name: r'downloadedBytes',
      type: IsarType.long,
    ),
    r'isBundled': PropertySchema(
      id: 6,
      name: r'isBundled',
      type: IsarType.bool,
    ),
    r'itemId': PropertySchema(
      id: 7,
      name: r'itemId',
      type: IsarType.string,
    ),
    r'localPath': PropertySchema(
      id: 8,
      name: r'localPath',
      type: IsarType.string,
    ),
    r'sizeBytes': PropertySchema(
      id: 9,
      name: r'sizeBytes',
      type: IsarType.long,
    ),
    r'source': PropertySchema(
      id: 10,
      name: r'source',
      type: IsarType.string,
    ),
    r'statusKey': PropertySchema(
      id: 11,
      name: r'statusKey',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 12,
      name: r'title',
      type: IsarType.string,
    ),
    r'totalBytes': PropertySchema(
      id: 13,
      name: r'totalBytes',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _libraryItemModelEstimateSize,
  serialize: _libraryItemModelSerialize,
  deserialize: _libraryItemModelDeserialize,
  deserializeProp: _libraryItemModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'itemId': IndexSchema(
      id: -5342806140158601489,
      name: r'itemId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'itemId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _libraryItemModelGetId,
  getLinks: _libraryItemModelGetLinks,
  attach: _libraryItemModelAttach,
  version: '3.1.0+1',
);

int _libraryItemModelEstimateSize(
  LibraryItemModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.categoryKey.length * 3;
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.downloadTaskId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.downloadUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.itemId.length * 3;
  {
    final value = object.localPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.statusKey.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _libraryItemModelSerialize(
  LibraryItemModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeString(offsets[1], object.categoryKey);
  writer.writeString(offsets[2], object.description);
  writer.writeString(offsets[3], object.downloadTaskId);
  writer.writeString(offsets[4], object.downloadUrl);
  writer.writeLong(offsets[5], object.downloadedBytes);
  writer.writeBool(offsets[6], object.isBundled);
  writer.writeString(offsets[7], object.itemId);
  writer.writeString(offsets[8], object.localPath);
  writer.writeLong(offsets[9], object.sizeBytes);
  writer.writeString(offsets[10], object.source);
  writer.writeString(offsets[11], object.statusKey);
  writer.writeString(offsets[12], object.title);
  writer.writeLong(offsets[13], object.totalBytes);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

LibraryItemModel _libraryItemModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LibraryItemModel();
  object.author = reader.readString(offsets[0]);
  object.categoryKey = reader.readString(offsets[1]);
  object.description = reader.readString(offsets[2]);
  object.downloadTaskId = reader.readStringOrNull(offsets[3]);
  object.downloadUrl = reader.readStringOrNull(offsets[4]);
  object.downloadedBytes = reader.readLong(offsets[5]);
  object.id = id;
  object.isBundled = reader.readBool(offsets[6]);
  object.itemId = reader.readString(offsets[7]);
  object.localPath = reader.readStringOrNull(offsets[8]);
  object.sizeBytes = reader.readLong(offsets[9]);
  object.source = reader.readString(offsets[10]);
  object.statusKey = reader.readString(offsets[11]);
  object.title = reader.readString(offsets[12]);
  object.totalBytes = reader.readLong(offsets[13]);
  object.updatedAt = reader.readDateTime(offsets[14]);
  return object;
}

P _libraryItemModelDeserializeProp<P>(
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
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _libraryItemModelGetId(LibraryItemModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _libraryItemModelGetLinks(LibraryItemModel object) {
  return [];
}

void _libraryItemModelAttach(
    IsarCollection<dynamic> col, Id id, LibraryItemModel object) {
  object.id = id;
}

extension LibraryItemModelByIndex on IsarCollection<LibraryItemModel> {
  Future<LibraryItemModel?> getByItemId(String itemId) {
    return getByIndex(r'itemId', [itemId]);
  }

  LibraryItemModel? getByItemIdSync(String itemId) {
    return getByIndexSync(r'itemId', [itemId]);
  }

  Future<bool> deleteByItemId(String itemId) {
    return deleteByIndex(r'itemId', [itemId]);
  }

  bool deleteByItemIdSync(String itemId) {
    return deleteByIndexSync(r'itemId', [itemId]);
  }

  Future<List<LibraryItemModel?>> getAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'itemId', values);
  }

  List<LibraryItemModel?> getAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'itemId', values);
  }

  Future<int> deleteAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'itemId', values);
  }

  int deleteAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'itemId', values);
  }

  Future<Id> putByItemId(LibraryItemModel object) {
    return putByIndex(r'itemId', object);
  }

  Id putByItemIdSync(LibraryItemModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'itemId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByItemId(List<LibraryItemModel> objects) {
    return putAllByIndex(r'itemId', objects);
  }

  List<Id> putAllByItemIdSync(List<LibraryItemModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'itemId', objects, saveLinks: saveLinks);
  }
}

extension LibraryItemModelQueryWhereSort
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QWhere> {
  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LibraryItemModelQueryWhere
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QWhereClause> {
  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhereClause>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhereClause>
      itemIdEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'itemId',
        value: [itemId],
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterWhereClause>
      itemIdNotEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [],
              upper: [itemId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [itemId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [itemId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [],
              upper: [itemId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LibraryItemModelQueryFilter
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QFilterCondition> {
  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      categoryKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionEqualTo(
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionLessThan(
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionBetween(
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionEndsWith(
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadTaskId',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadTaskId',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadTaskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadTaskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadTaskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadTaskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadTaskId',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloadUrl',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloadUrl',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadedBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadedBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadedBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      downloadedBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadedBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      isBundledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBundled',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localPath',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      localPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sizeBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sizeBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sizeBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sizeBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      statusKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusKey',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      totalBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      totalBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      totalBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      totalBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterFilterCondition>
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

extension LibraryItemModelQueryObject
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QFilterCondition> {}

extension LibraryItemModelQueryLinks
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QFilterCondition> {}

extension LibraryItemModelQuerySortBy
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QSortBy> {
  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByCategoryKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryKey', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByCategoryKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryKey', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDownloadTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadTaskId', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDownloadTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadTaskId', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDownloadUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDownloadUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByDownloadedBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByIsBundled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBundled', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByIsBundledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBundled', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByStatusKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKey', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByStatusKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKey', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LibraryItemModelQuerySortThenBy
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QSortThenBy> {
  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByCategoryKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryKey', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByCategoryKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryKey', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDownloadTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadTaskId', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDownloadTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadTaskId', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDownloadUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDownloadUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByDownloadedBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByIsBundled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBundled', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByIsBundledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBundled', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPath', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByStatusKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKey', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByStatusKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKey', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LibraryItemModelQueryWhereDistinct
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct> {
  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByCategoryKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByDownloadTaskId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadTaskId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByDownloadUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadedBytes');
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByIsBundled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBundled');
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct> distinctByItemId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeBytes');
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByStatusKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBytes');
    });
  }

  QueryBuilder<LibraryItemModel, LibraryItemModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LibraryItemModelQueryProperty
    on QueryBuilder<LibraryItemModel, LibraryItemModel, QQueryProperty> {
  QueryBuilder<LibraryItemModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LibraryItemModel, String, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<LibraryItemModel, String, QQueryOperations>
      categoryKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryKey');
    });
  }

  QueryBuilder<LibraryItemModel, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<LibraryItemModel, String?, QQueryOperations>
      downloadTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadTaskId');
    });
  }

  QueryBuilder<LibraryItemModel, String?, QQueryOperations>
      downloadUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadUrl');
    });
  }

  QueryBuilder<LibraryItemModel, int, QQueryOperations>
      downloadedBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadedBytes');
    });
  }

  QueryBuilder<LibraryItemModel, bool, QQueryOperations> isBundledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBundled');
    });
  }

  QueryBuilder<LibraryItemModel, String, QQueryOperations> itemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemId');
    });
  }

  QueryBuilder<LibraryItemModel, String?, QQueryOperations>
      localPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localPath');
    });
  }

  QueryBuilder<LibraryItemModel, int, QQueryOperations> sizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeBytes');
    });
  }

  QueryBuilder<LibraryItemModel, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<LibraryItemModel, String, QQueryOperations> statusKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusKey');
    });
  }

  QueryBuilder<LibraryItemModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<LibraryItemModel, int, QQueryOperations> totalBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBytes');
    });
  }

  QueryBuilder<LibraryItemModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
