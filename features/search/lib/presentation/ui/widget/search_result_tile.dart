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

  const SearchResultTile({
    super.key,
    required this.result,
    required this.onTap,
    required this.arabicFontFamily,
    required this.arabicFontScale,
    required this.showTranslation,
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
              child: Text(
                result.text,
                textAlign: TextAlign.right,
                style: arabicBodyStyle(
                  arabicFontFamily,
                  scale: arabicFontScale,
                ).copyWith(
                  color: isDarkTheme ? Colors.white : kDarkPurple,
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            if (showTranslation) ...[
              Text(
                result.translation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: kSubtitle.copyWith(
                  color: isDarkTheme
                      ? Colors.white70
                      : kGrey.withValues(alpha: 0.8),
                ),
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
}
