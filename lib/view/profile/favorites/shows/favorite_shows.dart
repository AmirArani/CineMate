import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../data/model/tv_show_model.dart';
import '../../../../data/repo/account_repo.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/helpers/list_preferences.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import 'bloc/favorite_shows_bloc.dart';

class FavoriteShowsScreen extends StatelessWidget {
  final ListPreferences listPreferences;

  const FavoriteShowsScreen({super.key, required this.listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteShowsBloc(
        accountRepo: accountRepo,
        initialPreferences: listPreferences,
      )..add(FavoriteShowsPreferencesChanged(listPreferences)),
      child: _FavoriteShowsView(listPreferences: listPreferences),
    );
  }
}

class _FavoriteShowsView extends StatelessWidget {
  const _FavoriteShowsView({required ListPreferences listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteShowsBloc, FavoriteShowsState>(
      listener: (context, state) {
        // Handle external preference changes if needed
      },
      child: Scaffold(
        floatingActionButton: _SortButton(),
        body: _ShowListContent(),
      ),
    );
  }
}

class _ShowListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FavoriteShowsBloc>();
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
      child: PagedListView<int, TvShowModel>(
        pagingController: bloc.pagingController,
        builderDelegate: PagedChildBuilderDelegate<TvShowModel>(
          itemBuilder: (context, item, index) => ListShowItem(
            item: item,
            index: index,
            cat: 'favoriteShows$index',
            pagingController: bloc.pagingController,
            onDelete: () => accountRepo.editFavorite(item: item, delete: true),
          ),
          firstPageErrorIndicatorBuilder: (context) =>
              FirstPageError(pagingController: bloc.pagingController, title: 'Favorite Shows'),
          firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
          newPageErrorIndicatorBuilder: (context) =>
              NewPageError(pagingController: bloc.pagingController),
          newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
          noItemsFoundIndicatorBuilder: (context) =>
              const NoItemsFound(type: 'favorite', title: 'Shows'),
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
    final bloc = context.read<FavoriteShowsBloc>();

    return BlocBuilder<FavoriteShowsBloc, FavoriteShowsState>(
      builder: (context, state) {
        return bloc.pagingController.itemList == null
            ? SizedBox()
            : bloc.pagingController.itemList!.isEmpty
                ? SizedBox()
                : FloatingActionButton.extended(
                    heroTag: 'favoriteShows',
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
                      bloc.add(FavoriteShowsPreferencesChanged(newPrefs));
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
