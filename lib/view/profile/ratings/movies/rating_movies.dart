import 'package:cinemate/data/model/rating_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../data/repo/account_repo.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/helpers/list_preferences.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import '../ratingListItemWidgets.dart';
import 'bloc/rating_movies_bloc.dart';

class RatingMoviesScreen extends StatelessWidget {
  final ListPreferences listPreferences;

  const RatingMoviesScreen({super.key, required this.listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingMoviesBloc(
        accountRepo: accountRepo,
        initialPreferences: listPreferences,
      )..add(RatingMoviesPreferencesChanged(listPreferences)),
      child: _RatingMoviesView(listPreferences: listPreferences),
    );
  }
}

class _RatingMoviesView extends StatelessWidget {
  const _RatingMoviesView({required ListPreferences listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingMoviesBloc, RatingMoviesState>(
      listener: (context, state) {
        // Handle external preference changes if needed
      },
      child: Scaffold(
        floatingActionButton: _SortButton(),
        body: _MovieListContent(),
      ),
    );
  }
}

class _MovieListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RatingMoviesBloc>();
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
      child: PagedListView<int, RatedMovieModel>(
        pagingController: bloc.pagingController,
        builderDelegate: PagedChildBuilderDelegate<RatedMovieModel>(
          itemBuilder: (context, item, index) => ListRatedMovieItem(
            item: item,
            index: index,
            cat: 'RatingMovies$index',
            pagingController: bloc.pagingController,
          ),
          firstPageErrorIndicatorBuilder: (context) =>
              FirstPageError(pagingController: bloc.pagingController, title: 'Rating Movies'),
          firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
          newPageErrorIndicatorBuilder: (context) =>
              NewPageError(pagingController: bloc.pagingController),
          newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
          noItemsFoundIndicatorBuilder: (context) =>
              const NoItemsFound(type: 'rated', title: 'Movies'),
          noMoreItemsIndicatorBuilder: (context) => const NoMoreItems(),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RatingMoviesBloc>();

    return BlocBuilder<RatingMoviesBloc, RatingMoviesState>(
      builder: (context, state) {
        return bloc.pagingController.itemList == null
            ? SizedBox()
            : bloc.pagingController.itemList!.isEmpty
                ? SizedBox()
                : FloatingActionButton.extended(
                    heroTag: 'RatingMovies',
                    onPressed: () {
                      // Get current preferences from BLoC state
                      final currentSortMethod = state.preferences.sortMethod;

                      // Toggle based on current state
                      final newSortMethod = currentSortMethod == SortMethod.createdAtAsc
                          ? SortMethod.createdAtDesc
                          : SortMethod.createdAtAsc;

                      // Create new preferences with updated sort method
                      final newPrefs = state.preferences.copyWith(sortMethod: newSortMethod);

                      // Add event with new preferences
                      bloc.add(RatingMoviesPreferencesChanged(newPrefs));
                    },
                    icon: state.preferences.sortMethod.toHumanString.isAscending
                        ? Assets.img.icons.sortAscending.svg(
                            theme: SvgTheme(currentColor: Colors.white),
                          )
                        : Assets.img.icons.sortDescending.svg(
                            theme: SvgTheme(currentColor: Colors.white),
                          ),
                    label: Text(state.preferences.sortMethod.toHumanString.sortMethod),
                  );
      },
    );
  }
}
