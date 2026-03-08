import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/surah_list_provider.dart';
import 'surah_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsyncValue = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم', style: TextStyle(fontFamily: 'Uthmani')),
        centerTitle: true,
      ),
      body: surahsAsyncValue.when(
        data: (surahs) => ListView.separated(
          itemCount: surahs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final surah = surahs[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text('${surah.number}'),
              ),
              title: Text(
                surah.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Uthmani'),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(surah.englishName, textAlign: TextAlign.right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahScreen(surah: surah),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text('حدث خطأ أثناء تحميل السور:\n$error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(surahListProvider),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
