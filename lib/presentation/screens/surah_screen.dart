import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/surah.dart';
import '../providers/verses_provider.dart';
import '../widgets/verse_widget.dart';
import '../widgets/audio_player_bar.dart';

class SurahScreen extends ConsumerWidget {
  final Surah surah;

  const SurahScreen({Key? key, required this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsyncValue = ref.watch(versesProvider(surah.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name, style: const TextStyle(fontFamily: 'Uthmani')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to specific reading/audio settings
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: versesAsyncValue.when(
              data: (verses) {
                if (verses.isEmpty) {
                  return const Center(child: Text('لا توجد آيات لعرضها.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: verses.length,
                  separatorBuilder: (context, index) => const Divider(height: 30),
                  itemBuilder: (context, index) {
                    final verse = verses[index];
                    return VerseWidget(verse: verse, surahId: surah.id);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text('حدث خطأ أثناء تحميل الآيات:\n$error', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(versesProvider(surah.id)),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Attach the new AudioPlayerBar to the bottom of the Surah screen
          const AudioPlayerBar(),
        ],
      ),
    );
  }
}
