import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/helpers/list_preferences.dart';
import '../../../../utils/theme_data.dart';
import '../movie/watchlist_movies.dart';
import '../shows/watchlist_show_screen.dart';
import 'bloc/watch_list_bloc.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchListBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: LightThemeColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 28,
          title: const Text("WatchList"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
              decoration: BoxDecoration(color: LightThemeColors.primary),
              child: BlocBuilder<WatchListBloc, WatchListState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<WatchListBloc>().add(const SelectWatchListTabEvent(0));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: state.selectedTabIndex == 0
                                  ? LightThemeColors.background
                                  : LightThemeColors.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Movies',
                                style: TextStyle(
                                  color: state.selectedTabIndex == 0
                                      ? LightThemeColors.primary
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<WatchListBloc>().add(const SelectWatchListTabEvent(1));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: state.selectedTabIndex == 1
                                  ? LightThemeColors.background
                                  : LightThemeColors.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Tv Shows',
                                style: TextStyle(
                                  color: state.selectedTabIndex == 1
                                      ? LightThemeColors.primary
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        body: BlocBuilder<WatchListBloc, WatchListState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.selectedTabIndex,
              children: [
                WatchListMoviesScreen(
                  listPreferences: ListPreferences(sortMethod: SortMethod.createdAtDesc),
                ),
                WatchListShowsScreen(
                  listPreferences: ListPreferences(sortMethod: SortMethod.createdAtDesc),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
