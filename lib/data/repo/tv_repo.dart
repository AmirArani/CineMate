import 'package:cinemate/data/repo/person_repo.dart';

import '../../utils/web/http_client.dart';
import '../model/account_state_model.dart';
import '../model/credit_model.dart';
import '../model/person_model.dart';
import '../model/review_model.dart';
import '../model/tv_show_model.dart';
import '../src/tv_src.dart';

final tvShowRepository = TvShowRepository(TvRemoteSrc(httpClient), TvShowCacheSrc());

abstract class ITvRepository {
  Future<List<TvShowModel>> getTopTvShows();
  Future<TvShowDetailModel> getLatestFeaturedEpisode();
  Future<TvShowDetailModel> getTvShowDetail({required int id});
  Future<List<String>> getTvShowImages({required int id});
  Future<List<SeasonDetailModel>> getTvShowSeasonsAndEpisodes(
      {required TvShowDetailModel showData});
  Future<CreditModel> getTvShowCastAndCrew({required int id});
  Future<List<ReviewModel>> getTvShowReviews({required int id});
  Future<List<TvShowModel>> getSimilarTvShows({required int id});
  TvShowModel? getTvShowById({required int id});
  void updateCachedTvShows({required List<TvShowModel> newShows});

  Future<AccountStateModel> getAccountState({required int id});
}

class TvShowRepository implements ITvRepository {
  final ITvDataSrc _remoteSrc;
  final TvShowCacheSrc _cacheSrc;

  TvShowRepository(this._remoteSrc, this._cacheSrc);

  @override
  Future<List<TvShowModel>> getTopTvShows() => _remoteSrc.getTopTvShows(cache: _cacheSrc);

  @override
  Future<TvShowDetailModel> getLatestFeaturedEpisode() =>
      _remoteSrc.getLatestFeaturedEpisode(cache: _cacheSrc);

  @override
  Future<List<TvShowModel>> getSimilarTvShows({required int id}) =>
      _remoteSrc.getSimilarTvShows(id: id, cache: _cacheSrc);

  @override
  Future<CreditModel> getTvShowCastAndCrew({required int id}) async {
    final CreditModel credit = await _remoteSrc.getTvShowCastAndCrew(id: id);
    final List<PersonModel> newPersons = List.empty(growable: true);

    for (CastModel cast in credit.cast) {
      newPersons.add(PersonModel(
          id: cast.id,
          name: cast.name,
          gender: Gender.notSet,
          profilePath: cast.profilePath,
          knownForDepartment: cast.knownForDepartment,
          knownFor: null));
    }
    for (CrewModel cast in credit.crew) {
      newPersons.add(PersonModel(
          id: cast.id,
          name: cast.name,
          gender: Gender.notSet,
          profilePath: cast.profilePath,
          knownForDepartment: cast.knownForDepartment,
          knownFor: null));
    }

    personRepository.updateCachedPersons(newPersons: newPersons);

    return credit;
  }

  @override
  Future<TvShowDetailModel> getTvShowDetail({required int id}) =>
      _remoteSrc.getTvShowDetail(id: id);

  @override
  Future<List<String>> getTvShowImages({required int id}) => _remoteSrc.getTvShowImages(id: id);

  @override
  Future<List<SeasonDetailModel>> getTvShowSeasonsAndEpisodes(
          {required TvShowDetailModel showData}) =>
      _remoteSrc.getSeasonsAndEpisodes(showData: showData);

  @override
  Future<List<ReviewModel>> getTvShowReviews({required int id}) =>
      _remoteSrc.getTvShowReviews(id: id);

  @override
  TvShowModel? getTvShowById({required int id}) => _cacheSrc.getShowById(id);

  @override
  void updateCachedTvShows({required List<TvShowModel> newShows}) =>
      _cacheSrc.updateCachedTvShows(newShows);

  @override
  Future<AccountStateModel> getAccountState({required int id}) =>
      _remoteSrc.getAccountState(id: id);
}
