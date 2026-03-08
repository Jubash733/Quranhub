import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart' as riverpod;
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/constant/named_routes.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:settings/presentation/controller/app_settings_provider.dart';
import 'package:resources/widgets/glass_box.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        final isDark = prefSetProvider.isDarkTheme;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF0F172A),
                        const Color(0xFF0B1220),
                        const Color(0xFF1A1A2E),
                      ]
                    : [
                        const Color(0xFFF8F9FA),
                        const Color(0xFFE9ECEF),
                        const Color(0xFFDEE2E6),
                      ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowUpAnimation(
                      child: _buildHeader(context, isDark),
                    ),
                    const SizedBox(height: 32.0),

                    // Language Section
                    _sectionTitle(context, context.l10n.language, isDark),
                    const SizedBox(height: 12.0),
                    GlassBox(
                      isDark: isDark,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildChoiceChip(
                              label: context.l10n.arabicLanguage,
                              selected:
                                  prefSetProvider.locale.languageCode == 'ar',
                              onSelected: () =>
                                  prefSetProvider.setLocale(const Locale('ar')),
                              isDarkTheme: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildChoiceChip(
                              label: context.l10n.englishLanguage,
                              selected:
                                  prefSetProvider.locale.languageCode == 'en',
                              onSelected: () =>
                                  prefSetProvider.setLocale(const Locale('en')),
                              isDarkTheme: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildChoiceChip(
                              label: context.l10n.farsiLanguage,
                              selected:
                                  prefSetProvider.locale.languageCode == 'fa',
                              onSelected: () =>
                                  prefSetProvider.setLocale(const Locale('fa')),
                              isDarkTheme: isDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Appearance & Font
                    _sectionTitle(context, context.l10n.appearance, isDark),
                    const SizedBox(height: 12.0),
                    GlassBox(
                      isDark: isDark,
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          SwitchListTile(
                            activeColor: kGoldPrimary,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            value: prefSetProvider.isDarkTheme,
                            onChanged: prefSetProvider.enableDarkTheme,
                            title: Text(
                              context.l10n.darkMode,
                              style: kHeading6.copyWith(
                                fontSize: 16.0,
                                color: isDark ? Colors.white : kDarkPurple,
                              ),
                            ),
                            secondary: Icon(Icons.dark_mode_rounded,
                                color: isDark ? kGoldPrimary : kPurplePrimary),
                          ),
                          Divider(
                              height: 1,
                              color: isDark ? Colors.white10 : Colors.black12),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.fontSize,
                                  style: kSubtitle.copyWith(
                                      fontSize: 14,
                                      color: isDark ? kGreyLight : kGrey),
                                ),
                                const SizedBox(height: 8),
                                Slider(
                                  value: prefSetProvider.arabicFontScale,
                                  min: 0.85,
                                  max: 1.35,
                                  divisions: 10,
                                  label: prefSetProvider.arabicFontScale
                                      .toStringAsFixed(2),
                                  onChanged: prefSetProvider.setArabicFontScale,
                                  activeColor:
                                      isDark ? kGoldPrimary : kPurplePrimary,
                                  inactiveColor: isDark
                                      ? kGrey.withOpacity(0.3)
                                      : kGrey.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  context.l10n.fontFamily,
                                  style: kSubtitle.copyWith(
                                      fontSize: 14,
                                      color: isDark ? kGreyLight : kGrey),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildChoiceChip(
                                        label: context.l10n.fontAmiri,
                                        selected:
                                            prefSetProvider.arabicFontFamily ==
                                                ArabicFontFamily.amiri,
                                        onSelected: () =>
                                            prefSetProvider.setArabicFontFamily(
                                                ArabicFontFamily.amiri),
                                        isDarkTheme: isDark,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildChoiceChip(
                                        label: context.l10n.fontCairo,
                                        selected:
                                            prefSetProvider.arabicFontFamily ==
                                                ArabicFontFamily.cairo,
                                        onSelected: () =>
                                            prefSetProvider.setArabicFontFamily(
                                                ArabicFontFamily.cairo),
                                        isDarkTheme: isDark,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildChoiceChip(
                                        label: context.l10n.fontUthmani,
                                        selected:
                                            prefSetProvider.arabicFontFamily ==
                                                ArabicFontFamily.uthmani,
                                        onSelected: () =>
                                            prefSetProvider.setArabicFontFamily(
                                                ArabicFontFamily.uthmani),
                                        isDarkTheme: isDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Reading Content
                    _sectionTitle(
                        context, context.l10n.onlineContentSettings, isDark),
                    const SizedBox(height: 12.0),
                    GlassBox(
                      isDark: isDark,
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          SwitchListTile(
                            activeColor: kGoldPrimary,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            value: prefSetProvider.showTranslation,
                            onChanged: prefSetProvider.setTranslationEnabled,
                            title: Text(context.l10n.translationToggle,
                                style: kHeading6.copyWith(
                                    fontSize: 15,
                                    color:
                                        isDark ? Colors.white : kDarkPurple)),
                          ),
                          Divider(
                              height: 1,
                              color: isDark ? Colors.white10 : Colors.black12),
                          SwitchListTile(
                            activeColor: kGoldPrimary,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            value: prefSetProvider.showTafsir,
                            onChanged: prefSetProvider.setTafsirEnabled,
                            title: Text(context.l10n.tafsirToggle,
                                style: kHeading6.copyWith(
                                    fontSize: 15,
                                    color:
                                        isDark ? Colors.white : kDarkPurple)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    riverpod.Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(appSettingsControllerProvider);
                        return state.when(
                          data: (settings) => GlassBox(
                            isDark: isDark,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _settingsDropdown(
                                  context,
                                  label: context.l10n.translationEdition,
                                  value: settings.translationEdition,
                                  items: _translationOptions,
                                  isDark: isDark,
                                  onChanged: (option) {
                                    if (option == null) return;
                                    ref
                                        .read(appSettingsControllerProvider
                                            .notifier)
                                        .updateTranslation(
                                            option.value, option.languageCode);
                                  },
                                ),
                                const SizedBox(height: 16),
                                _settingsDropdown(
                                  context,
                                  label: context.l10n.tafsirEdition,
                                  value: settings.tafsirEdition,
                                  items: _tafsirOptions,
                                  isDark: isDark,
                                  onChanged: (option) {
                                    if (option == null) return;
                                    ref
                                        .read(appSettingsControllerProvider
                                            .notifier)
                                        .updateTafsir(
                                            option.value, option.languageCode);
                                  },
                                ),
                                const SizedBox(height: 16),
                                _settingsDropdown(
                                  context,
                                  label: context.l10n.audioReciter,
                                  value: settings.audioEdition,
                                  items: _reciterOptions,
                                  isDark: isDark,
                                  onChanged: (option) {
                                    if (option == null) return;
                                    ref
                                        .read(appSettingsControllerProvider
                                            .notifier)
                                        .updateAudio(option.value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text("Error loading settings",
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black)),
                        );
                      },
                    ),

                    const SizedBox(height: 24.0),

                    // Audio Settings
                    _sectionTitle(context, context.l10n.audioSettings, isDark),
                    const SizedBox(height: 12),
                    GlassBox(
                      isDark: isDark,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.playbackSpeed,
                              style: kSubtitle.copyWith(
                                  color: isDark ? kGreyLight : kGrey)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: _speedOptions
                                .map((s) => _buildChoiceChip(
                                    label: '${s}x',
                                    selected: prefSetProvider.audioSpeed == s,
                                    onSelected: () =>
                                        prefSetProvider.setAudioSpeed(s),
                                    isDarkTheme: isDark))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          Text(context.l10n.repeatCount,
                              style: kSubtitle.copyWith(
                                  color: isDark ? kGreyLight : kGrey)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: _repeatOptions
                                .map((c) => _buildChoiceChip(
                                    label: '$c',
                                    selected:
                                        prefSetProvider.audioRepeatCount == c,
                                    onSelected: () =>
                                        prefSetProvider.setAudioRepeatCount(c),
                                    isDarkTheme: isDark))
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Storage
                    _sectionTitle(context, context.l10n.manageStorage, isDark),
                    const SizedBox(height: 12),
                    GlassBox(
                      isDark: isDark,
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () => Navigator.pushNamed(
                                context, NamedRoutes.libraryScreen),
                            leading: Icon(Icons.download_rounded,
                                color: isDark ? kGoldPrimary : kPurplePrimary),
                            title: Text(context.l10n.library,
                                style: kHeading6.copyWith(
                                    fontSize: 15,
                                    color:
                                        isDark ? Colors.white : kDarkPurple)),
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: isDark ? Colors.white38 : kGrey),
                          ),
                          Divider(
                              height: 1,
                              color: isDark ? Colors.white10 : Colors.black12),
                          ListTile(
                            onTap: () => Navigator.pushNamed(
                                context, NamedRoutes.audioStorageScreen),
                            leading: Icon(Icons.audiotrack_rounded,
                                color: isDark ? kGoldPrimary : kPurplePrimary),
                            title: Text(context.l10n.audioStorage,
                                style: kHeading6.copyWith(
                                    fontSize: 15,
                                    color:
                                        isDark ? Colors.white : kDarkPurple)),
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: isDark ? Colors.white38 : kGrey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        "Version 1.0.0",
                        style: kSubtitle.copyWith(
                            color: isDark ? Colors.white30 : Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        GlassBox(
          width: 44,
          height: 44,
          borderRadius: 12,
          padding: EdgeInsets.zero,
          isDark: isDark,
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: isDark ? Colors.white : kPurplePrimary),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          context.l10n.settings,
          style: kHeading6.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: isDark ? kGoldPrimary : kDarkPurple,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: kHeading6.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : kBlackPurple,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    required bool isDarkTheme,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? (isDarkTheme ? kGoldPrimary : kPurplePrimary)
              : (isDarkTheme
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : (isDarkTheme ? Colors.white12 : Colors.black12),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: kSubtitle.copyWith(
              color: selected
                  ? Colors.white
                  : (isDarkTheme ? Colors.white70 : kGrey),
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingsDropdown(
    BuildContext context, {
    required String label,
    required String value,
    required List<_SettingsOption> items,
    required bool isDark,
    required ValueChanged<_SettingsOption?> onChanged,
  }) {
    // Simplifying dropdown for now, custom implementation would be ideal but using themed DropdownButtonFormField
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: kSubtitle.copyWith(
                fontSize: 12, color: isDark ? kGreyLight : kGrey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<_SettingsOption>(
          isExpanded: true,
          dropdownColor: isDark ? kDeepBlue : Colors.white,
          value: items.firstWhere((i) => i.value == value,
              orElse: () => items.first),
          style: kHeading6.copyWith(
              fontSize: 14, color: isDark ? Colors.white : kDarkPurple),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.black26 : kGrey92,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SettingsOption {
  const _SettingsOption({
    required this.value,
    required this.label,
    this.languageCode = 'ar',
  });

  final String value;
  final String label;
  final String languageCode;
}

const List<_SettingsOption> _translationOptions = [
  _SettingsOption(
    value: 'translation.en.pickthall',
    label: 'Pickthall (EN)',
    languageCode: 'en',
  ),
];

const List<_SettingsOption> _tafsirOptions = [
  _SettingsOption(
    value: 'tafsir.ar.placeholder',
    label: 'Tafsir not available (AR)',
    languageCode: 'ar',
  ),
];

const List<_SettingsOption> _reciterOptions = [
  _SettingsOption(
    value: 'ar.alafasy',
    label: 'Mishary Alafasy',
  ),
  _SettingsOption(
    value: 'ar.abdurrahmaansudais',
    label: 'Abdurrahman Al-Sudais',
  ),
  _SettingsOption(
    value: 'ar.husary',
    label: 'Mahmoud Al-Husary',
  ),
  _SettingsOption(
    value: 'ar.mahermuaiqly',
    label: 'Maher Al Muaiqly',
  ),
  _SettingsOption(
    value: 'ar.hudhaify',
    label: 'Ali Al Hudhaify',
  ),
];

const List<double> _speedOptions = [0.75, 1.0, 1.25, 1.5];
const List<int> _repeatOptions = [1, 2, 3, 5, 10];
const List<int> _sleepOptions = [0, 5, 10, 20, 30];
const List<int> _packLimitOptions = [
  512 * 1024 * 1024,
  1024 * 1024 * 1024,
  2 * 1024 * 1024 * 1024,
];
