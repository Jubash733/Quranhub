import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dependencies/url_launcher/url_launcher.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class AttributionsScreen extends StatelessWidget {
  const AttributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sourcesAndLicenses),
        backgroundColor: isDark ? kDarkTheme : Colors.white,
        foregroundColor: isDark ? Colors.white : kDarkPurple,
        elevation: 0,
      ),
      body: FutureBuilder<List<AttributionItem>>(
        future: _loadAttributions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Center(child: Text(context.l10n.noData));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final canOpen = item.url.isNotEmpty;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: canOpen ? () => _openUrl(context, item.url) : null,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isDark
                        ? kDarkPurple.withValues(alpha: 0.45)
                        : Colors.white,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : kGrey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: kHeading6.copyWith(
                          fontSize: 15,
                          color: isDark ? Colors.white : kDarkPurple,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${context.l10n.license}: ${item.license}',
                        style: kSubtitle.copyWith(
                          color: isDark ? kGreyLight : kDarkPurple,
                        ),
                      ),
                      if (item.date.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${context.l10n.sourceDate}: ${item.date}',
                          style: kSubtitle.copyWith(
                            fontSize: 12,
                            color: isDark
                                ? kGreyLight
                                : kDarkPurple.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                      if (item.url.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${context.l10n.sourceUrl}: ${item.url}',
                          style: kSubtitle.copyWith(
                            fontSize: 12,
                            color: isDark
                                ? kGreyLight
                                : kDarkPurple.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<AttributionItem>> _loadAttributions() async {
    const assetPath = 'assets/data/attributions.json';
    final raw = await rootBundle.loadString(assetPath);
    final payload = jsonDecode(raw);
    if (payload is! Map<String, dynamic>) {
      return [];
    }
    final items = payload['items'];
    if (items is! List) {
      return [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(AttributionItem.fromMap)
        .toList();
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showUrlError(context);
      return;
    }
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      _showUrlError(context);
    }
  }

  void _showUrlError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.unexpectedError)),
    );
  }
}

class AttributionItem {
  const AttributionItem({
    required this.name,
    required this.license,
    required this.url,
    required this.date,
  });

  final String name;
  final String license;
  final String url;
  final String date;

  factory AttributionItem.fromMap(Map<String, dynamic> map) {
    return AttributionItem(
      name: map['name'] as String? ?? '',
      license: map['license'] as String? ?? '',
      url: map['url'] as String? ?? '',
      date: map['date'] as String? ?? '',
    );
  }
}
