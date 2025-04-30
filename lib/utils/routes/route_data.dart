import 'package:cinemate/view/profile/recommendations/list/recommendations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/discover_params_model.dart';
import '../../root.dart';
import '../../view/discover/bloc/discover_bloc.dart';
import '../../view/discover/discover_screen.dart';
import '../../view/home/home_screen.dart';
import '../../view/movie/bloc/movie_bloc.dart';
import '../../view/movie/movie_screen.dart';
import '../../view/movie/tabsBloc/movie_tabs_bloc.dart';
import '../../view/person/bloc/person_bloc.dart';
import '../../view/person/person_screen.dart';
import '../../view/profile/bloc/profile_bloc.dart';
import '../../view/profile/call_back/login_callback_screen.dart';
import '../../view/profile/favorites/list/favorites_screen.dart';
import '../../view/profile/list/all/bloc/list_bloc.dart';
import '../../view/profile/list/all/list_screen.dart';
import '../../view/profile/list/detail/bloc/list_detail_bloc.dart';
import '../../view/profile/list/detail/list_detail_screen.dart';
import '../../view/profile/profile_screen.dart';
import '../../view/profile/ratings/list/rating_screen.dart';
import '../../view/profile/watchLists/list/watchLists_screen.dart';
import '../../view/search/search_screen.dart';
import '../../view/tv_show/bloc/tv_show_bloc.dart';
import '../../view/tv_show/tabsBloc/tv_show_tabs_bloc.dart';
import '../../view/tv_show/tv_show_screen.dart';

part 'route_data.g.dart'; // name of generated file

// Custom transition builder
CustomTransitionPage<T> buildCustomTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Simple fade transition
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

// Define how your route tree (path and sub-routes)
@TypedGoRoute<RootScreenRouteData>(
  name: 'root',
  path: '/',
  routes: [
    TypedGoRoute<HomeScreenRouteData>(name: 'home', path: '/home'),
    TypedGoRoute<SearchScreenRouteData>(name: 'search', path: '/search'),
    TypedGoRoute<DiscoverScreenRouteData>(name: 'discover', path: '/discover'),
    TypedGoRoute<ProfileScreenRouteData>(name: 'profile', path: '/profile'),
    TypedGoRoute<FavoritesScreenRouteData>(name: 'favorites_list', path: '/favorites_list'),
    TypedGoRoute<WatchListScreenRouteData>(name: 'watchlist', path: '/watchlist'),
    TypedGoRoute<RecommendationsScreenRouteData>(name: 'recommendations', path: '/recommendations'),
    TypedGoRoute<RatingScreenRouteData>(name: 'ratings', path: '/ratings'),
    TypedGoRoute<ListsScreenRouteData>(
        name: 'lists',
        path: '/lists',
        routes: [TypedGoRoute<ListDetailScreenRouteData>(name: 'list_detail', path: ':id')]),
    TypedGoRoute<LoginCallBackRouteData>(name: 'login-callback', path: '/login-callback'),
    TypedGoRoute<MovieDetailRouteData>(name: 'movie_detail', path: '/movie/:id'),
    TypedGoRoute<TvShowDetailRouteData>(name: 'tv_show_detail', path: '/show/:id'),
    TypedGoRoute<PersonDetailRouteData>(name: 'person_detail', path: '/person/:id'),
  ],
)
@immutable
class RootScreenRouteData extends GoRouteData {
  const RootScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const RootScreen();
}

@immutable
class HomeScreenRouteData extends GoRouteData {
  const HomeScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildCustomTransitionPage(
      context: context,
      state: state,
      child: build(context, state),
    );
  }
}

@immutable
class DiscoverScreenRouteData extends GoRouteData {
  final String? keywordId;
  final String? keywordName;
  final String? genreId;
  final String? genreName;
  final String? companyId;
  final String? companyName;

