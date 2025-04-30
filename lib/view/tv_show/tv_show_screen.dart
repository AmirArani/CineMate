import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/model/list_model.dart';
import '../../data/model/tv_show_model.dart';
import '../../utils/theme_data.dart';
import '../common_widgets/movie_and_show_widgets.dart';
import '../common_widgets/tabs_widgets.dart';
import '../profile/list/all/list_screen.dart';
import 'bloc/tv_show_bloc.dart';
import 'listBloc/tv_show_list_bloc.dart';
import 'tabsBloc/tv_show_tabs_bloc.dart';

class TvShowScreen extends StatefulWidget {
  final int showId;
  final String posterPath;
  final String category;

  const TvShowScreen(
      {super.key, required this.showId, required this.posterPath, required this.category});

  @override
  State<TvShowScreen> createState() => _TvShowScreenState();
}

class _TvShowScreenState extends State<TvShowScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabLabels = const [
    'Overview',
    'Episodes',
    'Cast & Crew',
    'Reviews',
    'Similar TvShows'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final index = _tabController.index;
        final tabsBloc = BlocProvider.of<TvShowTabsBloc>(context);
        final showBloc = BlocProvider.of<TvShowBloc>(context);
        final tabState = tabsBloc.state;
        final showState = showBloc.state;

        if (index == 1) {
          tabsBloc.add(TvShowSeasonsAndEpisodesTabLoadEvent(
              id: widget.showId,
              state: tabState,
              showData: (tabState is TvShowLoaded && showState is TvShowLoaded)
                  ? showState.tvShowData
                  : null));
        } else if (index == 2) {
          BlocProvider.of<TvShowTabsBloc>(context)
              .add(TvShowCreditsTabLoadEvent(id: widget.showId, state: tabState));
        } else if (index == 3) {
          BlocProvider.of<TvShowTabsBloc>(context)
              .add(TvShowReviewsTabLoadEvent(id: widget.showId, state: tabState));
        } else if (index == 4) {
          BlocProvider.of<TvShowTabsBloc>(context)
              .add(TvShowSimilarTabLoadEvent(id: widget.showId, state: tabState));
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowBloc, TvShowState>(
      builder: (context, state) {
        final TvShowModel show = state.tvShow;
        return BlocBuilder<TvShowTabsBloc, TvShowTabsState>(
          builder: (context, tabState) {
            return Scaffold(
              body: Stack(
                children: [
                  // Main content with proper nested scrolling
                  NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 450,
                            child: Stack(
                              children: [
                                TopBackDrop(backdropPath: state.tvShow.backdropPath),
                                MainPoster(
                                    category: widget.category,
                                    posterPath: widget.posterPath,
                                    id: widget.showId),
                                (state is TvShowLoaded)
                                    ? TitleAndInfo(
                                        title: state.tvShowData.name,
                                        tagLine: state.tvShowData.tagLine,
                                        originalLanguage: state.tvShowData.originalLanguage,
                                        vote: state.tvShowData.vote,
                                        runtime: null,
                                        genres: state.tvShowData.genres)
                                    : TitleAndInfo(
                                        title: state.tvShow.title,
                                        tagLine: null,
                                        originalLanguage: state.tvShow.originalLanguage,
                                        vote: state.tvShow.vote,
                                        runtime: null,
                                        genres: null),
                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: _SliverAppBarDelegate(TabBar(
                            controller: _tabController,
                            tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
                            labelColor: Theme.of(context).colorScheme.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Theme.of(context).colorScheme.primary,
                          )),
                          pinned: true,
                        )
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        (state is TvShowLoaded)
                            ? TabOverview(
                                overView: show.overview,
                                releaseDate: show.releaseDate,
                                status: state.tvShowData.status,
                                originCountry: show.originCountry,
                                homePageURL: state.tvShowData.homepageUrl,
                                imdbId: null,
                                backdropPaths: state.backdropPaths,
                                isShow: true,
                                nextEpisode: state.tvShowData.nextEpisodeToAir,
                                lastEpisode: state.tvShowData.lastEpisodeToAir,
                                isLoaded: true)
                            : TabOverview(
                                overView: show.overview,
                                releaseDate: show.releaseDate,
                                status: null,
                                originCountry: show.originCountry,
                                homePageURL: null,
                                imdbId: null,
                                backdropPaths: null,
                                isShow: true,
                                lastEpisode: null,
                                nextEpisode: null,
                                isLoaded: false),
                        TabSeasonAndEpisode((state is TvShowLoaded) ? state.tvShowData : null),
                        TabCastAndCrew(
                            id: widget.showId,
                            credits: tabState.credits,
                            isLoading: tabState.isLoadingCredits,
                            isFailed: tabState.isCreditsFailed),
                        TabsReviews(
                            id: widget.showId,
                            reviews: tabState.reviews,
                            isLoading: tabState.isLoadingReviews,
                            isFailed: tabState.isReviewsFailed),
                        TabSimilar(
                          id: widget.showId,
                          items: tabState.similarTvShows,
                          isLoading: tabState.isLoadingSimilar,
                          isFailed: tabState.isSimilarFailed,
                          isMovie: false,
                        ),
                      ],
                    ),
                  ),
                  // Movie Action Bar
                  Positioned(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    bottom: 10,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: _ActionBar(showId: widget.showId),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Custom SliverPersistentHeaderDelegate for the tab bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _ActionBar extends StatelessWidget {
  final int showId;

  const _ActionBar({required this.showId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowBloc, TvShowState>(
      builder: (blocContext, state) {
        return (state is TvShowLoaded)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          LightThemeColors.tertiary.withValues(alpha: 0.7),
                          LightThemeColors.secondary.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          enabled: state.accountState.favorite,
                          loading: state.favoriteLoading,
                          enabledIcon: 'assets/img/icons/profile/un_favorite.svg',
                          disabledIcon: 'assets/img/icons/profile/favorites.svg',
                          onTap: () {
                            BlocProvider.of<TvShowBloc>(context).add(
                              ToggleFavoriteEvent(state: state, context: blocContext),
                            );
                          },
                        ),
                        _ActionButton(
                          enabled: state.accountState.watchlist,
                          loading: state.watchlistLoading,
                          disabledIcon: 'assets/img/icons/profile/bookmark.svg',
                          enabledIcon: 'assets/img/icons/profile/un_bookmark.svg',
                          onTap: () {
                            BlocProvider.of<TvShowBloc>(context).add(
                              ToggleWatchlistEvent(state: state, context: blocContext),
                            );
                          },
                        ),
                        _ActionButton(
                          enabled: state.accountState.rate != null,
                          loading: state.ratingLoading,
                          disabledIcon: 'assets/img/icons/profile/star.svg',
                          enabledIcon: 'assets/img/icons/profile/un_star.svg',
                          label: state.accountState.rate?.toStringAsFixed(0),
                          onTap: () {
                            BlocProvider.of<TvShowBloc>(context).add(
                              OpenRatingBottomSheetEvent(
                                state: state,
                                context: blocContext,
                              ),
                            );
                          },
                        ),
                        _ActionButton(
                          enabled: false,
                          loading: false,
                          disabledIcon: 'assets/img/icons/profile/list-add.svg',
                          enabledIcon: '',
                          onTap: () {
                            // Show modal bottom sheet with lists
                            _showAddToListModal(context, state.tvShow);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox();
      },
    );
  }

  // Show the modal bottom sheet for adding a TvShow to a list
  void _showAddToListModal(BuildContext context, TvShowModel show) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (modalContext) {
          return BlocProvider(
            create: (context) {
              final bloc = TvShowListBloc();
              // Reset and request the first page
              bloc.pagingController.refresh();
              return bloc;
            },
            child: _AddToListModal(show: show),
          );
        },
      );
    } catch (e) {
      debugPrint('Error showing add to list modal: $e');
      // Show a fallback UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final bool enabled;
  final bool loading;
  final String enabledIcon;
  final String disabledIcon;
  final String? label;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.enabled,
      required this.loading,
      required this.enabledIcon,
      required this.disabledIcon,
      this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowBloc, TvShowState>(
      builder: (context, state) {
        return InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loading
                  ? SizedBox(
                      height: 28,
                      width: 28,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : SvgPicture.asset(
                      enabled ? enabledIcon : disabledIcon,
                      width: 28,
                      height: 28,
                      color: Colors.white,
                    ),
              SizedBox(width: label == null ? 0 : 6),
              label != null
                  ? Text(
                      label!,
                      style: TextStyle(color: Colors.white),
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

// Modal bottom sheet for adding a tv-show to a list
class _AddToListModal extends StatelessWidget {
  final TvShowModel show;

  const _AddToListModal({required this.show});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Add "${show.title}" to list',
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Add a "Create New List" button
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OutlinedButton.icon(
                onPressed: () => _showCreateListModal(context),
                icon: Icon(Icons.add),
                label: Text('Create New List'),
                style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 44)),
              ),
            ),
          ),
          Text(
            'Your Lists',
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          SizedBox(height: 8),
          BlocConsumer<TvShowListBloc, TvShowListState>(
            listener: (context, state) {
              if (state is TvShowListAddSuccess) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${show.title}" to "${state.listName}" list'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is TvShowListError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.error}'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final bloc = BlocProvider.of<TvShowListBloc>(context);

              if (state is TvShowListAdding) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Adding to list...'),
                      ],
                    ),
                  ),
                );
              }

              return Flexible(
                child: PagedListView<int, ListModel>(
                  pagingController: bloc.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ListModel>(
                    itemBuilder: (context, item, index) {
                      return ListItem(
                          item: item,
                          index: index,
                          onTap: () {
                            BlocProvider.of<TvShowListBloc>(context).add(TvShowListAddTvShowEvent(
                                listId: item.id, show: show, listName: item.name));
                          });
                    },
                    firstPageErrorIndicatorBuilder: (context) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Failed to load lists'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => bloc.pagingController.refresh(),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    firstPageProgressIndicatorBuilder: (context) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    newPageErrorIndicatorBuilder: (context) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () => bloc.pagingController.retryLastFailedRequest(),
                          child: Text('Error loading more lists. Tap to retry.'),
                        ),
                      ),
                    ),
                    newPageProgressIndicatorBuilder: (context) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('You don\'t have any lists yet.'),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreateListModal(BuildContext context) {
    bool isPublic = true;
    bool isLoading = false;
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return BlocProvider.value(
          value: BlocProvider.of<TvShowListBloc>(context), // Use the same bloc instance
          child: BlocConsumer<TvShowListBloc, TvShowListState>(
            listener: (context, state) {
              if (state is TvShowListCreateSuccess) {
                // Show success notification
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('List "${state.listName}" created successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // Close the create list modal
                Navigator.pop(context);
              } else if (state is TvShowListError) {
                // Reset loading state
                isLoading = false;

                // Show error notification
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.error}'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                            child: Text(
                              'Create a new List',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Divider(thickness: 0.5),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  style: TextStyle(fontSize: 15),
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: TextStyle(fontSize: 15),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 16),
                                TextField(
                                  style: TextStyle(fontSize: 15),
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    labelStyle: TextStyle(fontSize: 15),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  maxLines: 2,
                                  minLines: 1,
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(isPublic ? 'Public List' : 'Private List'),
                                    Switch(
                                      value: isPublic,
                                      onChanged: (value) {
                                        setState(() {
                                          isPublic = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline_rounded),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'You can set list backdrop after adding some items to it, in "Edit List" page.',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: isLoading || state is TvShowListCreating
                                      ? null
                                      : () {
                                          if (nameController.text.trim().isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Please enter a list name'),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                            return;
                                          }

                                          setState(() {
                                            isLoading = true;
                                          });

                                          // Create the list through the bloc
                                          BlocProvider.of<TvShowListBloc>(context).add(
                                            TvShowListCreateEvent(
                                              name: nameController.text.trim(),
                                              description: descriptionController.text.trim(),
                                              isPublic: isPublic,
                                            ),
                                          );
                                        },
                                  style: ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(Size(200, 24)),
                                    backgroundColor:
                                        WidgetStatePropertyAll(LightThemeColors.primary),
                                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                                  ),
                                  child: (isLoading || state is TvShowListCreating)
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1,
                                          ),
                                        )
                                      : Text('Submit'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
