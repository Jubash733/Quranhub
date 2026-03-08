import 'package:common/utils/provider/preference_settings_provider.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:resources/constant/named_routes.dart';
import 'package:resources/extensions/context_extensions.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';
import 'package:resources/constant/route_args.dart';
import 'package:resources/widgets/state_message.dart';
import 'package:search/presentation/cubit/search_cubit.dart';
import 'package:search/presentation/ui/widget/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceSettingsProvider>(
      builder: (context, prefSetProvider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                prefSetProvider.isDarkTheme ? kDarkTheme : Colors.white,
            foregroundColor:
                prefSetProvider.isDarkTheme ? Colors.white : kDarkPurple,
            elevation: 0,
            title: Text(
              context.l10n.search,
              style: kHeading6.copyWith(fontSize: 18),
            ),
          ),
          body: SafeArea(
            top: false,
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                final status = state.status.status;
                final results = state.status.data ?? const [];
                final hasResults = status.isHasData && results.isNotEmpty;

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.0,
                    20.0,
                    20.0,
                    20.0 + bottomInset,
                  ),
                  child: CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      SliverToBoxAdapter(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: context.l10n.searchHint,
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: prefSetProvider.isDarkTheme
                                ? kDarkPurple.withValues(alpha: 0.6)
                                : kGrey92,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) => context
                              .read<SearchCubit>()
                              .updateQuery(
                                  value, prefSetProvider.locale.languageCode),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 16.0),
                      ),
                      if (state.isIndexing)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            key: const ValueKey('search-indexing'),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.l10n.searchPreparingTitle,
                                  style: kHeading6.copyWith(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  context.l10n.searchPreparingMessage,
                                  style: kSubtitle.copyWith(
                                    color: prefSetProvider.isDarkTheme
                                        ? kGreyLight
                                        : kDarkPurple.withValues(alpha: 0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: 220,
                                  child: LinearProgressIndicator(
                                    value: state.indexProgress > 0
                                        ? state.indexProgress
                                        : null,
                                    color: prefSetProvider.isDarkTheme
                                        ? Colors.white
                                        : kPurplePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (status.isLoading)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            key: const ValueKey('search-loading'),
                            child: CircularProgressIndicator(
                              color: prefSetProvider.isDarkTheme
                                  ? Colors.white
                                  : kPurplePrimary,
                            ),
                          ),
                        )
                      else if (status.isError)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: StateMessage(
                            key: const ValueKey('search-error'),
                            title: context.l10n.unexpectedError,
                            message: state.status.message.isNotEmpty
                                ? state.status.message
                                : context.l10n.unexpectedError,
                            icon: Icons.search_off_rounded,
                            isDarkTheme: prefSetProvider.isDarkTheme,
                          ),
                        )
                      else if (hasResults)
                        SliverList(
                          key: const ValueKey('search-results'),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index.isOdd) {
                                return const SizedBox(height: 12);
                              }
                              final result = results[index ~/ 2];
                              return SearchResultTile(
                                result: result,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  NamedRoutes.detailScreen,
                                  arguments: DetailScreenArgs(
                                    surahNumber: result.ref.surah,
                                    highlightAyah: result.ref.ayah,
                                  ),
                                ),
                                arabicFontFamily:
                                    prefSetProvider.arabicFontFamily,
                                arabicFontScale:
                                    prefSetProvider.arabicFontScale,
                                showTranslation:
                                    prefSetProvider.showTranslation,
                                query: state.query,
                              );
                            },
                            childCount: results.length * 2 - 1,
                          ),
                        )
                      else if (status.isHasData && results.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: StateMessage(
                            key: const ValueKey('search-empty'),
                            title: context.l10n.noResults,
                            message: context.l10n.searchHint,
                            icon: Icons.search_off_rounded,
                            isDarkTheme: prefSetProvider.isDarkTheme,
                          ),
                        )
                      else
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: StateMessage(
                            key: const ValueKey('search-initial'),
                            title: context.l10n.searchResults,
                            message: context.l10n.searchHint,
                            icon: Icons.search_rounded,
                            isDarkTheme: prefSetProvider.isDarkTheme,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
