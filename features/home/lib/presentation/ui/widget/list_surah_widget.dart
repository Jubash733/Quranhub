import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/surah_entity.dart';
import 'package:resources/constant/named_routes.dart';
import 'package:resources/constant/route_args.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class ListSurahWidget extends StatelessWidget {
  final List<SurahEntity> surah;
  final PreferenceSettingsProvider prefSetProvider;

  const ListSurahWidget({
    super.key,
    required this.surah,
    required this.prefSetProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: surah.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () => Navigator.pushNamed(
              context,
              NamedRoutes.detailScreen,
              arguments: DetailScreenArgs(surahNumber: surah[index].number),
            ),
            child: SurahWidget(
              surah: surah[index],
              prefSetProvider: prefSetProvider,
            ),
          ),
        );
      },
    );
  }
}

class SurahWidget extends StatelessWidget {
  final SurahEntity surah;
  final PreferenceSettingsProvider prefSetProvider;

  const SurahWidget({
    super.key,
    required this.surah,
    required this.prefSetProvider,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.l10n.isArabic;
    final primaryName =
        isArabic ? surah.name.short : surah.name.transliteration.en;
    final secondaryName =
        isArabic ? surah.name.transliteration.en : surah.name.short;
    final secondaryColor = prefSetProvider.isDarkTheme
        ? Colors.white70
        : kDarkPurple.withValues(alpha: 0.7);
    final chevronIcon = isArabic
        ? Icons.chevron_left_rounded
        : Icons.chevron_right_rounded;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Hero(
        tag: 'surah-card-${surah.number}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: prefSetProvider.isDarkTheme
                  ? kDarkPurple.withValues(alpha: 0.45)
                  : Colors.white,
              border: Border.all(
                color: prefSetProvider.isDarkTheme
                    ? Colors.white.withValues(alpha: 0.08)
                    : kGrey.withValues(alpha: 0.18),
              ),
              boxShadow: [
                if (!prefSetProvider.isDarkTheme)
                  BoxShadow(
                    color: kGrey.withValues(alpha: 0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/icon_no.png', width: 42.0),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          surah.number.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kHeading6.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: prefSetProvider.isDarkTheme
                                ? Colors.white
                                : kDarkPurple,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primaryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6.copyWith(
                          fontSize: 16.0,
                          color: prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kDarkPurple,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        secondaryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSubtitle.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: [
                          Text(
                            isArabic
                                ? surah.revelation.arab
                                : surah.revelation.en,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kSubtitle.copyWith(
                              color: secondaryColor,
                            ),
                          ),
                          Icon(
                            Icons.circle,
                            color: secondaryColor,
                            size: 4,
                          ),
                          Text(
                            '${surah.numberOfVerses} ${context.l10n.ayah}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kSubtitle.copyWith(
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(
                  chevronIcon,
                  color: prefSetProvider.isDarkTheme
                      ? Colors.white70
                      : kPurplePrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
