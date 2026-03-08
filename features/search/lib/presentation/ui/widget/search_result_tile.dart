import 'package:flutter/material.dart';
import 'package:quran/domain/entities/search_result_entity.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class SearchResultTile extends StatelessWidget {
  final SearchResultEntity result;
  final VoidCallback onTap;
  final ArabicFontFamily arabicFontFamily;
  final double arabicFontScale;
  final bool showTranslation;
  final String query;

  const SearchResultTile({
    super.key,
    required this.result,
    required this.onTap,
    required this.arabicFontFamily,
    required this.arabicFontScale,
    required this.showTranslation,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isDarkTheme
                ? Colors.white.withValues(alpha: 0.08)
                : kGrey.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _highlightedText(
                text: result.text,
                query: query,
                textAlign: TextAlign.right,
                baseStyle: arabicBodyStyle(
                  arabicFontFamily,
                  scale: arabicFontScale,
                ).copyWith(
                  color: isDarkTheme ? Colors.white : kDarkPurple,
                ),
                highlightColor: kLinearPurple1.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(height: 6.0),
            if (showTranslation && result.translation.trim().isNotEmpty) ...[
              _highlightedText(
                text: result.translation,
                query: query,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                baseStyle: kSubtitle.copyWith(
                  color: isDarkTheme
                      ? kGreyLight
                      : kGrey.withValues(alpha: 0.8),
                ),
                highlightColor: kLinearPurple1.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 8.0),
            ],
            Text(
              context.l10n.formatSurahAyah(result.surahName, result.ref.ayah),
              style: kSubtitle.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkTheme ? kPurpleSecondary : kPurplePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightedText({
    required String text,
    required String query,
    required TextStyle baseStyle,
    required Color highlightColor,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList();
    if (tokens.isEmpty) {
      return Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: baseStyle,
      );
    }
    final pattern = tokens.map(RegExp.escape).join('|');
    final regex = RegExp(pattern, caseSensitive: false);
    final spans = <TextSpan>[];
    var start = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: baseStyle,
        ));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: baseStyle.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.w700,
        ),
      ));
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: baseStyle,
      ));
    }
    return Text.rich(
      TextSpan(children: spans),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}
