import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/model/company_model.dart';
import '../../data/model/keyword_model.dart';
import '../../data/model/media_model.dart';
import '../../data/model/movie_model.dart';
import '../../data/model/person_model.dart';
import '../../data/model/tv_show_model.dart';
import '../../utils/routes/route_data.dart';
import '../../utils/theme_data.dart';
import '../common_widgets/general_widgets.dart';
import '../common_widgets/paginated_list_widgets.dart';
import 'bloc/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final PageController _pageController;
  late final ScrollController _tabScrollController;
  final List<GlobalKey> _tabKeys = List.generate(6, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedTab(int index) {
    if (!_tabScrollController.hasClients) return;

    final RenderBox tabBox = _tabKeys[index].currentContext?.findRenderObject() as RenderBox;
    final double tabPosition = tabBox.localToGlobal(Offset.zero).dx;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double scrollOffset =
        _tabScrollController.offset + tabPosition - (screenWidth / 2) + (tabBox.size.width / 2);

    _tabScrollController.animateTo(
      scrollOffset.clamp(0, _tabScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 96),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                AppBar(
                  toolbarHeight: 40,
                  backgroundColor: LightThemeColors.primary.withValues(alpha: .9),
                  foregroundColor: LightThemeColors.onPrimary,
                  titleSpacing: 0,
                  title: const _SearchField(),
                ),
                Container(
                  height: kToolbarHeight,
                  padding: const EdgeInsets.only(top: 16.0),
                  decoration: BoxDecoration(
                    color: LightThemeColors.primary.withValues(alpha: .9),
                  ),
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      // Ensure page controller is in sync with tab selection
                      if (_pageController.hasClients &&
                          _pageController.page?.round() != state.selectedTabIndex) {
                        _pageController.animateToPage(
                          state.selectedTabIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }

                      // Scroll to selected tab
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToSelectedTab(state.selectedTabIndex);
                      });

                      return SingleChildScrollView(
                        controller: _tabScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            _buildTabItem(context, 'All', 0, state, _tabKeys[0]),
                            _buildTabItem(context, 'Movies', 1, state, _tabKeys[1]),
                            _buildTabItem(context, 'Shows', 2, state, _tabKeys[2]),
                            _buildTabItem(context, 'Persons', 3, state, _tabKeys[3]),
                            _buildTabItem(context, 'Keywords', 4, state, _tabKeys[4]),
                            _buildTabItem(context, 'Companies', 5, state, _tabKeys[5]),
                            const SizedBox(width: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final bloc = context.read<SearchBloc>();

          if (state is SearchInitial) {
            return const _EmptySearchState();
          }

          return PageView(
            controller: _pageController,
            onPageChanged: (index) {
              context.read<SearchBloc>().add(SearchTabSelected(index));
            },
            children: [
              RefreshIndicator(
                displacement: 120,
                onRefresh: () => Future.sync(() => bloc.getController(0).refresh()),
                child: PagedListView<int, MediaModel>(
                  pagingController: bloc.getController(0) as PagingController<int, MediaModel>,
                  builderDelegate: _buildDelegate<MediaModel>(state.copyWith(selectedTabIndex: 0)),
                ),
              ),
              RefreshIndicator(
                displacement: 120,
                onRefresh: () => Future.sync(() => bloc.getController(1).refresh()),
                child: PagedListView<int, MovieModel>(
                  pagingController: bloc.getController(1) as PagingController<int, MovieModel>,
                  builderDelegate: _buildDelegate<MovieModel>(state.copyWith(selectedTabIndex: 1)),
                ),
              ),
              RefreshIndicator(
                displacement: 120,
                onRefresh: () => Future.sync(() => bloc.getController(2).refresh()),
                child: PagedListView<int, TvShowModel>(
                  pagingController: bloc.getController(2) as PagingController<int, TvShowModel>,
                  builderDelegate: _buildDelegate<TvShowModel>(state.copyWith(selectedTabIndex: 2)),
                ),
              ),
              RefreshIndicator(
                displacement: 120,
                onRefresh: () => Future.sync(() => bloc.getController(3).refresh()),
                child: PagedListView<int, PersonModel>(
                  pagingController: bloc.getController(3) as PagingController<int, PersonModel>,
                  builderDelegate: _buildDelegate<PersonModel>(state.copyWith(selectedTabIndex: 3)),
                ),
              ),
              RefreshIndicator(
                displacement: 120,
                onRefresh: () => Future.sync(() => bloc.getController(4).refresh()),
                child: PagedListView<int, KeywordModel>(
                  pagingController: bloc.getController(4) as PagingController<int, KeywordModel>,
                  builderDelegate:
                      _buildDelegate<KeywordModel>(state.copyWith(selectedTabIndex: 4)),
                ),
              ),
              RefreshIndicator(
                displacement: 120,
                onRefresh: () => Future.sync(() => bloc.getController(5).refresh()),
                child: PagedListView<int, CompanyModel>(
                  pagingController: bloc.getController(5) as PagingController<int, CompanyModel>,
                  builderDelegate:
                      _buildDelegate<CompanyModel>(state.copyWith(selectedTabIndex: 5)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PagedChildBuilderDelegate<T> _buildDelegate<T>(SearchState state) {
    return PagedChildBuilderDelegate<T>(
      itemBuilder: (context, item, index) => _SearchResultItem(
        item: item,
        index: index,
        tabIndex: state.selectedTabIndex,
      ),
      firstPageErrorIndicatorBuilder: (context) => FirstPageError(
        pagingController: context.read<SearchBloc>().getController(state.selectedTabIndex),
        title: 'Search Results',
      ),
      firstPageProgressIndicatorBuilder: (context) =>
          state is SearchLoadInProgress ? const FirstPageProgress() : const SizedBox.shrink(),
      newPageErrorIndicatorBuilder: (context) => NewPageError(
          pagingController: context.read<SearchBloc>().getController(state.selectedTabIndex)),
      newPageProgressIndicatorBuilder: (context) => const NewPageProgress(),
      noItemsFoundIndicatorBuilder: (context) => const Center(
        child: Text(
          'No results found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      noMoreItemsIndicatorBuilder: (context) => const SizedBox.shrink(),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, int index, SearchState state, Key key) {
    final count = state.resultCounts[index] ?? 0;
    final isLoading =
        (index == 4 && state.isLoadingKeywords) || (index == 5 && state.isLoadingCompanies);

    return Padding(
      key: key,
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          context.read<SearchBloc>().add(SearchTabSelected(index));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: state.selectedTabIndex == index
                ? LightThemeColors.background
                : LightThemeColors.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              isLoading
                  ? '$title...'
                  : count == 0
                      ? title
                      : '$title ($count)',
              style: TextStyle(
                color: state.selectedTabIndex == index ? LightThemeColors.primary : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField();

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: false,
      onChanged: (query) {
        setState(() {}); // Rebuild to show/hide clear button
        context.read<SearchBloc>().add(SearchQueryChanged(query));
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search for Media, Keyword, Company, ...',
        hintStyle: const TextStyle(color: LightThemeColors.onPrimary, fontSize: 16),
        prefixIcon: const Icon(Icons.search, color: LightThemeColors.onPrimary),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: LightThemeColors.onPrimary),
                onPressed: () {
                  _controller.clear();
                  context.read<SearchBloc>().add(const SearchQueryChanged(''));
                },
              )
            : null,
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final dynamic item;
  final int index;
  final int tabIndex;

  const _SearchResultItem({
    required this.item,
    required this.index,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    switch (tabIndex) {
      case 0:
        return _buildMediaItem(context, item as MediaModel);
      case 1:
        return _buildMovieItem(context, item as MovieModel);
      case 2:
        return _buildTvShowItem(context, item as TvShowModel);
      case 3:
        return _buildPersonItem(context, item as PersonModel);
      case 4:
        return _buildKeywordItem(context, item as KeywordModel);
      case 5:
        return _buildCompanyItem(context, item as CompanyModel);
      default:
        return _buildMediaItem(context, item as MediaModel);
    }
  }

  Widget _buildMediaItem(BuildContext context, MediaModel media) {
    switch (media.mediaType) {
      case MediaType.movie:
        return _buildMovieItem(context, media.movie!);
      case MediaType.tv:
        return _buildTvShowItem(context, media.show!);
      case MediaType.person:
        return _buildPersonItem(context, media.person!);
      case MediaType.notSet:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMovieItem(BuildContext context, MovieModel movie) {
    return VerticalListItem(item: movie, category: 'search$index${movie.id}');
  }

  Widget _buildTvShowItem(BuildContext context, TvShowModel show) {
    return VerticalListItem(item: show, category: 'search$index${show.id}');
  }

  Widget _buildPersonItem(BuildContext context, PersonModel person) {
    return VerticalPersonListItem(
        id: person.id,
        name: person.name,
        profilePath: person.profilePath ?? '',
        knownForDepartment: person.knownForDepartment,
        subtitle: person.knownForDepartment,
        category: 'search$index${person.id}');
  }

  Widget _buildKeywordItem(BuildContext context, KeywordModel keyword) {
    return ListTile(
      title: Text(keyword.name),
      onTap: () {
        context.pushReplacement('/discover',
            extra: DiscoverScreenRouteData(
              keywordId: keyword.id.toString(),
              keywordName: keyword.name,
            ));
      },
    );
  }

  Widget _buildCompanyItem(BuildContext context, CompanyModel company) {
    return ListTile(
      leading: company.logoPath == null
          ? const Icon(Icons.business)
          : Image.network(
              'https://image.tmdb.org/t/p/w92${company.logoPath}',
              width: 56,
              height: 56,
              fit: BoxFit.contain,
            ),
      title: Text(company.name),
      subtitle: Text(company.originCountry),
      onTap: () {
        context.pushReplacement('/discover',
            extra: DiscoverScreenRouteData(
              companyId: company.id.toString(),
              companyName: company.name,
            ));
      },
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Discover Your Next Favorite',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for movies, TV shows, people, keywords, or companies to explore the world of entertainment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
