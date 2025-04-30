import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../data/model/movie_model.dart';
import '../../../../data/repo/account_repo.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/helpers/list_preferences.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import 'bloc/favorite_movies_bloc.dart';

class FavoriteMoviesScreen extends StatelessWidget {
  final ListPreferences listPreferences;

  const FavoriteMoviesScreen({super.key, required this.listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteMoviesBloc(
        accountRepo: accountRepo,
        initialPreferences: listPreferences,
      )..add(FavoriteMoviesPreferencesChanged(listPreferences)),
      child: _FavoriteMoviesView(listPreferences: listPreferences),
    );
  }
}

class _FavoriteMoviesView extends StatelessWidget {
  const _FavoriteMoviesView({required ListPreferences listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteMoviesBloc, FavoriteMoviesState>(
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
    final bloc = context.read<FavoriteMoviesBloc>();
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
      child: PagedListView<int, MovieModel>(
        pagingController: bloc.pagingController,
        builderDelegate: PagedChildBuilderDelegate<MovieModel>(
          itemBuilder: (context, item, index) => ListMovieItem(
            item: item,
            index: index,
            cat: 'favoriteMovies$index',
            pagingController: bloc.pagingController,
            onDelete: () => accountRepo.editFavorite(item: item, delete: true),
          ),
          firstPageErrorIndicatorBuilder: (context) =>
              FirstPageError(pagingController: bloc.pagingController, title: 'Favorite Movies'),
          firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
          newPageErrorIndicatorBuilder: (context) =>
              NewPageError(pagingController: bloc.pagingController),
          newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
          noItemsFoundIndicatorBuilder: (context) =>
              const NoItemsFound(type: 'favorite', title: 'Movies'),
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
    final bloc = context.read<FavoriteMoviesBloc>();

    return BlocBuilder<FavoriteMoviesBloc, FavoriteMoviesState>(
      builder: (context, state) {
        return bloc.pagingController.itemList == null
            ? SizedBox()
            : bloc.pagingController.itemList!.isEmpty
                ? SizedBox()
                : FloatingActionButton.extended(
                    heroTag: 'favoriteMovies',
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
                      bloc.add(FavoriteMoviesPreferencesChanged(newPrefs));
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
