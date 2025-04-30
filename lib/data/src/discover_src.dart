import 'package:cinemate/data/model/movie_model.dart';
import 'package:cinemate/data/model/tv_show_model.dart';
import 'package:dio/dio.dart';

import '../../utils/web/urls.dart';
import '../model/discover_params_model.dart';

class DiscoverRemoteSrc {
  final Dio httpClient;

  DiscoverRemoteSrc(this.httpClient);

  Future<MovieListResponseModel> discoverMovies({
    required DiscoverMovieParams params,
    required int page,
  }) async {
    final queryParams = {
      'page': page,
      ...params.toJson(),
    };
    print('Discover movies API call: $discoverMoviesURL');
    print('Query params: $queryParams');

    final response = await httpClient.get(
      discoverMoviesURL,
      queryParameters: queryParams,
    );

    final results = MovieListResponseModel.fromJson(response.data);
    print('Got ${results.movies.length} movies');
    return results;
  }

  Future<TvShowListResponseModel> discoverTvShows({
    required DiscoverTvParams params,
    required int page,
  }) async {
    final queryParams = {
      'page': page,
      ...params.toJson(),
    };
    print('Discover TV shows API call: $discoverTvShowsURL');
    print('Query params: $queryParams');

    final response = await httpClient.get(
      discoverTvShowsURL,
      queryParameters: queryParams,
    );

    final results = TvShowListResponseModel.fromJson(response.data);
    print('Got ${results.shows.length} TV shows');
    return results;
  }

  Future<MovieListResponseModel> getMoviesInGenre({
    required int genreId,
    required int page,
  }) async {
    final params = DiscoverMovieParams(withGenres: genreId.toString());
    return discoverMovies(params: params, page: page);
  }
}
