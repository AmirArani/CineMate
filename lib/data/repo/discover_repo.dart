import '../../utils/web/http_client.dart';
import '../model/discover_params_model.dart';
import '../model/movie_model.dart';
import '../model/tv_show_model.dart';
import '../src/discover_src.dart';
import 'movie_repo.dart';
import 'tv_repo.dart';

final discoverRepo = DiscoverRepository(DiscoverRemoteSrc(httpClient));

class DiscoverRepository {
  final DiscoverRemoteSrc _remoteSrc;

  DiscoverRepository(this._remoteSrc);

  Future<MovieListResponseModel> discoverMovies({
    required DiscoverMovieParams params,
    required int page,
  }) async {
    final results = await _remoteSrc.discoverMovies(params: params, page: page);
    movieRepository.updateCachedMovies(newMovies: results.movies);
    return results;
  }

  Future<TvShowListResponseModel> discoverTvShows({
    required DiscoverTvParams params,
    required int page,
  }) async {
    final results = await _remoteSrc.discoverTvShows(params: params, page: page);
    tvShowRepository.updateCachedTvShows(newShows: results.shows);
    return results;
  }

  Future<MovieListResponseModel> getMoviesInGenre({
    required int genreId,
    required int page,
  }) async {
    final results = await _remoteSrc.getMoviesInGenre(genreId: genreId, page: page);
    movieRepository.updateCachedMovies(newMovies: results.movies);
    return results;
  }
}
