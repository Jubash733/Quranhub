import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/entities/surah.dart';
import '../../data/api/quran_api.dart';
import '../../data/local/quran_local_database.dart';
import '../../data/repositories/quran_repository_impl.dart';
import 'package:dio/dio.dart';

// Provider for the Repository
final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  final dio = Dio();
  final api = QuranApi(dio);
  final localDb = QuranLocalDatabase();
  return QuranRepositoryImpl(api: api, localDb: localDb);
});

// FutureProvider for fetching the list of Surahs
final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final repository = ref.watch(quranRepositoryProvider);
  return await repository.getSurahs();
});
