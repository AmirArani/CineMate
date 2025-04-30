import 'package:dio/dio.dart';

import '../../utils/helpers/list_preferences.dart';
import '../../utils/web/urls.dart';
import '../model/account_model.dart';
import '../model/movie_model.dart';
import '../model/rating_model.dart';
import '../model/tv_show_model.dart';

abstract class IAccountSrc {
  Future<AccountModel> getAccountData({required String session});

  Future<MovieListResponseModel> getFavoriteMovies(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod});
  Future<TvShowListResponseModel> getFavoriteShows(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod});
  Future<bool> editFavorite(
      {required int accountId,
      required String session,
      required dynamic item,
      required bool delete});

  Future<MovieListResponseModel> getWatchListMovies(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod});
  Future<TvShowListResponseModel> getWatchListShows(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod});
  Future<bool> editWatchList(
      {required int accountId,
      required String session,
      required dynamic item,
      required bool delete});

  Future<RatingMovieListResponseModel> getRatedMovies(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod});
  Future<RatingShowsListResponseModel> getRatedShows(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod});
  Future<bool> deleteRating({required String session, required dynamic item});
  Future<bool> editRating(
      {required String session, required dynamic item, required double newRating});

  Future<MovieListResponseModel> getRecommendedMovies(
      {required String accountId, required int page});

  Future<TvShowListResponseModel> getRecommendedTvShows(
      {required String accountId, required int page});
}

class AccountRemoteSrc implements IAccountSrc {
  final Dio _httpClient;

  AccountRemoteSrc({required Dio httpClient}) : _httpClient = httpClient;

  @override
  Future<AccountModel> getAccountData({required String session}) async {
    final response = await _httpClient.get(
      getAccountDetail,
      queryParameters: {'session_id': session},
    );

    final AccountModel accountData = AccountModel.fromJson(response.data);

    return accountData;
  }

  @override
  Future<MovieListResponseModel> getFavoriteMovies(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod}) async {
    final response = await _httpClient.get(
      getFavoriteMoviesURL(accountId: accountId),
      queryParameters: {
        'page': page,
        'session_id': session,
        'sort_by': sortMethod.toServerString,
      },
    );
    final MovieListResponseModel movieListResponseModel =
        MovieListResponseModel.fromJson(response.data);

    return movieListResponseModel;
  }

  @override
  Future<TvShowListResponseModel> getFavoriteShows(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod}) async {
    final response = await _httpClient.get(
      getFavoriteShowsURL(accountId: accountId),
      queryParameters: {
        'page': page,
        'session_id': session,
        'sort_by': sortMethod.toServerString,
      },
    );
    final TvShowListResponseModel showListResponseModel =
        TvShowListResponseModel.fromJson(response.data);

    return showListResponseModel;
  }

  @override
  Future<bool> editFavorite(
      {required int accountId,
      required String session,
      required dynamic item,
      required bool delete}) async {
    try {
      final response = await _httpClient.post(editMediaFavoriteURL(accountId: accountId),
          queryParameters: {'session_id': session},
          data: {
            "media_type": (item is MovieModel)
                ? "movie"
                : (item is TvShowModel)
                    ? 'tv'
                    : '',
            "media_id": (item is MovieModel || item is TvShowModel) ? item.id : '',
            "favorite": !delete,
          },
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      final bool result = response.data['success'];

      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<MovieListResponseModel> getWatchListMovies(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod}) async {
    final response = await _httpClient.get(
      getWatchListMoviesURL(accountId: accountId),
      queryParameters: {
        'page': page,
        'session_id': session,
        'sort_by': sortMethod.toServerString,
      },
    );
    final MovieListResponseModel movieListResponseModel =
        MovieListResponseModel.fromJson(response.data);

    return movieListResponseModel;
  }

  @override
  Future<TvShowListResponseModel> getWatchListShows(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod}) async {
    final response = await _httpClient.get(
      getWatchListShowsURL(accountId: accountId),
      queryParameters: {
        'page': page,
        'session_id': session,
        'sort_by': sortMethod.toServerString,
      },
    );
    final TvShowListResponseModel showListResponseModel =
        TvShowListResponseModel.fromJson(response.data);

    return showListResponseModel;
  }

  @override
  Future<bool> editWatchList(
      {required int accountId,
      required String session,
      required dynamic item,
      required bool delete}) async {
    try {
      final response = await _httpClient.post(editMediaWatchlistURL(accountId: accountId),
          queryParameters: {'session_id': session},
          data: {
            "media_type": (item is MovieModel)
                ? "movie"
                : (item is TvShowModel)
                    ? 'tv'
                    : '',
            "media_id": (item is MovieModel || item is TvShowModel) ? item.id : '',
            "watchlist": !delete,
          },
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      final bool result = response.data['success'];

      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<RatingMovieListResponseModel> getRatedMovies(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod}) async {
    final response = await _httpClient.get(
      getRatedMoviesURL(accountId: accountId),
      queryParameters: {
        'page': page,
        'session_id': session,
        'sort_by': sortMethod.toServerString,
      },
    );
    final RatingMovieListResponseModel ratedMoviesListResponseModel =
        RatingMovieListResponseModel.fromJson(response.data);

    return ratedMoviesListResponseModel;
  }

  @override
  Future<RatingShowsListResponseModel> getRatedShows(
      {required int accountId,
      required int page,
      required String session,
      required SortMethod sortMethod}) async {
    final response = await _httpClient.get(
      getRatedShowsURL(accountId: accountId),
      queryParameters: {
        'page': page,
        'session_id': session,
        'sort_by': sortMethod.toServerString,
      },
    );
    final RatingShowsListResponseModel ratedShowsListResponseModel =
        RatingShowsListResponseModel.fromJson(response.data);

    return ratedShowsListResponseModel;
  }

  @override
  Future<bool> deleteRating({required String session, required dynamic item}) async {
    final response = await _httpClient.delete(
        (item is RatedMovieModel)
            ? editMovieRatingURL(movieId: item.movie.id)
            : (item is RatedShowModel)
                ? editShowRatingURL(showId: item.show.id)
                : '',
        queryParameters: {'session_id': session},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ));

    final bool result = response.data['success'];

    return result;
  }

  @override
  Future<bool> editRating(
      {required String session, required item, required double newRating}) async {
    try {
      final response = await _httpClient.post(
          (item is RatedMovieModel)
              ? editMovieRatingURL(movieId: item.movie.id)
              : (item is RatedShowModel)
                  ? editShowRatingURL(showId: item.show.id)
                  : (item is MovieModel)
                      ? editMovieRatingURL(movieId: item.id)
                      : (item is TvShowModel)
                          ? editShowRatingURL(showId: item.id)
                          : '',
          queryParameters: {'session_id': session},
          data: {'value': newRating},
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      final bool result = response.data['success'];

      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<MovieListResponseModel> getRecommendedMovies(
      {required String accountId, required int page}) async {
    final response = await _httpClient.get(
      getRecommendedMoviesURL(accountId: accountId),
      queryParameters: {'page': page},
    );
    final MovieListResponseModel movieListResponseModel =
        MovieListResponseModel.fromJson(response.data);

    return movieListResponseModel;
  }

  @override
  Future<TvShowListResponseModel> getRecommendedTvShows(
      {required String accountId, required int page}) async {
    final response = await _httpClient.get(
      getRecommendedTvShowsURL(accountId: accountId),
      queryParameters: {'page': page},
    );
    final TvShowListResponseModel showsListResponseModel =
        TvShowListResponseModel.fromJson(response.data);

    return showsListResponseModel;
  }
}
