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
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
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
                      .updateQuery(value, prefSetProvider.locale.languageCode),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.isIndexing) {
                        return Center(
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
                        );
                      }
                      final status = state.status.status;

                      if (status.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: prefSetProvider.isDarkTheme
                                ? Colors.white
                                : kPurplePrimary,
                          ),
                        );
                      }

                      if (status.isError) {
                        return StateMessage(
                          title: context.l10n.unexpectedError,
                          message: state.status.message.isNotEmpty
                              ? state.status.message
                              : context.l10n.unexpectedError,
                          icon: Icons.search_off_rounded,
                          isDarkTheme: prefSetProvider.isDarkTheme,
                        );
                      }

                      if (status.isHasData) {
                        final results = state.status.data ?? [];
                        if (results.isEmpty) {
                          return StateMessage(
                            title: context.l10n.noResults,
                            message: context.l10n.searchHint,
                            icon: Icons.search_off_rounded,
                            isDarkTheme: prefSetProvider.isDarkTheme,
                          );
                        }
                        return ListView.separated(
                          itemCount: results.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final result = results[index];
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
                              arabicFontScale: prefSetProvider.arabicFontScale,
                              showTranslation: prefSetProvider.showTranslation,
                              query: state.query,
                            );
                          },
                        );
                      }

                      return StateMessage(
                        title: context.l10n.searchResults,
                        message: context.l10n.searchHint,
                        icon: Icons.search_rounded,
                        isDarkTheme: prefSetProvider.isDarkTheme,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
