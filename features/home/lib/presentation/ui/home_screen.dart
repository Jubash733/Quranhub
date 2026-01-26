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
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowUpAnimation(
                      child: Builder(
                        builder: (context) {
                          final isRtl =
                              Directionality.of(context) == TextDirection.rtl;
                          final titleWidget = Expanded(
                            child: Text(
                              context.l10n.appTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kHeading6.copyWith(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                          final logoWidget = Image.asset(
                            prefSetProvider.isDarkTheme
                                ? 'assets/icon_quran_white.png'
                                : 'assets/icon_quran.png',
                            width: 28.0,
                          );
                          final leadingChildren = isRtl
                              ? [
                                  titleWidget,
                                  const SizedBox(width: 6.0),
                                  logoWidget,
                                ]
                              : [
                                  logoWidget,
                                  const SizedBox(width: 6.0),
                                  titleWidget,
                                ];
                          final savedIcon = InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, NamedRoutes.bookmarkScreen),
                            child: Image.asset(
                              prefSetProvider.isDarkTheme
                                  ? 'assets/icon_bookmark_white.png'
                                  : 'assets/icon_bookmark.png',
                              width: 16.0,
                            ),
                          );
                          final settingsIcon = InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              NamedRoutes.settingsScreen,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            child: Icon(
                              Icons.settings_rounded,
                              size: 22.0,
                              color: prefSetProvider.isDarkTheme
                                  ? Colors.white
                                  : kPurplePrimary,
                            ),
                          );
                          final actionChildren = isRtl
                              ? [
                                  settingsIcon,
                                  const SizedBox(width: 10.0),
                                  savedIcon,
                                ]
                              : [
                                  savedIcon,
                                  const SizedBox(width: 10.0),
                                  settingsIcon,
                                ];

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: leadingChildren,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: actionChildren,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28.0),
                    ShowUpAnimation(
                      child: Text(
                        context.l10n.greetingAssalam,
                        style: kHeading6.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: prefSetProvider.isDarkTheme
                              ? Colors.white70
                              : kDarkPurple.withValues(
                                  alpha: 0.8,
                                ),
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    ShowUpAnimation(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              context.l10n.greetingWelcome,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kHeading6.copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: prefSetProvider.isDarkTheme
                                    ? Colors.white
                                    : kBlackPurple,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Icon(
                            Icons.waving_hand_rounded,
                            size: 18.0,
                            color: prefSetProvider.isDarkTheme
                                ? Colors.white70
                                : kPurplePrimary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    ShowUpAnimation(
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, NamedRoutes.searchScreen),
                        borderRadius: BorderRadius.circular(14.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 14.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: prefSetProvider.isDarkTheme
                                ? kDarkPurple.withValues(alpha: 0.5)
                                : kGrey92,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: prefSetProvider.isDarkTheme
                                    ? Colors.white70
                                    : kPurplePrimary,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  context.l10n.searchHint,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kSubtitle.copyWith(
                                    color: prefSetProvider.isDarkTheme
                                        ? Colors.white70
                                        : kGrey.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    ShowUpAnimation(
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          NamedRoutes.aiAssistantScreen,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            gradient: const LinearGradient(
                              colors: [kLinearPurple1, kLinearPurple2],
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: Colors.white),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  context.l10n.aiAssistant,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kHeading6.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ShowUpAnimation(
                      child: Text(
                        context.l10n.surah,
                        style: kHeading6.copyWith(
                          fontSize: 18.0,
                          color: prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kDarkPurple,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ShowUpAnimation(
                      child: SizedBox(
                        width: 40,
                        child: Divider(
                          thickness: 2,
                          color: prefSetProvider.isDarkTheme
                              ? kPurplePrimary
                              : kDarkPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        final status = state.statusSurah.status;

                        if (status.isLoading) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return SurahSkeletonItem(
                                isDarkTheme: prefSetProvider.isDarkTheme,
                              );
                            },
                          );
                        } else if (status.isNoData) {
                          return Center(child: Text(context.l10n.noData));
                        } else if (status.isError) {
                          return Center(
                              child: Text(state.statusSurah.message.isNotEmpty
                                  ? state.statusSurah.message
                                  : context.l10n.unexpectedError));
                        } else if (status.isHasData) {
                          final surah = state.statusSurah.data ?? [];
                          return ShowUpAnimation(
                            child: ListSurahWidget(
                              surah: surah,
                              prefSetProvider: prefSetProvider,
                            ),
                          );
                        } else {
                          return Center(child: Text(context.l10n.unexpectedError));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
