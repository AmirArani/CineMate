import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemate/data/repo/discover_repo.dart';
import 'package:cinemate/utils/web/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/model/genre_model.dart';
import '../../data/model/movie_model.dart';
import '../../data/model/person_model.dart';
import '../../data/model/tv_show_model.dart';
import '../../data/repo/genre_repo.dart';
import '../../data/repo/movie_repo.dart';
import '../../data/repo/person_repo.dart';
import '../../data/repo/tv_repo.dart';
import '../../gen/assets.gen.dart';
import '../../utils/theme_data.dart';
import '../common_widgets/general_widgets.dart';
import '../common_widgets/shimmers.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.background,
      extendBodyBehindAppBar: true,
      appBar: buildDefaultTabBar(title: Text('CineMate')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccessState) {
              return Main(themeData: Theme.of(context));
            } else if (state is HomeLoadingState) {
              return const _LoadingStateShimmer();
            } else if (state is HomeErrorState) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 250),
                    AppErrorWidget(
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context).add(HomeLoadEvent());
                      },
                      exception: state.exception,
                    ),
                  ],
                ),
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 124),
        const _PopularGenres(), //Popular Genres
        const SizedBox(height: 42),
        _Trending(themeData: themeData), //Trending
        const SizedBox(height: 42),
        const _LastEpisodeToAir(),
        const SizedBox(height: 42),
        _BestDrama(themeData: themeData), //Best Drama
        const SizedBox(height: 42),
        _PopularArtists(themeData: themeData), //Popular Artists
        const SizedBox(height: 42),
        _TopTvShows(themeData: themeData), //Top TV Shows
        const SizedBox(height: 128),
      ],
    );
  }
}

class _PopularGenres extends StatelessWidget {
  const _PopularGenres();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 32, left: 32),
          child: Row(
            children: [
              Text(
                'Popular Genres',
                style: TextStyle(color: LightThemeColors.gray),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder(
          future: genreRepository.getPopularGenres(),
          builder: (BuildContext context, AsyncSnapshot<List<GenreModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return GenresTopList(
                allGenres: snapshot.data,
              );
            } else {
              return const SingleRowGenresShimmer();
            }
          },
        ),
      ],
    );
  }
}

class _Trending extends StatelessWidget {
  const _Trending({required this.themeData});

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 32, left: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.img.icons.trending.svg(
                width: 22,
                theme: SvgTheme(currentColor: Colors.grey),
              ),
              const SizedBox(width: 10),
              const Text(
                "Trending",
                style: TextStyle(
                  color: LightThemeColors.gray,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder(
          future: movieRepository.getPopularMovies(),
          builder: (BuildContext context, AsyncSnapshot<List<MovieModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return HorizontalList(
                items: snapshot.data,
                themeData: themeData,
                category: 'trending',
              );
            } else {
              return const HorizontalListShimmer();
            }
          },
        ),
      ],
    );
  }
}

class _LastEpisodeToAir extends StatelessWidget {
  const _LastEpisodeToAir();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return (state is HomeSuccessState)
              ? Container(
                  height: 179,
                  width: 330,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [LightThemeColors.secondary, LightThemeColors.tertiary]),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w185${state.lastEpisodeToAir.posterPath}',
                          width: 120,
                          height: 179,
                          fit: BoxFit.cover,
                          fadeInCurve: Curves.easeIn,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 185,
                              child: Text(
                                state.lastEpisodeToAir.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Season ${state.lastEpisodeToAir.numberOfSeasons} | Episode ${state.lastEpisodeToAir.numberOfEpisodes}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 180,
                              child: Text(
                                state.lastEpisodeToAir.overview,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  height: 1.05,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : (state is HomeLoadingState)
                  ? SizedBox(
                      height: 179,
                      width: 330,
                      child: Shimmer(
                        gradient: LinearGradient(
                          colors: [
                            LightThemeColors.tertiary.withValues(alpha: .3),
                            LightThemeColors.secondary.withValues(alpha: .2)
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: LightThemeColors.background,
                          ),
                          height: 179,
                          width: 330,
                        ),
                      ),
                    )
                  : const SizedBox();
        },
      ),
    );
  }
}

class _BestDrama extends StatelessWidget {
  const _BestDrama({required this.themeData});

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 32, left: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.img.icons.bestDrama.svg(
                height: 24,
                width: 24,
                theme: SvgTheme(currentColor: Colors.grey),
              ),
              const SizedBox(width: 10),
              const Text(
                "Best Drama",
                style: TextStyle(
                  color: LightThemeColors.gray,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder(
          future: discoverRepo.getMoviesInGenre(genreId: dramaGenreId, page: 1),
          builder: (BuildContext context, AsyncSnapshot<MovieListResponseModel> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return HorizontalList(
                items: snapshot.data!.movies,
                themeData: themeData,
                category: 'bestDrama',
              );
            } else {
              return const HorizontalListShimmer();
            }
          },
        ),
      ],
    );
  }
}

class _PopularArtists extends StatelessWidget {
  const _PopularArtists({required this.themeData});

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 32, left: 32),
          child: Row(
            children: [
              Text(
                'Popular Artist',
                style: TextStyle(color: LightThemeColors.gray),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder(
          future: personRepository.getPopularArtists(),
          builder: (BuildContext context, AsyncSnapshot<List<PersonModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return SizedBox(
                height: 168,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(23, 0, 23, 0),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return HorizontalPersonListItem(
                      themeData: themeData,
                      person: snapshot.data![index],
                      category: 'popular$index',
                    );
                  },
                ),
              );
            } else {
              return const ArtistShimmer();
            }
          },
        ),
      ],
    );
  }
}

class _TopTvShows extends StatelessWidget {
  const _TopTvShows({required this.themeData});

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 32, left: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.img.icons.tvShow.svg(
                width: 24,
                theme: SvgTheme(currentColor: Colors.grey),
              ),
              const SizedBox(width: 10),
              const Text(
                "Top TV Shows",
                style: TextStyle(
                  color: LightThemeColors.gray,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ), //title
        const SizedBox(height: 12),
        FutureBuilder(
          future: tvShowRepository.getTopTvShows(),
          builder: (BuildContext context, AsyncSnapshot<List<TvShowModel>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return HorizontalList(
                items: snapshot.data!,
                themeData: themeData,
                category: 'top',
              );
            } else {
              return const HorizontalListShimmer();
            }
          },
        ),
      ],
    );
  }
}

class _LoadingStateShimmer extends StatelessWidget {
  const _LoadingStateShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 124),
          const Padding(
            padding: EdgeInsets.only(right: 32, left: 32),
            child: Row(
              children: [
                Text(
                  'Popular Genres',
                  style: TextStyle(color: LightThemeColors.gray),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const SingleRowGenresShimmer(),
          const SizedBox(height: 42),
          Padding(
            padding: const EdgeInsets.only(right: 32, left: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.img.icons.trending.svg(
                  width: 22,
                  theme: SvgTheme(currentColor: Colors.grey),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Trending",
                  style: TextStyle(
                    color: LightThemeColors.gray,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const HorizontalListShimmer(),
          const SizedBox(height: 42),
          SizedBox(
            height: 179,
            width: 330,
            child: Shimmer(
              gradient: LinearGradient(
                colors: [
                  LightThemeColors.tertiary.withValues(alpha: .3),
                  LightThemeColors.secondary.withValues(alpha: .2)
                ],
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: LightThemeColors.background,
                ),
                height: 179,
                width: 330,
              ),
            ),
          )
        ],
      ),
    );
  }
}
