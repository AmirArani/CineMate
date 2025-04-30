import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/model/movie_model.dart';
import '../../data/model/tv_show_model.dart';
import '../../utils/theme_data.dart';
import '../common_widgets/general_widgets.dart';
import '../common_widgets/paginated_list_widgets.dart';
import 'bloc/discover_bloc.dart';
import 'widgets/discover_filter_dialog.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DiscoverView();
  }
}

class _DiscoverView extends StatefulWidget {
  const _DiscoverView();

  @override
  State<_DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<_DiscoverView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      context.read<DiscoverBloc>().add(DiscoverTabSelected(_tabController.index));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    final bloc = context.read<DiscoverBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: false,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.95,
            minChildSize: 0.5,
            shouldCloseOnMinExtent: true,
            expand: false,
            maxChildSize: 0.95,
            builder: (_, controller) => DiscoverFilterDialog(
              isMovie: _tabController.index == 0,
              scrollController: controller,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: LightThemeColors.background,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 96),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  children: [
                    AppBar(
                      elevation: 0,
                      toolbarHeight: 40,
                      foregroundColor: Colors.white,
                      backgroundColor: LightThemeColors.primary.withValues(alpha: .9),
                      title: const Text('Discover'),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FilledButton.icon(
                            label: Text('Filters'),
                            icon: const Icon(Icons.filter_list),
                            onPressed: _showFilterDialog,
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(LightThemeColors.secondary)),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: kToolbarHeight,
                      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                      decoration: BoxDecoration(
                        color: LightThemeColors.primary.withValues(alpha: .9),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_tabController.index != 0) {
                                  _tabController.animateTo(0);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _tabController.index == 0
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
                                      color: _tabController.index == 0
                                          ? LightThemeColors.primary
                                          : Colors.white,
                                      fontWeight: _tabController.index == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_tabController.index != 1) {
                                  _tabController.animateTo(1);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _tabController.index == 1
                                      ? LightThemeColors.background
                                      : LightThemeColors.primary,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'TV Shows',
                                    style: TextStyle(
                                      color: _tabController.index == 1
                                          ? LightThemeColors.primary
                                          : Colors.white,
                                      fontWeight: _tabController.index == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                displacement: 120,
                onRefresh: () =>
                    Future.sync(() => context.read<DiscoverBloc>().moviePagingController.refresh()),
                child: PagedListView<int, MovieModel>(
                  pagingController: context.read<DiscoverBloc>().moviePagingController,
                  builderDelegate: PagedChildBuilderDelegate<MovieModel>(
                    itemBuilder: (context, movie, index) => VerticalListItem(
                      item: movie,
                      category: 'discover$index${movie.id}',
                    ),
                    firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
                    newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
                    firstPageErrorIndicatorBuilder: (context) => FirstPageError(
                      pagingController: context.read<DiscoverBloc>().moviePagingController,
                      title: 'Discover Movies',
                    ),
                    newPageErrorIndicatorBuilder: (context) => NewPageError(
                      pagingController: context.read<DiscoverBloc>().moviePagingController,
                    ),
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text(
                        'No movies found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              RefreshIndicator(
                displacement: 120,
                onRefresh: () => Future.sync(
                    () => context.read<DiscoverBloc>().tvShowPagingController.refresh()),
                child: PagedListView<int, TvShowModel>(
                  pagingController: context.read<DiscoverBloc>().tvShowPagingController,
                  builderDelegate: PagedChildBuilderDelegate<TvShowModel>(
                    itemBuilder: (context, show, index) => VerticalListItem(
                      item: show,
                      category: 'discover$index${show.id}',
                    ),
                    firstPageProgressIndicatorBuilder: (context) => const FirstPageProgress(),
                    newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
                    firstPageErrorIndicatorBuilder: (context) => FirstPageError(
                      pagingController: context.read<DiscoverBloc>().tvShowPagingController,
                      title: 'Discover TV Shows',
                    ),
                    newPageErrorIndicatorBuilder: (context) => NewPageError(
                      pagingController: context.read<DiscoverBloc>().tvShowPagingController,
                    ),
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text(
                        'No TV shows found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
