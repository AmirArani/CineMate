import 'package:cinemate/view/profile/recommendations/list/bloc/recommendations_bloc.dart';
import 'package:cinemate/view/profile/recommendations/movies/bloc/recommended_movies_bloc.dart';
import 'package:cinemate/view/profile/recommendations/shows/bloc/recommended_shows_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'data/model/account_model.dart';
import 'data/repo/account_repo.dart';
import 'data/repo/auth_repo.dart';
import 'data/repo/discover_repo.dart';
import 'data/repo/genre_repo.dart';
import 'data/repo/list_repo.dart';
import 'data/repo/movie_repo.dart';
import 'data/repo/person_repo.dart';
import 'data/repo/tv_repo.dart';
import 'data/src/account_src.dart';
import 'data/src/auth_src.dart';
import 'data/src/genre_src.dart';
import 'data/src/list_src.dart';
import 'data/src/movie_src.dart';
import 'data/src/person_src.dart';
import 'data/src/tv_src.dart';
import 'utils/helpers/list_preferences.dart';
import 'utils/routes/route_config.dart';
import 'utils/theme_data.dart';
import 'utils/web/http_client.dart';
import 'view/discover/bloc/discover_bloc.dart';
import 'view/home/bloc/home_bloc.dart';
import 'view/movie/bloc/movie_bloc.dart';
import 'view/movie/listBloc/movie_list_bloc.dart';
import 'view/movie/tabsBloc/movie_tabs_bloc.dart';
import 'view/person/bloc/person_bloc.dart';
import 'view/profile/bloc/profile_bloc.dart';
import 'view/profile/call_back/bloc/login_callback_bloc.dart';
import 'view/profile/favorites/list/bloc/favorites_bloc.dart';
import 'view/profile/favorites/movies/bloc/favorite_movies_bloc.dart';
import 'view/profile/favorites/shows/bloc/favorite_shows_bloc.dart';
import 'view/profile/list/all/bloc/list_bloc.dart';
import 'view/profile/list/detail/bloc/list_detail_bloc.dart';
import 'view/profile/list/detail/edit_bloc/list_edit_bloc.dart';
import 'view/profile/watchLists/list/bloc/watch_list_bloc.dart';
import 'view/profile/watchLists/movie/bloc/watch_list_movie_bloc.dart';
import 'view/profile/watchLists/shows/bloc/watch_list_show_bloc.dart';
import 'view/search/bloc/search_bloc.dart';
import 'view/tv_show/bloc/tv_show_bloc.dart';
import 'view/tv_show/listBloc/tv_show_list_bloc.dart';
import 'view/tv_show/tabsBloc/tv_show_tabs_bloc.dart';

void main() {
  GoRouter.optionURLReflectsImperativeAPIs = true; // Ensure URL reflects navigation changes

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => HomeBloc()..add(HomeLoadEvent())),
      BlocProvider(create: (context) => ProfileBloc()..add(ProfileLoadEvent())),
      BlocProvider(create: (context) => MovieBloc()),
      BlocProvider(create: (context) => MovieTabsBloc()),
      BlocProvider(create: (context) => TvShowBloc()),
      BlocProvider(create: (context) => TvShowTabsBloc()),
      BlocProvider(create: (context) => PersonBloc()),
      BlocProvider(create: (context) => LoginCallbackBloc()),
      BlocProvider(create: (context) => FavoritesBloc()..add(SelectMovieTabEvent(0))),
      BlocProvider(
          create: (context) => FavoriteMoviesBloc(
              accountRepo: accountRepo,
              initialPreferences: ListPreferences(sortMethod: SortMethod.createdAtAsc))),
      BlocProvider(
          create: (context) => FavoriteShowsBloc(
              accountRepo: accountRepo,
              initialPreferences: ListPreferences(sortMethod: SortMethod.createdAtAsc))),
      BlocProvider(create: (context) => WatchListBloc()..add(SelectWatchListTabEvent(0))),
      BlocProvider(
          create: (context) => WatchListMoviesBloc(
              accountRepo: accountRepo,
              initialPreferences: ListPreferences(sortMethod: SortMethod.createdAtAsc))),
      BlocProvider(
          create: (context) => WatchListShowsBloc(
              accountRepo: accountRepo,
              initialPreferences: ListPreferences(sortMethod: SortMethod.createdAtAsc))),
      BlocProvider(
          create: (context) => RecommendationsBloc()..add(SelectRecommendationTabEvent(0))),
      BlocProvider(create: (context) => RecommendedMoviesBloc(accountRepo: accountRepo)),
      BlocProvider(create: (context) => RecommendedShowsBloc(accountRepo: accountRepo)),
      BlocProvider(create: (context) => ListBloc()),
      BlocProvider(create: (context) => ListDetailBloc()),
      BlocProvider(create: (context) => ListEditBloc()),
      BlocProvider(create: (context) => MovieListBloc()),
      BlocProvider(create: (context) => TvShowListBloc()),
      BlocProvider(create: (context) => SearchBloc()),
      BlocProvider(create: (context) => DiscoverBloc()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(color: LightThemeColors.onBackground, fontFamily: "Avenir");

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) => AuthRepository(
                remoteSrc: AuthRemoteSrc(httpClient: httpClient),
                localSrc: AuthLocalSrc(storage: FlutterSecureStorage()))),
        RepositoryProvider(
            create: (context) => MovieRepository(MovieRemoteSrc(httpClient), MovieCacheSrc())),
        RepositoryProvider(
            create: (context) => TvShowRepository(TvRemoteSrc(httpClient), TvShowCacheSrc())),
        RepositoryProvider(create: (context) => GenreRepository(GenreRemoteSrc(httpClient))),
        RepositoryProvider(
            create: (context) => PersonRepository(PersonRemoteSrc(httpClient), PersonCacheSrc())),
        RepositoryProvider(
            create: (context) => AccountRepository(
                remoteSrc: AccountRemoteSrc(httpClient: httpClient),
                account: AccountModel(
                    id: -1,
                    name: 'name',
                    userName: 'userName',
                    avatarPath: 'avatarPath',
                    gravatarHash: 'gravatarHash',
                    language: 'language',
                    country: 'country'))),
        RepositoryProvider(
            create: (context) => ListRepository(remoteSrc: ListRemoteSrc(httpClient: httpClient))),
        RepositoryProvider(create: (context) => discoverRepo),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: LightThemeColors.primary,
            secondary: LightThemeColors.secondary,
            onSecondary: Colors.white,
            surface: LightThemeColors.background,
          ),
          textTheme: TextTheme(
            headlineSmall: defaultTextStyle,
            titleLarge: defaultTextStyle,
            bodyLarge: defaultTextStyle.copyWith(fontSize: 20),
            bodyMedium: defaultTextStyle.copyWith(
              color: LightThemeColors.primary.withValues(alpha: 0.6),
              fontSize: 15,
              height: 1.3,
            ),
            labelLarge: defaultTextStyle,
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle:
                defaultTextStyle.copyWith(color: LightThemeColors.background, fontSize: 22),
          ),
          tabBarTheme: TabBarTheme(
            labelStyle: defaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.red,
            type: BottomNavigationBarType.shifting,
            unselectedItemColor: Colors.grey,
            selectedItemColor: LightThemeColors.secondary,
          ),
        ),
        title: 'CineMate',
        routerConfig: routerConfig,
      ),
    );
  }
}
