import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';
import 'package:resources/extensions/context_extensions.dart';

class LibraryItemViewer extends StatelessWidget {
  const LibraryItemViewer({super.key, required this.item});

  final LibraryItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: FutureBuilder<String>(
        future: _loadContent(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(context.l10n.unexpectedError),
            );
          }
          final text = snapshot.data ?? context.l10n.noData;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Text(text),
            ),
          );
        },
      ),
    );
  }

  Future<String> _loadContent(BuildContext context) async {
    if (item.itemId == 'translation_en_pickthall') {
      return _loadTranslationPreview(
        context,
        'assets/data/translations/en.json',
      );
    }
    if (item.itemId == 'translation_ar_muyassar') {
      return _loadTranslationPreview(
        context,
        'assets/data/translations/ar.json',
      );
    }
    if (item.localPath != null) {
      final file = File(item.localPath!);
      if (await file.exists()) {
        return file.readAsString();
      }
    }
    return '—';
  }

  Future<String> _loadTranslationPreview(
    BuildContext context,
    String assetPath,
  ) async {
    final raw = await DefaultAssetBundle.of(context).loadString(assetPath);
    final payload = jsonDecode(raw) as List<dynamic>;
    final preview = payload.take(5).map((item) {
      final surah = item['surah'];
      final ayah = item['ayah'];
      final text = item['text'];
      return '$surah:$ayah — $text';
    }).join('\n\n');
    return preview;
  }
}

