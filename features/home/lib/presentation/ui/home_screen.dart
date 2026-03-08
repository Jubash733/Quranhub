import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:home/presentation/bloc/bloc.dart';
import 'package:home/presentation/ui/widget/list_surah_widget.dart';
import 'package:home/presentation/ui/widget/surah_skeleton_item.dart';
import 'package:resources/constant/named_routes.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:resources/widgets/state_message.dart';
import 'package:resources/widgets/glass_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) {
        return;
      }
      context.read<HomeBloc>().add(FetchSurah());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        final isDark = prefSetProvider.isDarkTheme;
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF0F172A), // kDeepBlue
                        const Color(0xFF0B1220), // kBlackPurple
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      ShowUpAnimation(
                        child: _buildHeader(context, prefSetProvider),
                      ),
                      const SizedBox(height: 32.0),

                      // Greeting Section
                      ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 100),
                        child: _buildGreeting(context, isDark),
                      ),
                      const SizedBox(height: 24.0),

                      // Search Bar (Glass)
                      ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 200),
                        child: _buildSearchBar(context, isDark),
                      ),
                      const SizedBox(height: 18.0),

                      // AI Assistant Card (Glass Gradient)
                      ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 300),
                        child: _buildAiCard(context, isDark),
                      ),
                      const SizedBox(height: 32.0),

                      // Surah List Section
                      ShowUpAnimation(
                        delayStart: const Duration(milliseconds: 400),
                        child: Row(
                          children: [
                            Text(
                              context.l10n.surah,
                              style: kHeading6.copyWith(
                                fontSize: 20.0,
                                color: isDark ? Colors.white : kDarkPurple,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: kGoldPrimary,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kGoldPrimary.withOpacity(0.5),
                                      blurRadius: 6,
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Surah List Content
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          final status = state.statusSurah.status;
                          Widget child;
                          if (status.isLoading) {
                            child = ListView.builder(
                              key: const ValueKey('home-loading'),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return SurahSkeletonItem(
                                  isDarkTheme: isDark,
                                );
                              },
                            );
                          } else if (status.isNoData) {
                            child = GlassBox(
                              isDark: isDark,
                              padding: const EdgeInsets.all(24),
                              child: StateMessage(
                                key: const ValueKey('home-empty'),
                                title: context.l10n.noData,
                                message: context.l10n.searchHint,
                                icon: Icons.menu_book_outlined,
                                isDarkTheme: isDark,
                              ),
                            );
                          } else if (status.isError) {
                            child = GlassBox(
                              isDark: isDark,
                              padding: const EdgeInsets.all(24),
                              child: StateMessage(
                                key: const ValueKey('home-error'),
                                title: context.l10n.unexpectedError,
                                message: state.statusSurah.message.isNotEmpty
                                    ? state.statusSurah.message
                                    : context.l10n.unexpectedError,
                                icon: Icons.wifi_off_rounded,
                                isDarkTheme: isDark,
                                actionLabel: context.l10n.retry,
                                onAction: () =>
                                    context.read<HomeBloc>().add(FetchSurah()),
                              ),
                            );
                          } else if (status.isHasData) {
                            final surah = state.statusSurah.data ?? [];
                            child = ShowUpAnimation(
                              key: const ValueKey('home-data'),
                              child: ListSurahWidget(
                                surah: surah,
                                prefSetProvider: prefSetProvider,
                              ),
                            );
                          } else {
                            child = Center(
                              key: const ValueKey('home-fallback'),
                              child: Text(context.l10n.unexpectedError),
                            );
                          }
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: child,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, PreferenceSettingsProvider provider) {
    final isDark = provider.isDarkTheme;

    return Row(
      children: [
        // Logo & Title
        Image.asset(
          isDark ? 'assets/icon_quran_white.png' : 'assets/icon_quran.png',
          width: 32.0,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            context.l10n.appTitle,
            style: kHeading6.copyWith(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: isDark ? kGoldPrimary : kDarkPurple,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Action Buttons (Glass)
        GlassBox(
          width: 40,
          height: 40,
          borderRadius: 12,
          padding: EdgeInsets.zero,
          isDark: isDark,
          onTap: () =>
              Navigator.pushNamed(context, NamedRoutes.myLibraryScreen),
          child: Center(
            child: Icon(Icons.bookmark_outline_rounded,
                size: 20, color: isDark ? Colors.white : kPurplePrimary),
          ),
        ),
        const SizedBox(width: 12),
        GlassBox(
          width: 40,
          height: 40,
          borderRadius: 12,
          padding: EdgeInsets.zero,
          isDark: isDark,
          onTap: () => Navigator.pushNamed(context, NamedRoutes.libraryScreen),
          child: Center(
            child: Icon(Icons.menu_book_rounded,
                size: 20, color: isDark ? Colors.white : kPurplePrimary),
          ),
        ),
        const SizedBox(width: 12),
        GlassBox(
          width: 40,
          height: 40,
          borderRadius: 12,
          padding: EdgeInsets.zero,
          isDark: isDark,
          onTap: () => Navigator.pushNamed(context, NamedRoutes.settingsScreen),
          child: Center(
            child: Icon(Icons.settings_outlined,
                size: 20, color: isDark ? Colors.white : kPurplePrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.greetingAssalam,
          style: kHeading6.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: isDark ? kGreyLight : kPurpleSecondary,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          context.l10n.greetingWelcome,
          style: kHeading6.copyWith(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : kBlackPurple,
            shadows: isDark
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return GlassBox(
      isDark: isDark,
      onTap: () => Navigator.pushNamed(context, NamedRoutes.searchScreen),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: isDark ? kGoldPrimary : kPurplePrimary,
            size: 24,
          ),
          const SizedBox(width: 12.0),
          Text(
            context.l10n.searchHint,
            style: kSubtitle.copyWith(
              fontSize: 16.0,
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : kGrey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [kLinearPurple1, kLinearPurple2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kLinearPurple2.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, NamedRoutes.aiAssistantScreen),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.aiAssistant,
                        style: kHeading6.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Ask me anything about Quran",
                        style: kSubtitle.copyWith(
                          color: Colors.white.withOpacity(0.7), // Fixed alpha
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded,
                    color: Colors.white.withOpacity(0.8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
