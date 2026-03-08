import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/data/data_sources/quran_search_data_source.dart';
import 'package:quran/data/models/local_ayah_data.dart';
import 'package:quran/data/models/search_row.dart';
import 'package:quran/data/utils/quran_text_normalizer.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/search_result_entity.dart';
import 'package:quran/domain/repositories/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final QuranAssetDataSource assetDataSource;
  final QuranSearchDataSource? searchDataSource;

  SearchRepositoryImpl({
    required this.assetDataSource,
    this.searchDataSource,
  });

  @override
  Future<bool> isIndexReady() async {
    if (searchDataSource == null || !searchDataSource!.isSupported) {
      return true;
    }
    return searchDataSource!.isIndexReady();
  }

  @override
  Stream<double> buildIndex() {
    if (searchDataSource == null || !searchDataSource!.isSupported) {
      return Stream<double>.value(1);
    }
    return searchDataSource!.buildIndex();
  }

  @override
  Future<Either<FailureResponse, List<SearchResultEntity>>> search(
    String query, {
    String languageCode = 'ar',
  }) async {
    try {
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        return const Right([]);
      }
      if (searchDataSource != null && searchDataSource!.isSupported) {
        final rows = await searchDataSource!.search(
          trimmed,
          languageCode: languageCode,
        );
        if (rows.isNotEmpty) {
          final mapped =
              rows.map((row) => _mapDbToResult(row, languageCode)).toList();
          return Right(_sortByMushaf(mapped));
        }
      }

      final normalizedQuery = _normalize(trimmed);
      final isArabicQuery = _containsArabic(trimmed);
      final data = await assetDataSource.getAllAyah();
      final results = <SearchResultEntity>[];
      for (final entry in data) {
        final haystack =
            isArabicQuery ? _normalize(entry.textArabic) : '';
        if (haystack.contains(normalizedQuery)) {
          results.add(_mapToResult(entry, languageCode));
        }
        if (results.length >= 50) {
          break;
        }
      }
      return Right(_sortByMushaf(results));
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  SearchResultEntity _mapToResult(LocalAyahData data, String languageCode) {
    final surahName =
        languageCode == 'ar' ? data.surahNameAr : data.surahNameEn;
    final translation = data.translationFor(languageCode) ?? '';
    return SearchResultEntity(
      ref: AyahRef(surah: data.surah, ayah: data.ayah),
      surahName: surahName,
      text: data.textArabic,
      translation: translation,
    );
  }

  SearchResultEntity _mapDbToResult(SearchRow row, String languageCode) {
    final surahName = languageCode == 'ar' ? row.surahNameAr : row.surahNameEn;
    return SearchResultEntity(
      ref: AyahRef(surah: row.surah, ayah: row.ayah),
      surahName: surahName,
      text: row.text,
      translation: row.translation ?? '',
    );
  }

  List<SearchResultEntity> _sortByMushaf(
    List<SearchResultEntity> results,
  ) {
    results.sort((a, b) {
      final surahCompare = a.ref.surah.compareTo(b.ref.surah);
      if (surahCompare != 0) {
        return surahCompare;
      }
      return a.ref.ayah.compareTo(b.ref.ayah);
    });
    return results;
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  String _normalize(String text) {
    return QuranTextNormalizer.normalizeForSearch(text);
  }
}
