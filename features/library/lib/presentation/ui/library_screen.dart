import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:library_feature/presentation/controllers/library_providers.dart';
import 'package:library_feature/presentation/ui/widgets/library_item_tile.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/constant/named_routes.dart';
import 'package:resources/widgets/state_message.dart';

class LibraryScreen extends HookConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryControllerProvider);
    final controller = ref.read(libraryControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const categories = LibraryCategory.values;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.library),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_backup_restore),
              tooltip: context.l10n.libraryManage,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(NamedRoutes.libraryManageScreen);
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            onTap: (index) {
              controller.setCategory(categories[index]);
            },
            tabs: categories
                .map((category) => Tab(text: _labelFor(category, context)))
                .toList(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: controller.setQuery,
                decoration: InputDecoration(
                  hintText: context.l10n.librarySearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (state.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null)
              Expanded(
                child: Center(
                  child: StateMessage(
                    title: context.l10n.unexpectedError,
                    message: state.errorMessage ?? context.l10n.unexpectedError,
                    icon: Icons.error_outline,
                    isDarkTheme: isDark,
                    actionLabel: context.l10n.retry,
                    onAction: controller.refresh,
                  ),
                ),
              )
            else if (state.items.isEmpty)
              Expanded(
                child: Center(
                  child: StateMessage(
                    title: context.l10n.noResults,
                    message: context.l10n.libraryEmpty,
                    icon: Icons.menu_book_outlined,
                    isDarkTheme: isDark,
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return LibraryItemTile(item: item);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: state.items.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _labelFor(LibraryCategory category, BuildContext context) {
    switch (category) {
      case LibraryCategory.tafsir:
        return context.l10n.libraryTabTafsir;
      case LibraryCategory.translation:
        return context.l10n.libraryTabTranslations;
      case LibraryCategory.asbab:
        return context.l10n.libraryTabAsbab;
      case LibraryCategory.irab:
        return context.l10n.libraryTabIrab;
      case LibraryCategory.topics:
        return context.l10n.libraryTabTopics;
      case LibraryCategory.qiraat:
        return context.l10n.libraryTabQiraat;
    }
  }
}

