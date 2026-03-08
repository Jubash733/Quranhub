import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/text_styles.dart';

class SurahInfoCard extends StatelessWidget {
  const SurahInfoCard({
    super.key,
    required this.surahNumber,
    required this.isDarkTheme,
  });

  final int surahNumber;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return FutureBuilder<SurahMetaInfo?>(
      future: SurahMetaInfo.load(surahNumber),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: colorScheme.surface,
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final meta = snapshot.data;
        if (meta == null) {
          return const SizedBox.shrink();
        }

        final revelationLabel = _revelationLabel(context, meta.revelation);
        final summary = meta.summary?.trim();
        final summaryText = (summary == null || summary.isEmpty)
            ? context.l10n.surahSummaryUnavailable
            : summary;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.surahInfo,
                style: kHeading6.copyWith(
                  fontSize: 14.0,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                meta.nameEn,
                style: kHeading6.copyWith(
                  fontSize: 16.0,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _chip(
                    context,
                    revelationLabel,
                  ),
                  _chip(
                    context,
                    '${context.l10n.ayahCount} ${meta.ayahCount}',
                  ),
                  _chip(
                    context,
                    '${context.l10n.mushafOrder} ${meta.mushafOrder}',
                  ),
                  if ((meta.revelationOrder ?? 0) > 0)
                    _chip(
                      context,
                      '${context.l10n.revelationOrder} ${meta.revelationOrder}',
                    ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                context.l10n.surahSummary,
                style: kHeading6.copyWith(
                  fontSize: 12.0,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                summaryText,
                textAlign: TextAlign.start,
                style: kHeading6.copyWith(
                  fontSize: 12.5,
                  height: 1.6,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        text,
        style: kHeading6.copyWith(
          fontSize: 11.5,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  String _revelationLabel(BuildContext context, String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('makk') || normalized.contains('mecc')) {
      return context.l10n.meccan;
    }
    if (normalized.contains('madan') || normalized.contains('medin')) {
      return context.l10n.medinan;
    }
    return value;
  }
}

class SurahMetaInfo {
  SurahMetaInfo({
    required this.surah,
    required this.nameAr,
    required this.nameEn,
    required this.ayahCount,
    required this.revelation,
    required this.mushafOrder,
    required this.revelationOrder,
    required this.summary,
  });

  final int surah;
  final String nameAr;
  final String nameEn;
  final int ayahCount;
  final String revelation;
  final int mushafOrder;
  final int? revelationOrder;
  final String? summary;

  static Map<int, SurahMetaInfo>? _cache;

  static Future<SurahMetaInfo?> load(int surah) async {
    _cache ??= await _loadAll();
    return _cache![surah];
  }

  static Future<Map<int, SurahMetaInfo>> _loadAll() async {
    final summaries = await _loadSummaries();
    final raw = await rootBundle.loadString('assets/data/surah_meta.json');
    final payload = jsonDecode(raw);
    if (payload is! List) {
      return {};
    }
    final map = <int, SurahMetaInfo>{};
    for (final item in payload) {
      if (item is! Map<String, dynamic>) continue;
      final surah = (item['surah'] as num?)?.toInt() ?? 0;
      if (surah == 0) continue;
      map[surah] = SurahMetaInfo(
        surah: surah,
        nameAr: item['name_ar'] as String? ?? '',
        nameEn: item['name_en'] as String? ?? '',
        ayahCount: (item['ayah_count'] as num?)?.toInt() ?? 0,
        revelation: item['revelation'] as String? ?? '',
        mushafOrder: (item['mushaf_order'] as num?)?.toInt() ?? surah,
        revelationOrder: (item['revelation_order'] as num?)?.toInt(),
        summary: summaries[surah],
      );
    }
    return map;
  }

  static Future<Map<int, String>> _loadSummaries() async {
    try {
      final raw = await rootBundle.loadString('assets/data/surah_summaries.json');
      final payload = jsonDecode(raw);
      if (payload is! Map<String, dynamic>) {
        return {};
      }
      return payload.map((key, value) {
        final surah = int.tryParse(key) ?? 0;
        return MapEntry(surah, value?.toString() ?? '');
      });
    } catch (_) {
      return {};
    }
  }
}
