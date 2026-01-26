import 'package:bookmark/presentation/bloc/bloc.dart';
import 'package:bookmark/presentation/ui/widget/banner_last_read_widget.dart';
import 'package:bookmark/presentation/ui/widget/verses_widget.dart';
import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:dependencies/show_up_animation/show_up_animation.dart';
import 'package:detail_surah/presentation/cubits/last_read/last_read_cubit.dart';
import 'package:flutter/material.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }
      context.read<BookmarkBloc>().add(FetchBookmark());
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
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 28.0),
              child: SingleChildScrollView(
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
                            context.l10n.savedTitle,
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
                          return Row(
                            children: headerChildren,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ShowUpAnimation(
                      child: Text(
                        context.l10n.lastRead,
                        style: kHeading6.copyWith(
                          fontSize: 18.0,
                          color: prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kDarkPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const BannerLastReadWidget(),
                    const SizedBox(height: 30.0),
                    ShowUpAnimation(
                      child: Text(
                        context.l10n.bookmarksTitle,
                        style: kHeading6.copyWith(
                          fontSize: 18.0,
                          color: prefSetProvider.isDarkTheme
                              ? Colors.white
                              : kDarkPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    BlocBuilder<BookmarkBloc, BookmarkState>(
                      builder: (context, state) {
                        final status = state.statusBookmark.status;

                        if (status.isLoading) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(
                                color: prefSetProvider.isDarkTheme
                                    ? Colors.white
                                    : kPurplePrimary,
                              ),
                            ),
                          );
                        }
                        if (status.isError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              state.statusBookmark.message,
                              style: kSubtitle.copyWith(
                                color: prefSetProvider.isDarkTheme
                                    ? Colors.white70
                                    : kGrey,
                              ),
                            ),
                          );
                        }
                        if (status.isHasData) {
                          final bookmark = state.statusBookmark.data ?? [];
                          if (bookmark.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    ShowUpAnimation(
                                      child: Image.asset(
                                        'assets/no_data.png',
                                        width: 80.0,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    ShowUpAnimation(
                                      child: Text(
                                        context.l10n.bookmarksEmpty,
                                        style: kHeading6.copyWith(
                                          fontSize: 16.0,
                                          color: prefSetProvider.isDarkTheme
                                              ? Colors.white70
                                              : kPurplePrimary,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookmark.length,
                            itemBuilder: (context, index) {
                              return VersesWidget(
                                bookmark: bookmark[index],
                                prefSetProvider: prefSetProvider,
                              );
                            },
                          );
                        }

                        return Text(context.l10n.unexpectedError);
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
