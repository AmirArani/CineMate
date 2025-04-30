import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../data/model/tv_show_model.dart';
import '../../../../data/repo/account_repo.dart';
import '../../../common_widgets/general_widgets.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import 'bloc/recommended_shows_bloc.dart';

class RecommendedShowsScreen extends StatelessWidget {
  const RecommendedShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendedShowsBloc(
        accountRepo: accountRepo,
      )..add(RecommendedShowsPageRequested(1)),
      child: _RecommendedShowsView(),
    );
  }
}

class _RecommendedShowsView extends StatelessWidget {
  const _RecommendedShowsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecommendedShowsBloc, RecommendedShowsState>(
      listener: (context, state) {
        // Handle external preference changes if needed
      },
      child: Scaffold(
        body: _ShowListContent(),
      ),
    );
  }
}

class _ShowListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecommendedShowsBloc>();
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
      child: PagedListView<int, TvShowModel>(
        pagingController: bloc.pagingController,
        builderDelegate: PagedChildBuilderDelegate<TvShowModel>(
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VerticalListItem(item: item, category: 'recommendedShows$index'),
          ),
          firstPageErrorIndicatorBuilder: (context) =>
              FirstPageError(pagingController: bloc.pagingController, title: 'Recommended Shows'),
          firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
          newPageErrorIndicatorBuilder: (context) =>
              NewPageError(pagingController: bloc.pagingController),
          newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
          noItemsFoundIndicatorBuilder: (context) =>
              const NoItemsFound(type: 'recommended', title: 'Shows'),
          noMoreItemsIndicatorBuilder: (context) => const NoMoreItems(),
        ),
      ),
    );
  }
}
