import 'package:dio/dio.dart';

import '../../utils/web/urls.dart';
import '../model/account_state_model.dart';
import '../model/credit_model.dart';
import '../model/movie_model.dart';
import '../model/review_model.dart';

abstract class IMovieDataSource {
  Future<List<MovieModel>> getPopularMovies({required MovieCacheSrc cache});
  Future<MovieDetailModel> getMovieDetail({required int id});
  Future<List<String>> getMovieImages({required int id});
  Future<CreditModel> getMovieCastAndCrew({required int id});
  Future<List<ReviewModel>> getMovieReviews({required int id});
  Future<List<MovieModel>> getSimilarMovies({required int id, required MovieCacheSrc cache});

  Future<AccountStateModel> getAccountState({required int id});
}

class MovieRemoteSrc implements IMovieDataSource {
  final Dio httpClient;

  MovieRemoteSrc(this.httpClient);

  @override
  Future<List<MovieModel>> getPopularMovies({required MovieCacheSrc cache}) async {
    final response = await httpClient.get(getPopularMoviesURL);

    final List<MovieModel> popularMovies = MovieListResponseModel.fromJson(response.data).movies;

    cache.updateCachedMovies(popularMovies);

    return popularMovies;
  }

  @override
  Future<MovieDetailModel> getMovieDetail({required int id}) async {
    final response = await httpClient.get(getMovieDetailsURL(id));
    final MovieDetailModel movieDetail;

    movieDetail = MovieDetailModel.fromJson(response.data);

    return movieDetail;
  }

  @override
  Future<List<String>> getMovieImages({required int id}) async {
    final response = await httpClient.get(getMovieImagesURL(id));
    final List<String> images = List.empty(growable: true);

    for (var backdrop in (response.data['backdrops'])) {
      images.add(backdrop['file_path']);
      if (images.length == 25) break;
    }

    return images;
  }

  @override
  Future<CreditModel> getMovieCastAndCrew({required int id}) async {
    final response = await httpClient.get(getMovieCastAndCrewURL(id));
    final List<CastModel> casts = [];
    List<CrewModel> crews = [];

    for (var cast in (response.data['cast'])) {
      casts.add(CastModel.fromJsom(cast));
      if (casts.length == 5) break;
    }

    for (var crew in (response.data['crew'])) {
      if (crew['profile_path'] != null) {
        crews.add(CrewModel.fromJsom(crew));
      }
    }

    crews.sort((a, b) => b.popularity.compareTo(a.popularity));
    if (crews.length > 5) crews.removeRange(5, crews.length - 1);

    return CreditModel(cast: casts, crew: crews);
  }

  @override
  Future<List<ReviewModel>> getMovieReviews({required int id}) async {
    final response = await httpClient.get(getMovieReviewsURL(id));
    final List<ReviewModel> reviews = [];

    for (var review in (response.data['results'])) {
      reviews.add(ReviewModel.fromJson(review));
    }

    return reviews;
  }

  @override
  Future<List<MovieModel>> getSimilarMovies({required int id, required MovieCacheSrc cache}) async {
    final response = await httpClient.get(getSimilarMoviesURL(id));
    final List<MovieModel> movies = [];

    for (var movie in (response.data['results'])) {
      movies.add(MovieModel.fromJson(movie));
    }

    cache.updateCachedMovies(movies);

    return movies;
  }

  @override
  Future<AccountStateModel> getAccountState({required int id}) async {
    final response = await httpClient.get(getMovieAccountStateURL(id));
    return AccountStateModel.fromJson(response.data);
  }
}

class MovieCacheSrc {
  final Map<int, MovieModel> movieCache = {};

  void updateCachedMovies(List<MovieModel> newMovies) {
    for (final newMovie in newMovies) {
      movieCache[newMovie.id] = newMovie;
    }
  }

  MovieModel? getMovieById(int movieId) {
    return movieCache[movieId];
  }
}
