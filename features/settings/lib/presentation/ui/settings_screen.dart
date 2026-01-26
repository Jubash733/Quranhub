import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowUpAnimation(
                    child: Builder(
                      builder: (context) {
                        final isRtl =
                            Directionality.of(context) == TextDirection.rtl;
                        final backButton = InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            isRtl ? Icons.arrow_forward : Icons.arrow_back,
                            size: 24.0,
                            color: prefSetProvider.isDarkTheme
                                ? Colors.white70
                                : kGrey,
                          ),
                        );
                        final titleWidget = Text(
                          context.l10n.settings,
                          style: kHeading6.copyWith(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: prefSetProvider.isDarkTheme
                                ? Colors.white
                                : kPurpleSecondary,
                          ),
                        );
                        final headerChildren = isRtl
                            ? [
                                titleWidget,
                                const SizedBox(width: 18.0),
                                backButton,
                              ]
                            : [
                                backButton,
                                const SizedBox(width: 18.0),
                                titleWidget,
                              ];
                        return Row(children: headerChildren);
                      },
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  _sectionTitle(
                    context,
                    context.l10n.language,
                    prefSetProvider,
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 10.0,
                    children: [
                      ChoiceChip(
                        label: Text(context.l10n.arabicLanguage),
                        selected: prefSetProvider.locale.languageCode == 'ar',
                        onSelected: (_) =>
                            prefSetProvider.setLocale(const Locale('ar')),
                      ),
                      ChoiceChip(
                        label: Text(context.l10n.englishLanguage),
                        selected: prefSetProvider.locale.languageCode == 'en',
                        onSelected: (_) =>
                            prefSetProvider.setLocale(const Locale('en')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  _sectionTitle(
                    context,
                    context.l10n.fontSize,
                    prefSetProvider,
                  ),
                  const SizedBox(height: 6.0),
                  Slider(
                    value: prefSetProvider.arabicFontScale,
                    min: 0.85,
                    max: 1.35,
                    divisions: 10,
                    label: prefSetProvider.arabicFontScale.toStringAsFixed(2),
                    onChanged: prefSetProvider.setArabicFontScale,
                    activeColor: prefSetProvider.isDarkTheme
                        ? kLinearPurple1
                        : kPurplePrimary,
                  ),
                  const SizedBox(height: 16.0),
                  _sectionTitle(
                    context,
                    context.l10n.fontFamily,
                    prefSetProvider,
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: [
                      ChoiceChip(
                        label: Text(context.l10n.fontAmiri),
                        selected: prefSetProvider.arabicFontFamily ==
                            ArabicFontFamily.amiri,
                        onSelected: (_) => prefSetProvider
                            .setArabicFontFamily(ArabicFontFamily.amiri),
                      ),
                      ChoiceChip(
                        label: Text(context.l10n.fontCairo),
                        selected: prefSetProvider.arabicFontFamily ==
                            ArabicFontFamily.cairo,
                        onSelected: (_) => prefSetProvider
                            .setArabicFontFamily(ArabicFontFamily.cairo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: prefSetProvider.showTranslation,
                    onChanged: prefSetProvider.setTranslationEnabled,
                    title: Text(
                      context.l10n.translationToggle,
                      style: kSubtitle.copyWith(
                        fontSize: 14.0,
                        color: prefSetProvider.isDarkTheme
                            ? Colors.white
                            : kDarkPurple,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: prefSetProvider.showTafsir,
                    onChanged: prefSetProvider.setTafsirEnabled,
                    title: Text(
                      context.l10n.tafsirToggle,
                      style: kSubtitle.copyWith(
                        fontSize: 14.0,
                        color: prefSetProvider.isDarkTheme
                            ? Colors.white
                            : kDarkPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  _sectionTitle(
                    context,
                    context.l10n.appearance,
                    prefSetProvider,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: prefSetProvider.isDarkTheme,
                    onChanged: prefSetProvider.enableDarkTheme,
                    title: Text(
                      context.l10n.darkMode,
                      style: kSubtitle.copyWith(
                        fontSize: 14.0,
                        color: prefSetProvider.isDarkTheme
                            ? Colors.white
                            : kDarkPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title,
    PreferenceSettingsProvider prefSetProvider,
  ) {
    return Text(
      title,
      style: kHeading6.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: prefSetProvider.isDarkTheme ? Colors.white : kDarkPurple,
      ),
    );
  }
}
