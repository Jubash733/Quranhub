import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/models/search_row.dart';
import 'package:quran/data/utils/quran_text_normalizer.dart';

abstract class QuranSearchDataSource {
  bool get isSupported;
  Future<List<SearchRow>> search(String query, {String languageCode});
}

class QuranSearchDataSourceImpl implements QuranSearchDataSource {
  QuranSearchDataSourceImpl({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  @override
  bool get isSupported => databaseHelper.isSupported;

  @override
  Future<List<SearchRow>> search(String query, {String languageCode = 'ar'}) async {
    await databaseHelper.ensureQuranCoreData();
    final ftsQuery = QuranTextNormalizer.buildFtsQuery(query);
    if (ftsQuery.isEmpty) {
      return [];
    }
    final rows = await databaseHelper.searchAyah(
      ftsQuery,
      languageCode: languageCode,
    );
    return rows.map(SearchRow.fromMap).toList();
  }
}
