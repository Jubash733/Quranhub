import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:quran/domain/entities/surah_entity.dart';
import 'package:resources/constant/named_routes.dart';
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
      itemBuilder: (_, index) {
        return InkWell(
          onTap: () => Navigator.pushNamed(context, NamedRoutes.detailScreen,
              arguments: surah[index].number),
          child: SurahWidget(
            surah: surah[index],
            prefSetProvider: prefSetProvider,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                      surah.name.transliteration.en,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6.copyWith(
                        fontSize: 16.0,
                        color: prefSetProvider.isDarkTheme
                            ? Colors.white
                            : kDarkPurple,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            surah.revelation.arab,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kHeading6.copyWith(
                              color: kGrey.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Icon(
                          Icons.circle,
                          color: kGrey.withValues(
                            alpha: 0.8,
                          ),
                          size: 4,
                        ),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            '${surah.numberOfVerses} آية',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kHeading6.copyWith(
                              color: kGrey.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  surah.name.short,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: kHeading6.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: prefSetProvider.isDarkTheme
                        ? kPurplePrimary
                        : kDarkPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Divider(
              thickness: 1,
              color: kGrey.withValues(
                alpha: 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