  const DiscoverScreenRouteData({
    this.keywordId,
    this.keywordName,
    this.genreId,
    this.genreName,
    this.companyId,
    this.companyName,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    DiscoverMovieParams? movieParams;
    DiscoverTvParams? tvParams;
    Map<String, String> initialKeywordNames = {};

    if (keywordId != null && keywordName != null) {
      movieParams = DiscoverMovieParams(
        sortBy: DiscoverSortOptions.popularityDesc,
        withKeywords: keywordId,
      );
      tvParams = DiscoverTvParams(
        sortBy: DiscoverSortOptions.popularityDesc,
        withKeywords: keywordId,
      );
      initialKeywordNames[keywordId!] = keywordName!;
    } else if (genreId != null) {
      movieParams = DiscoverMovieParams(
        sortBy: DiscoverSortOptions.popularityDesc,
        withGenres: genreId,
      );
      tvParams = DiscoverTvParams(
        sortBy: DiscoverSortOptions.popularityDesc,
        withGenres: genreId,
      );
    } else if (companyId != null) {
      movieParams = DiscoverMovieParams(
        sortBy: DiscoverSortOptions.popularityDesc,
        withCompanies: companyId,
      );
      tvParams = DiscoverTvParams(
        sortBy: DiscoverSortOptions.popularityDesc,
        withCompanies: companyId,
      );
    }

    return BlocProvider(
      create: (context) => DiscoverBloc(
        initialMovieParams: movieParams,
        initialTvParams: tvParams,
        initialKeywordNames: initialKeywordNames,
      ),
      child: const DiscoverScreen(),
    );
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildCustomTransitionPage(
      context: context,
      state: state,
      child: build(context, state),
    );
  }
}

@immutable
class LoginCallBackRouteData extends GoRouteData {
  const LoginCallBackRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    BlocProvider.of<ProfileBloc>(context).add(GetAccessTokenEvent(ctx: context));
    return LoginCallbackScreen();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildCustomTransitionPage(
      context: context,
      state: state,
      child: build(context, state),
    );
  }
}

@immutable
class SearchScreenRouteData extends GoRouteData {
  const SearchScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SearchScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildCustomTransitionPage(
      context: context,
      state: state,
      child: build(context, state),
    );
  }
}

@immutable
class ProfileScreenRouteData extends GoRouteData {
  const ProfileScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ProfileScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildCustomTransitionPage(
      context: context,
      state: state,
      child: build(context, state),
    );
  }
}

@immutable
class FavoritesScreenRouteData extends GoRouteData {
  const FavoritesScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FavoritesScreen();
  }
}

@immutable
class WatchListScreenRouteData extends GoRouteData {
  const WatchListScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WatchListScreen();
  }
}

@immutable
class RecommendationsScreenRouteData extends GoRouteData {
  const RecommendationsScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RecommendationsScreen();
  }
}

@immutable
class RatingScreenRouteData extends GoRouteData {
  const RatingScreenRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RatingScreen();
  }
}

@immutable
class ListsScreenRouteData extends GoRouteData {
  final int? refreshKey;

  const ListsScreenRouteData({this.refreshKey});

  static ListsScreenRouteData fromState(GoRouterState state) {
    final refreshKey = int.tryParse(state.uri.queryParameters['refresh'] ?? '');
    return ListsScreenRouteData(refreshKey: refreshKey);
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ListBloc()
              ..add(refreshKey != null ? ListRefreshRequested() : ListPageRequested(1))),
      ],
      child: const ListScreen(),
    );
  }
}

@immutable
class ListDetailScreenRouteData extends GoRouteData {
  final int id;

  const ListDetailScreenRouteData({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ListDetailBloc()..add(LoadListDetailEvent(id: id))),
      ],
      child: ListDetailScreen(listId: id),
    );
  }
}

@immutable
class MovieDetailRouteData extends GoRouteData {
  final int id;
  final String? posterPath;
  final String? cat;

  const MovieDetailRouteData({required this.id, required this.posterPath, required this.cat});

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => MovieBloc()..add(MovieLoadEvent(context: context, id: id))),
          BlocProvider(create: (context) => MovieTabsBloc()..add(MovieTabsReloadEvent(id: id)))
        ],
        child: MovieScreen(movieId: id, posterPath: posterPath ?? '', category: cat ?? ''),
      );
}

@immutable
class TvShowDetailRouteData extends GoRouteData {
  final int id;
  final String? posterPath;
  final String? cat;

  const TvShowDetailRouteData({required this.id, required this.posterPath, required this.cat});

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TvShowBloc()..add(TvShowLoadEvent(context: context, id: id))),
          BlocProvider(create: (context) => TvShowTabsBloc()..add(TvShowTabsReloadEvent(id: id)))
        ],
        child: TvShowScreen(showId: id, posterPath: posterPath ?? '', category: cat ?? ''),
      );
}

@immutable
class PersonDetailRouteData extends GoRouteData {
  final int id;
  final String name;
  final String? profilePath;
  final String knownForDepartment;
  final String? cat;

  const PersonDetailRouteData(
      {required this.id,
      required this.name,
      required this.profilePath,
      required this.knownForDepartment,
      required this.cat});

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => PersonBloc()..add(PersonLoadEvent(context: context, id: id))),
        ],
        child: PersonScreen(
            personId: id,
            profilePath: profilePath ?? '',
            category: cat ?? '',
            name: name,
            knownForDepartment: knownForDepartment),
      );
}
