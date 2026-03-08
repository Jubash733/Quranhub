import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/verse.dart';
import 'surah_list_provider.dart';

// AutoDispose so it re-fetches or clears cache when user leaves screen
final versesProvider = FutureProvider.family.autoDispose<List<Verse>, int>((ref, surahId) async {
  final repository = ref.watch(quranRepositoryProvider);
  // translations: 20 is Pickthall, tafsirs: 169 is Al-Jalalayn/Muyassar usually
  return await repository.getVersesBySurah(surahId, translations: 20, tafsirs: 169);
});
