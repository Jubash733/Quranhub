import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/models/search_row.dart';
import 'package:quran/data/utils/quran_text_normalizer.dart';
import 'package:resources/constant/api_constant.dart';

abstract class QuranSearchDataSource {
  bool get isSupported;
  Future<List<SearchRow>> search(String query, {String languageCode});
  Future<bool> isIndexReady();
  Stream<double> buildIndex();
}

class QuranSearchDataSourceImpl implements QuranSearchDataSource {
  QuranSearchDataSourceImpl({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  @override
  bool get isSupported => databaseHelper.isSupported;

  @override
  Future<bool> isIndexReady() => databaseHelper.isSearchIndexReady();

  @override
  Stream<double> buildIndex() => databaseHelper.buildSearchIndex();

  @override
  Future<List<SearchRow>> search(String query, {String languageCode = 'ar'}) async {
    await databaseHelper.ensureQuranCoreData();
    final tokens = QuranTextNormalizer.tokenize(query);
    if (tokens.isEmpty) {
      return [];
    }
    final isArabicQuery = QuranTextNormalizer.containsArabic(query);
    final columns = isArabicQuery
        ? ['arabicNorm', 'translationArNorm']
        : ['translationEnNorm', 'arabicNorm'];
    final ftsQuery = QuranTextNormalizer.buildMultiColumnQuery(tokens, columns);
    if (ftsQuery.isEmpty) {
      return [];
    }
    final rows = await databaseHelper.searchAyah(
      ftsQuery,
      languageCode: languageCode,
      edition: languageCode == 'ar'
          ? ApiConstant.alquranTranslationAr
          : ApiConstant.alquranTranslationEn,
    );
    return rows.map(SearchRow.fromMap).toList();
  }
}
