import 'dart:math';

import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';
import 'package:dependencies/provider/provider.dart' as legacy_provider;
import 'package:flutter/material.dart';
import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:library_feature/presentation/controllers/library_providers.dart';
import 'package:library_feature/presentation/ui/library_item_viewer.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';
import 'package:resources/extensions/context_extensions.dart';

class LibraryItemTile extends ConsumerWidget {
  const LibraryItemTile({super.key, required this.item});

  final LibraryItemEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(libraryControllerProvider.notifier);
    final usedSpace = ref.watch(
      libraryControllerProvider.select((state) => state.usedSpaceBytes),
    );
    final prefSettings = legacy_provider.Provider.of<PreferenceSettingsProvider>(
      context,
      listen: false,
    );
    final limitBytes = prefSettings.packStorageLimitBytes;
    final progress = _progressValue(item);
    final timeRemaining = ref.watch(
      libraryControllerProvider.select(
        (state) => state.timeRemaining[item.itemId],
      ),
    );
    final speed = ref.watch(
      libraryControllerProvider.select(
        (state) => state.downloadSpeed[item.itemId],
      ),
    );

    return Card(
      elevation: 0.6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              item.author,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (item.status == LibraryDownloadStatus.downloading ||
                item.status == LibraryDownloadStatus.queued ||
                item.status == LibraryDownloadStatus.paused)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatBytes(item.downloadedBytes)} / ${_formatBytes(item.totalBytes > 0 ? item.totalBytes : item.sizeBytes)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text('${(progress * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                  if (timeRemaining != null || speed != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (timeRemaining != null)
                          Text(
                            '${context.l10n.timeRemaining}: ${_formatDuration(timeRemaining)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        if (speed != null)
                          Text(
                            '${context.l10n.speed}: ${_formatSpeed(speed)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildActions(
                context,
                controller,
                usedSpace,
                limitBytes,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    dynamic controller,
    int usedSpace,
    int limitBytes,
  ) {
    if (item.isBundled || item.status == LibraryDownloadStatus.completed) {
      return [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LibraryItemViewer(item: item),
              ),
            );
          },
          icon: const Icon(Icons.menu_book),
          label: Text(context.l10n.open),
        ),
        TextButton.icon(
          onPressed: item.isBundled ? null : () => controller.deleteItem(item),
          icon: const Icon(Icons.delete_outline),
          label: Text(context.l10n.delete),
        ),
      ];
    }

    if (item.status == LibraryDownloadStatus.downloading ||
        item.status == LibraryDownloadStatus.queued) {
      return [
        OutlinedButton.icon(
          onPressed: () => controller.pauseDownload(item),
          icon: const Icon(Icons.pause),
          label: Text(context.l10n.pause),
        ),
        TextButton.icon(
          onPressed: () => controller.cancelDownload(item),
          icon: const Icon(Icons.close),
          label: Text(context.l10n.cancel),
        ),
      ];
    }

    if (item.status == LibraryDownloadStatus.paused) {
      return [
        OutlinedButton.icon(
          onPressed: () => controller.resumeDownload(item),
          icon: const Icon(Icons.play_arrow),
          label: Text(context.l10n.resume),
        ),
        TextButton.icon(
          onPressed: () => controller.cancelDownload(item),
          icon: const Icon(Icons.close),
          label: Text(context.l10n.cancel),
        ),
      ];
    }

    if (item.status == LibraryDownloadStatus.failed) {
      return [
        OutlinedButton.icon(
          onPressed: () => controller.startDownload(item),
          icon: const Icon(Icons.refresh),
          label: Text(context.l10n.retry),
        ),
      ];
    }

    if (item.downloadUrl == null || item.downloadUrl!.isEmpty) {
      return [
        Text(
          context.l10n.unavailable,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ];
    }

    return [
      FilledButton.icon(
        onPressed: () {
          final projected = usedSpace + item.sizeBytes;
          if (limitBytes > 0 && projected > limitBytes) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.packStorageLimitReached)),
            );
            return;
          }
          controller.startDownload(item);
        },
        icon: const Icon(Icons.download),
        label: Text(context.l10n.download),
      ),
    ];
  }

  double _progressValue(LibraryItemEntity item) {
    final total = item.totalBytes > 0 ? item.totalBytes : item.sizeBytes;
    if (total <= 0) {
      return 0;
    }
    return min(1, item.downloadedBytes / total);
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

  String _formatDuration(Duration? duration) {
    if (duration == null || duration.inSeconds <= 0) return '--:--';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatSpeed(double? speed) {
    if (speed == null || speed <= 0) return '-- MB/s';
    if (speed >= 1) {
      return '${speed.toStringAsFixed(1)} MB/s';
    }
    return '${(speed * 1000).toStringAsFixed(0)} kB/s';
  }
}

