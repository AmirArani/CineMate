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
import 'bloc/rating_shows_bloc.dart';

class RatingShowsScreen extends StatelessWidget {
  final ListPreferences listPreferences;

  const RatingShowsScreen({super.key, required this.listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingShowsBloc(
        accountRepo: accountRepo,
        initialPreferences: listPreferences,
      )..add(RatingShowsPreferencesChanged(listPreferences)),
      child: _RatingShowsView(listPreferences: listPreferences),
    );
  }
}

class _RatingShowsView extends StatelessWidget {
  const _RatingShowsView({required ListPreferences listPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingShowsBloc, RatingShowsState>(
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
    final bloc = context.read<RatingShowsBloc>();
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
      child: PagedListView<int, RatedShowModel>(
        pagingController: bloc.pagingController,
        builderDelegate: PagedChildBuilderDelegate<RatedShowModel>(
          itemBuilder: (context, item, index) => ListRatedShowsItem(
            item: item,
            index: index,
            cat: 'RatingShows$index',
            pagingController: bloc.pagingController,
          ),
          firstPageErrorIndicatorBuilder: (context) =>
              FirstPageError(pagingController: bloc.pagingController, title: 'Rating Shows'),
          firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
          newPageErrorIndicatorBuilder: (context) =>
              NewPageError(pagingController: bloc.pagingController),
          newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
          noItemsFoundIndicatorBuilder: (context) =>
              const NoItemsFound(type: 'Rating', title: 'Shows'),
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
    final bloc = context.read<RatingShowsBloc>();

    return BlocBuilder<RatingShowsBloc, RatingShowsState>(
      builder: (context, state) {
        return bloc.pagingController.itemList == null
            ? SizedBox()
            : bloc.pagingController.itemList!.isEmpty
                ? SizedBox()
                : FloatingActionButton.extended(
                    heroTag: 'RatingShows',
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
                      bloc.add(RatingShowsPreferencesChanged(newPrefs));
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
