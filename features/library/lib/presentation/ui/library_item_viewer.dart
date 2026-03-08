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
    final onlineOnlyMessage = context.l10n.onlineOnly;
    if (item.localPath != null) {
      final file = File(item.localPath!);
      if (await file.exists()) {
        return file.readAsString();
      }
    }
    return onlineOnlyMessage;
  }
}

