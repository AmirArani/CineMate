import '../../utils/helpers/list_preferences.dart';
import '../../utils/web/http_client.dart';
import '../model/account_model.dart';
import '../model/movie_model.dart';
import '../model/rating_model.dart';
import '../model/tv_show_model.dart';
import '../src/account_src.dart';
import 'auth_repo.dart';
import 'movie_repo.dart';
import 'tv_repo.dart';

final accountRepo = AccountRepository(
    remoteSrc: AccountRemoteSrc(httpClient: httpClient),
    account: AccountModel(
        id: -1,
        name: 'name',
        userName: 'userName',
        avatarPath: 'avatarPath',
        gravatarHash: 'gravatarHash',
        language: 'language',
        country: 'country'));

abstract class IAccountRepository {
  Future<AccountModel> getAccountData({required String session});

  Future<int> getAccountId({required String session});

  Future<MovieListResponseModel> getFavoriteMovies(
      {required int page, required SortMethod sortMethod});
  Future<TvShowListResponseModel> getFavoriteShows(
      {required int page, required SortMethod sortMethod});
  Future<bool> editFavorite({required dynamic item, final bool delete = false});

  Future<MovieListResponseModel> getWatchListMovies(
      {required int page, required SortMethod sortMethod});
  Future<TvShowListResponseModel> getWatchListShows(
      {required int page, required SortMethod sortMethod});
  Future<bool> editWatchList({required dynamic item, final bool delete = false});

  Future<RatingMovieListResponseModel> getRatedMovies(
      {required int page, required SortMethod sortMethod});
  Future<RatingShowsListResponseModel> getRatedShows(
      {required int page, required SortMethod sortMethod});

  Future<bool> deleteRating({required dynamic item});
  Future<bool> editRating({required dynamic item, required double newRating});

  Future<MovieListResponseModel> getRecommendedMovies({required int page});

  Future<TvShowListResponseModel> getRecommendedTvShows({required int page});
}

class AccountRepository implements IAccountRepository {
  final AccountRemoteSrc _remoteSrc;
  AccountModel _account;

  AccountRepository({required AccountRemoteSrc remoteSrc, required AccountModel account})
      : _account = account,
        _remoteSrc = remoteSrc;

  @override
  Future<AccountModel> getAccountData({required String session}) async {
    _account = await _remoteSrc.getAccountData(session: session);
    return _account;
  }

  @override
  Future<int> getAccountId({required String session}) async {
    if (_account.id != -1) {
      return _account.id;
    } else {
      AccountModel account = await getAccountData(session: session);
      return account.id;
    }
  }

  @override
  Future<MovieListResponseModel> getFavoriteMovies(
      {required int page, required SortMethod sortMethod}) async {
    final String? session = await authRepo.getSessionToken();

    final MovieListResponseModel result = await _remoteSrc.getFavoriteMovies(
        accountId: _account.id, page: page, session: session!, sortMethod: sortMethod);

    //add given movies to cache
    movieRepository.updateCachedMovies(newMovies: result.movies);

    return result;
  }

  @override
  Future<TvShowListResponseModel> getFavoriteShows(
      {required int page, required SortMethod sortMethod}) async {
    final String? session = await authRepo.getSessionToken();

    final TvShowListResponseModel result = await _remoteSrc.getFavoriteShows(
        accountId: _account.id, page: page, session: session!, sortMethod: sortMethod);

    //add given shows to cache
    tvShowRepository.updateCachedTvShows(newShows: result.shows);

    return result;
  }

  @override
  Future<bool> editFavorite({required item, bool delete = false}) async {
    final String? session = await authRepo.getSessionToken();

    return await _remoteSrc.editFavorite(
        accountId: _account.id, session: session!, item: item, delete: delete);
  }

  @override
  Future<MovieListResponseModel> getWatchListMovies(
      {required int page, required SortMethod sortMethod}) async {
    final String? session = await authRepo.getSessionToken();

    final MovieListResponseModel result = await _remoteSrc.getWatchListMovies(
        accountId: _account.id, page: page, session: session!, sortMethod: sortMethod);

    //add given movies to cache
    movieRepository.updateCachedMovies(newMovies: result.movies);

    return result;
  }

  @override
  Future<TvShowListResponseModel> getWatchListShows(
      {required int page, required SortMethod sortMethod}) async {
    final String? session = await authRepo.getSessionToken();

    final TvShowListResponseModel result = await _remoteSrc.getWatchListShows(
        accountId: _account.id, page: page, session: session!, sortMethod: sortMethod);

    //add given shows to cache
    tvShowRepository.updateCachedTvShows(newShows: result.shows);

    return result;
  }

  @override
  Future<bool> editWatchList({required item, bool delete = false}) async {
    final String? session = await authRepo.getSessionToken();

    return await _remoteSrc.editWatchList(
        accountId: _account.id, session: session!, item: item, delete: delete);
  }

  @override
  Future<RatingMovieListResponseModel> getRatedMovies(
      {required int page, required SortMethod sortMethod}) async {
    final String? session = await authRepo.getSessionToken();

    final RatingMovieListResponseModel result = await _remoteSrc.getRatedMovies(
        accountId: _account.id, page: page, session: session!, sortMethod: sortMethod);

    //add given movies to cache
    final List<MovieModel> movies =
        result.ratedMovies.map((ratedMovie) => ratedMovie.movie).toList();

    movieRepository.updateCachedMovies(newMovies: movies);

    return result;
  }

  @override
  Future<RatingShowsListResponseModel> getRatedShows(
      {required int page, required SortMethod sortMethod}) async {
    final String? session = await authRepo.getSessionToken();

    final RatingShowsListResponseModel result = await _remoteSrc.getRatedShows(
        accountId: _account.id, page: page, session: session!, sortMethod: sortMethod);

    //add given shows to cache
    final List<TvShowModel> shows = result.ratedShows.map((ratedMovie) => ratedMovie.show).toList();
    tvShowRepository.updateCachedTvShows(newShows: shows);

    return result;
  }

  @override
  Future<bool> deleteRating(
      {required dynamic item, bool delete = false, double newRate = 0.5}) async {
    final String? session = await authRepo.getSessionToken();

    return await _remoteSrc.deleteRating(session: session!, item: item);
  }

  @override
  Future<bool> editRating({required item, required double newRating}) async {
    final String? session = await authRepo.getSessionToken();

    return await _remoteSrc.editRating(session: session!, item: item, newRating: newRating);
  }

  @override
  Future<MovieListResponseModel> getRecommendedMovies({required int page}) async {
    final AccountAuthModel accountData = await authRepo.getAccountAuthData();

    final MovieListResponseModel result =
        await _remoteSrc.getRecommendedMovies(accountId: accountData.accountId, page: page);

    //add given movies to cache
    movieRepository.updateCachedMovies(newMovies: result.movies);

    return result;
  }

  @override
  Future<TvShowListResponseModel> getRecommendedTvShows({required int page}) async {
    final AccountAuthModel accountData = await authRepo.getAccountAuthData();

    final TvShowListResponseModel result =
        await _remoteSrc.getRecommendedTvShows(accountId: accountData.accountId, page: page);

    //add given shows to cache
    tvShowRepository.updateCachedTvShows(newShows: result.shows);

    return result;
  }
}
