import 'package:cinemate/view/common_widgets/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../data/model/movie_model.dart';
import '../../../../data/repo/account_repo.dart';
import '../../../common_widgets/paginated_list_widgets.dart';
import 'bloc/recommended_movies_bloc.dart';

class RecommendedMoviesScreen extends StatelessWidget {
  const RecommendedMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendedMoviesBloc(
        accountRepo: accountRepo,
      )..add(RecommendedMoviesPageRequested(1)),
      child: _RecommendedMoviesView(),
    );
  }
}

class _RecommendedMoviesView extends StatelessWidget {
  const _RecommendedMoviesView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecommendedMoviesBloc, RecommendedMoviesState>(
      listener: (context, state) {
        // Handle external preference changes if needed
      },
      child: Scaffold(
        body: _MovieListContent(),
      ),
    );
  }
}

class _MovieListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecommendedMoviesBloc>();
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => bloc.pagingController.refresh()),
      child: PagedListView<int, MovieModel>(
        pagingController: bloc.pagingController,
        builderDelegate: PagedChildBuilderDelegate<MovieModel>(
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VerticalListItem(item: item, category: 'recommendedMovies$index'),
          ),
          firstPageErrorIndicatorBuilder: (context) =>
              FirstPageError(pagingController: bloc.pagingController, title: 'Recommended Movies'),
          firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
          newPageErrorIndicatorBuilder: (context) =>
              NewPageError(pagingController: bloc.pagingController),
          newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
          noItemsFoundIndicatorBuilder: (context) =>
              const NoItemsFound(type: 'recommended', title: 'Movies'),
          noMoreItemsIndicatorBuilder: (context) => const NoMoreItems(),
        ),
      ),
    );
  }
}
