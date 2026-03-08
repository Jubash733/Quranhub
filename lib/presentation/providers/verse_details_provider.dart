import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'surah_list_provider.dart'; // contains quranRepositoryProvider

class VerseDetailParams {
  final String verseKey;
  final int id;

  VerseDetailParams({required this.verseKey, required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseDetailParams &&
          runtimeType == other.runtimeType &&
          verseKey == other.verseKey &&
          id == other.id;

  @override
  int get hashCode => verseKey.hashCode ^ id.hashCode;
}

final tafsirProvider = FutureProvider.family.autoDispose<String, VerseDetailParams>((ref, params) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getVerseTafsir(params.verseKey, params.id);
});

final translationProvider = FutureProvider.family.autoDispose<String, VerseDetailParams>((ref, params) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getVerseTranslation(params.verseKey, params.id);
});
