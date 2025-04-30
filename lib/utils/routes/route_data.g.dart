// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_data.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $rootScreenRouteData,
    ];

RouteBase get $rootScreenRouteData => GoRouteData.$route(
      path: '/',
      name: 'root',
      factory: $RootScreenRouteDataExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/home',
          name: 'home',
          factory: $HomeScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/search',
          name: 'search',
          factory: $SearchScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/discover',
          name: 'discover',
          factory: $DiscoverScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/profile',
          name: 'profile',
          factory: $ProfileScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/favorites_list',
          name: 'favorites_list',
          factory: $FavoritesScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/watchlist',
          name: 'watchlist',
          factory: $WatchListScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/recommendations',
          name: 'recommendations',
          factory: $RecommendationsScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/ratings',
          name: 'ratings',
          factory: $RatingScreenRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/lists',
          name: 'lists',
          factory: $ListsScreenRouteDataExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: ':id',
              name: 'list_detail',
              factory: $ListDetailScreenRouteDataExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/login-callback',
          name: 'login-callback',
          factory: $LoginCallBackRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/movie/:id',
          name: 'movie_detail',
          factory: $MovieDetailRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/show/:id',
          name: 'tv_show_detail',
          factory: $TvShowDetailRouteDataExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/person/:id',
          name: 'person_detail',
          factory: $PersonDetailRouteDataExtension._fromState,
        ),
      ],
    );

extension $RootScreenRouteDataExtension on RootScreenRouteData {
  static RootScreenRouteData _fromState(GoRouterState state) => const RootScreenRouteData();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $HomeScreenRouteDataExtension on HomeScreenRouteData {
  static HomeScreenRouteData _fromState(GoRouterState state) => const HomeScreenRouteData();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SearchScreenRouteDataExtension on SearchScreenRouteData {
  static SearchScreenRouteData _fromState(GoRouterState state) => const SearchScreenRouteData();

  String get location => GoRouteData.$location(
        '/search',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DiscoverScreenRouteDataExtension on DiscoverScreenRouteData {
  static DiscoverScreenRouteData _fromState(GoRouterState state) => DiscoverScreenRouteData(
        keywordId: state.uri.queryParameters['keyword-id'],
        keywordName: state.uri.queryParameters['keyword-name'],
        genreId: state.uri.queryParameters['genre-id'],
        genreName: state.uri.queryParameters['genre-name'],
        companyId: state.uri.queryParameters['company-id'],
        companyName: state.uri.queryParameters['company-name'],
      );

  String get location => GoRouteData.$location(
        '/discover',
        queryParams: {
          if (keywordId != null) 'keyword-id': keywordId,
          if (keywordName != null) 'keyword-name': keywordName,
          if (genreId != null) 'genre-id': genreId,
          if (genreName != null) 'genre-name': genreName,
          if (companyId != null) 'company-id': companyId,
          if (companyName != null) 'company-name': companyName,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileScreenRouteDataExtension on ProfileScreenRouteData {
  static ProfileScreenRouteData _fromState(GoRouterState state) => const ProfileScreenRouteData();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FavoritesScreenRouteDataExtension on FavoritesScreenRouteData {
  static FavoritesScreenRouteData _fromState(GoRouterState state) =>
      const FavoritesScreenRouteData();

  String get location => GoRouteData.$location(
        '/favorites_list',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WatchListScreenRouteDataExtension on WatchListScreenRouteData {
  static WatchListScreenRouteData _fromState(GoRouterState state) =>
      const WatchListScreenRouteData();

  String get location => GoRouteData.$location(
        '/watchlist',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RecommendationsScreenRouteDataExtension on RecommendationsScreenRouteData {
  static RecommendationsScreenRouteData _fromState(GoRouterState state) =>
      const RecommendationsScreenRouteData();

  String get location => GoRouteData.$location(
        '/recommendations',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RatingScreenRouteDataExtension on RatingScreenRouteData {
  static RatingScreenRouteData _fromState(GoRouterState state) => const RatingScreenRouteData();

  String get location => GoRouteData.$location(
        '/ratings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ListsScreenRouteDataExtension on ListsScreenRouteData {
  static ListsScreenRouteData _fromState(GoRouterState state) => ListsScreenRouteData(
        refreshKey: _$convertMapValue('refresh-key', state.uri.queryParameters, int.parse),
      );

  String get location => GoRouteData.$location(
        '/lists',
        queryParams: {
          if (refreshKey != null) 'refresh-key': refreshKey!.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ListDetailScreenRouteDataExtension on ListDetailScreenRouteData {
  static ListDetailScreenRouteData _fromState(GoRouterState state) => ListDetailScreenRouteData(
        id: int.parse(state.pathParameters['id']!),
      );

  String get location => GoRouteData.$location(
        '/lists/${Uri.encodeComponent(id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginCallBackRouteDataExtension on LoginCallBackRouteData {
  static LoginCallBackRouteData _fromState(GoRouterState state) => const LoginCallBackRouteData();

  String get location => GoRouteData.$location(
        '/login-callback',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MovieDetailRouteDataExtension on MovieDetailRouteData {
  static MovieDetailRouteData _fromState(GoRouterState state) => MovieDetailRouteData(
        id: int.parse(state.pathParameters['id']!),
        posterPath: state.uri.queryParameters['poster-path'],
        cat: state.uri.queryParameters['cat'],
      );

  String get location => GoRouteData.$location(
        '/movie/${Uri.encodeComponent(id.toString())}',
        queryParams: {
          if (posterPath != null) 'poster-path': posterPath,
          if (cat != null) 'cat': cat,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TvShowDetailRouteDataExtension on TvShowDetailRouteData {
  static TvShowDetailRouteData _fromState(GoRouterState state) => TvShowDetailRouteData(
        id: int.parse(state.pathParameters['id']!),
        posterPath: state.uri.queryParameters['poster-path'],
        cat: state.uri.queryParameters['cat'],
      );

  String get location => GoRouteData.$location(
        '/show/${Uri.encodeComponent(id.toString())}',
        queryParams: {
          if (posterPath != null) 'poster-path': posterPath,
          if (cat != null) 'cat': cat,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PersonDetailRouteDataExtension on PersonDetailRouteData {
  static PersonDetailRouteData _fromState(GoRouterState state) => PersonDetailRouteData(
        id: int.parse(state.pathParameters['id']!),
        name: state.uri.queryParameters['name']!,
        profilePath: state.uri.queryParameters['profile-path'],
        knownForDepartment: state.uri.queryParameters['known-for-department']!,
        cat: state.uri.queryParameters['cat'],
      );

  String get location => GoRouteData.$location(
        '/person/${Uri.encodeComponent(id.toString())}',
        queryParams: {
          'name': name,
          if (profilePath != null) 'profile-path': profilePath,
          'known-for-department': knownForDepartment,
          if (cat != null) 'cat': cat,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}
