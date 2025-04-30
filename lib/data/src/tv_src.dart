import 'package:dio/dio.dart';

import '../../utils/web/urls.dart';
import '../model/account_state_model.dart';
import '../model/credit_model.dart';
import '../model/review_model.dart';
import '../model/tv_show_model.dart';

abstract class ITvDataSrc {
  Future<List<TvShowModel>> getTopTvShows({required TvShowCacheSrc cache});
  Future<TvShowDetailModel> getLatestFeaturedEpisode({required TvShowCacheSrc cache});
  Future<TvShowDetailModel> getTvShowDetail({required int id});
  Future<List<String>> getTvShowImages({required int id});
  Future<List<SeasonDetailModel>> getSeasonsAndEpisodes({required TvShowDetailModel showData});
  Future<CreditModel> getTvShowCastAndCrew({required int id});
  Future<List<ReviewModel>> getTvShowReviews({required int id});
  Future<List<TvShowModel>> getSimilarTvShows({required int id, required TvShowCacheSrc cache});

  Future<AccountStateModel> getAccountState({required int id});
}

class TvRemoteSrc implements ITvDataSrc {
  final Dio httpClient;

  TvRemoteSrc(this.httpClient);

  @override
  Future<List<TvShowModel>> getTopTvShows({required TvShowCacheSrc cache}) async {
    final response = await httpClient.get(getTopShowsURL);

    final List<TvShowModel> topShows = TvShowListResponseModel.fromJson(response.data).shows;

    cache.updateCachedTvShows(topShows);

    return topShows;
  }

  @override
  Future<TvShowDetailModel> getLatestFeaturedEpisode({required TvShowCacheSrc cache}) async {
    // 1. get last episode to Air ID
    final responseId = await httpClient.get(getAiringTodayShowsURL);
    final initialResponseId = TvShowListResponseModel.fromJson(responseId.data);
    TvShowModel show = initialResponseId.shows[0];
    int id = show.id;

    // 2. get initial_response with id
    final responseDetail = await httpClient.get(getTvShowDetailsURL(id));
    final tvShowDetail = TvShowDetailModel.fromJson(responseDetail.data);

    return tvShowDetail;
  }

  @override
  Future<TvShowDetailModel> getTvShowDetail({required int id}) async {
    final response = await httpClient.get(getTvShowDetailsURL(id));
    return TvShowDetailModel.fromJson(response.data);
  }

  @override
  Future<List<String>> getTvShowImages({required int id}) async {
    final response = await httpClient.get(getTvShowImagesURL(id));
    final List<String> images = List.empty(growable: true);

    for (var backdrop in (response.data['backdrops'])) {
      images.add(backdrop['file_path']);
      if (images.length == 25) break;
    }

    return images;
  }

  @override
  Future<List<SeasonDetailModel>> getSeasonsAndEpisodes(
      {required TvShowDetailModel showData}) async {
    List<SeasonDetailModel> seasonsData = List.empty(growable: true);

    for (SeasonModel season in showData.seasons) {
      final response = await httpClient.get(
          getTvShowSeasonsAndEpisodes(seriesId: showData.id, seasonNumber: season.seasonNumber));
      seasonsData.add(SeasonDetailModel.fromJson(response.data));
    }

    return seasonsData.reversed.toList();
  }

  @override
  Future<CreditModel> getTvShowCastAndCrew({required int id}) async {
    final response = await httpClient.get(getTvShowCastAndCrewURL(id));
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
  Future<List<ReviewModel>> getTvShowReviews({required int id}) async {
    final response = await httpClient.get(getTvShowReviewsURL(id));
    final List<ReviewModel> reviews = [];

    for (var review in (response.data['results'])) {
      reviews.add(ReviewModel.fromJson(review));
    }

    return reviews;
  }

  @override
  Future<List<TvShowModel>> getSimilarTvShows(
      {required int id, required TvShowCacheSrc cache}) async {
    final response = await httpClient.get(getSimilarTvShowsURL(id));
    final List<TvShowModel> shows = [];

    for (var movie in (response.data['results'])) {
      shows.add(TvShowModel.fromJson(movie));
    }

    cache.updateCachedTvShows(shows);

    return shows;
  }

  @override
  Future<AccountStateModel> getAccountState({required int id}) async {
    final response = await httpClient.get(getTvShowAccountStateURL(id));
    return AccountStateModel.fromJson(response.data);
  }
}

class TvShowCacheSrc {
  final Map<int, TvShowModel> tvShowCache = {};

  void updateCachedTvShows(List<TvShowModel> newShows) {
    for (final newShow in newShows) {
      tvShowCache[newShow.id] = newShow;
    }
  }

  TvShowModel? getShowById(int showId) {
    return tvShowCache[showId];
  }
}
