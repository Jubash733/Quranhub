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
  List<_IndexedAyah>? _index;

  SearchRepositoryImpl({
    required this.assetDataSource,
    this.searchDataSource,
  });

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
      final normalizedQuery = _normalize(trimmed);
      final isArabicQuery = _containsArabic(trimmed);

      if (isArabicQuery && searchDataSource != null) {
        final rows = await searchDataSource!.search(
          trimmed,
          languageCode: languageCode,
        );
        if (rows.isNotEmpty) {
          return Right(
            rows.map((row) => _mapDbToResult(row, languageCode)).toList(),
          );
        }
      }

      _index ??= await _buildIndex();
      final results = <SearchResultEntity>[];
      for (final entry in _index!) {
        final haystack = isArabicQuery
            ? entry.normalizedArabic
            : entry.translationFor(languageCode);
        if (haystack.contains(normalizedQuery)) {
          results.add(_mapToResult(entry.data, languageCode));
        }
        if (results.length >= 50) {
          break;
        }
      }
      return Right(results);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  Future<List<_IndexedAyah>> _buildIndex() async {
    final data = await assetDataSource.getAllAyah();
    return data
        .map((item) => _IndexedAyah(
              data: item,
              normalizedArabic: _normalize(item.textArabic),
              normalizedTranslationAr: _normalize(item.translationFor('ar') ?? ''),
              normalizedTranslationEn: _normalize(item.translationFor('en') ?? ''),
            ))
        .toList();
  }

  SearchResultEntity _mapToResult(LocalAyahData data, String languageCode) {
    final surahName =
        languageCode == 'ar' ? data.surahNameAr : data.surahNameEn;
    final translation =
        data.translationFor(languageCode) ?? data.translationFor('ar') ?? '';
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

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  String _normalize(String text) {
    return QuranTextNormalizer.normalizeArabic(text);
  }
}

class _IndexedAyah {
  _IndexedAyah({
    required this.data,
    required this.normalizedArabic,
    required this.normalizedTranslationAr,
    required this.normalizedTranslationEn,
  });

  final LocalAyahData data;
  final String normalizedArabic;
  final String normalizedTranslationAr;
  final String normalizedTranslationEn;

  String translationFor(String languageCode) {
    if (languageCode == 'ar') {
      return normalizedTranslationAr;
    }
    return normalizedTranslationEn;
  }
}
