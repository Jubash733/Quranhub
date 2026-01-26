import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';
import 'package:detail_surah/presentation/bloc/bloc.dart';
import 'package:detail_surah/presentation/cubits/last_read/last_read_cubit.dart';
import 'package:detail_surah/presentation/ui/widget/banner_verses_widget.dart';
import 'package:detail_surah/presentation/ui/widget/verses_widget.dart';
import 'package:detail_surah/presentation/ui/widget/verse_skeleton_item.dart';
import 'package:flutter/material.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:resources/widgets/state_message.dart';

class DetailSurahScreen extends StatefulWidget {
  final int id;
  final int? highlightAyah;

  const DetailSurahScreen({super.key, required this.id, this.highlightAyah});

  @override
  State<DetailSurahScreen> createState() => _DetailSurahScreenState();
}

class _DetailSurahScreenState extends State<DetailSurahScreen> {
  GlobalKey? _highlightKey;
  bool _didScrollToHighlight = false;

  @override
  void initState() {
    super.initState();
    if (widget.highlightAyah != null) {
      _highlightKey = GlobalKey();
    }

    Future.microtask(() {
      if (!mounted) {
        return;
      }
      context.read<DetailSurahBloc>().add(FetchDetailSurah(id: widget.id));
      context.read<LastReadCubit>().getLastRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
              child: BlocBuilder<DetailSurahBloc, DetailSurahState>(
                builder: (context, state) {
                  final status = state.statusDetailSurah.status;

                  if (status.isLoading) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: prefSetProvider.isDarkTheme
                                  ? kDarkPurple.withValues(alpha: 0.6)
                                  : kGrey92,
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return VerseSkeletonItem(
                                isDarkTheme: prefSetProvider.isDarkTheme,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (status.isNoData) {
                    return StateMessage(
                      title: context.l10n.noData,
                      message: context.l10n.unexpectedError,
                      icon: Icons.menu_book_outlined,
                      isDarkTheme: prefSetProvider.isDarkTheme,
                    );
                  } else if (status.isError) {
                    return StateMessage(
                      title: context.l10n.unexpectedError,
                      message: state.statusDetailSurah.message.isNotEmpty
                          ? state.statusDetailSurah.message
                          : context.l10n.unexpectedError,
                      icon: Icons.wifi_off_rounded,
                      isDarkTheme: prefSetProvider.isDarkTheme,
                      actionLabel: context.l10n.retry,
                      onAction: () => context
                          .read<DetailSurahBloc>()
                          .add(FetchDetailSurah(id: widget.id)),
                    );
                  } else if (status.isHasData) {
                    final surah = state.statusDetailSurah.data;
                    final isArabic = context.l10n.isArabic;

                    if (widget.highlightAyah != null &&
                        !_didScrollToHighlight) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final current = _highlightKey?.currentContext;
                        if (current != null && mounted) {
                          Scrollable.ensureVisible(
                            current,
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _didScrollToHighlight = true;
                          });
                        }
                      });
                    }

                    if (context.read<LastReadCubit>().state.data.isEmpty) {
                      context.read<LastReadCubit>().addLastRead(surah!);
                    } else {
                      context.read<LastReadCubit>().updateLastRead(surah!);
                    }

                    final isRtl =
                        Directionality.of(context) == TextDirection.rtl;
                    final backButton = InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        isRtl ? Icons.arrow_forward : Icons.arrow_back,
                        size: 24.0,
                        color: kGrey,
                      ),
                    );
                    final titleWidget = Expanded(
                      child: Text(
                        isArabic
                            ? surah.name.short
                            : surah.name.transliteration.en,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kHeading6.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kPurpleSecondary,
                        ),
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

                    return Column(
                      children: [
                        ShowUpAnimation(
                          child: Row(
                            children: headerChildren,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Hero(
                                  tag: 'surah-card-${surah.number}',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: BannerVersesWidget(
                                      surah: surah,
                                      prefSetProvider: prefSetProvider,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                ShowUpAnimation(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: surah.verses.length,
                                          itemBuilder: (context, index) {
                                            return VersesWidget(
                                              verses: surah.verses[index],
                                              prefSetProvider: prefSetProvider,
                                              surah: isArabic
                                                  ? surah.name.short
                                                  : surah.name.transliteration.en,
                                              surahNumber: surah.number,
                                              highlight: widget.highlightAyah ==
                                                  surah.verses[index].number
                                                      .inSurah,
                                              key: widget.highlightAyah ==
                                                      surah.verses[index].number
                                                          .inSurah
                                                  ? _highlightKey
                                                  : null,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text(context.l10n.unexpectedError));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
