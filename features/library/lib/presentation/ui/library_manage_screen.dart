import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:library_feature/presentation/controllers/library_providers.dart';
import 'package:library_feature/presentation/ui/widgets/library_item_tile.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/widgets/state_message.dart';

class LibraryManageScreen extends ConsumerWidget {
  const LibraryManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryControllerProvider);
    final controller = ref.read(libraryControllerProvider.notifier);
    final installed = state.items.where((item) => item.isInstalled).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.libraryManage),
        actions: [
          TextButton(
            onPressed: installed.isEmpty
                ? null
                : () async {
                    for (final item in installed) {
                      await controller.deleteItem(item);
                    }
                  },
            child: Text(context.l10n.clearAll),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.l10n.usedSpace}: ${_formatBytes(state.usedSpaceBytes)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (state.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (installed.isEmpty)
              Expanded(
                child: Center(
                  child: StateMessage(
                    title: context.l10n.libraryEmpty,
                    message: context.l10n.noData,
                    icon: Icons.inbox_outlined,
                    isDarkTheme: isDark,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      LibraryItemTile(item: installed[index]),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: installed.length,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var value = bytes.toDouble();
    var index = 0;
    while (value >= 1024 && index < suffixes.length - 1) {
      value /= 1024;
      index++;
    }
    return '${value.toStringAsFixed(1)} ${suffixes[index]}';
  }
}

