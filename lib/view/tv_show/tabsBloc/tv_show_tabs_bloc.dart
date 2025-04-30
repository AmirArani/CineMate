import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/credit_model.dart';
import '../../../data/model/review_model.dart';
import '../../../data/model/tv_show_model.dart';
import '../../../data/repo/tv_repo.dart';

part 'tv_show_tabs_event.dart';
part 'tv_show_tabs_state.dart';

class TvShowTabsBloc extends Bloc<TvShowTabsEvent, TvShowTabsState> {
  TvShowTabsBloc()
      : super(const TvShowTabsState(
            id: -1,
            seasonsData: null,
            isLoadingSeasons: true,
            isSeasonsFailed: false,
            credits: null,
            isLoadingCredits: true,
            isCreditsFailed: false,
            reviews: null,
            isLoadingReviews: true,
            isReviewsFailed: false,
            similarTvShows: null,
            isLoadingSimilar: true,
            isSimilarFailed: false)) {
    on<TvShowTabsEvent>((event, emit) async {
      if (event is TvShowTabsReloadEvent) {
        emit(TvShowTabsState(
            id: event.id,
            seasonsData: null,
            isLoadingSeasons: true,
            isSeasonsFailed: false,
            credits: null,
            isLoadingCredits: true,
            isCreditsFailed: false,
            reviews: null,
            isLoadingReviews: true,
            isReviewsFailed: false,
            similarTvShows: null,
            isLoadingSimilar: true,
            isSimilarFailed: false));
      } else if (event is TvShowCreditsTabLoadEvent) {
        await _handleShowCreditsTabLoadEvent(emit, event);
      } else if (event is TvShowReviewsTabLoadEvent) {
        await _handleShowReviewsTabLoadEvent(emit, event);
      } else if (event is TvShowSimilarTabLoadEvent) {
        await _handleShowSimilarTabLoadEvent(emit, event);
      } else if (event is TvShowSeasonsAndEpisodesTabLoadEvent) {
        await _handleShowSeasonsAndEpisodesTabLoadEvent(emit, event);
      }
    });
  }
}

Future<void> _handleShowSeasonsAndEpisodesTabLoadEvent(
    Emitter emit, TvShowSeasonsAndEpisodesTabLoadEvent event) async {
  final TvShowTabsState state = event.state;

  if (state.seasonsData == null && event.showData != null) {
    try {
      emit(state.copyWith(id: event.id, isLoadingSeasons: true, isSeasonsFailed: false));
      final List<SeasonDetailModel> seasons =
          await tvShowRepository.getTvShowSeasonsAndEpisodes(showData: event.showData!);
      emit(state.copyWith(
          id: event.id,
          seasonsData: seasons.reversed.toList(),
          isLoadingSeasons: false,
          isSeasonsFailed: false));
    } catch (e) {
      emit(state.copyWith(id: event.id, isLoadingSeasons: false, isSeasonsFailed: true));
    }
  }
}

Future<void> _handleShowCreditsTabLoadEvent(Emitter emit, TvShowCreditsTabLoadEvent event) async {
  final TvShowTabsState state = event.state;

  if (state.credits == null) {
    try {
      emit(state.copyWith(id: event.id, isLoadingCredits: true, isCreditsFailed: false));
      final CreditModel credits = await tvShowRepository.getTvShowCastAndCrew(id: event.id);
      emit(state.copyWith(
          id: event.id, credits: credits, isLoadingCredits: false, isCreditsFailed: false));
    } catch (e) {
      emit(state.copyWith(id: event.id, isLoadingCredits: false, isCreditsFailed: true));
    }
  }
}

Future<void> _handleShowReviewsTabLoadEvent(Emitter emit, TvShowReviewsTabLoadEvent event) async {
  final TvShowTabsState state = event.state;

  if (state.reviews == null) {
    try {
      emit(state.copyWith(id: event.id, isLoadingReviews: true, isReviewsFailed: false));
      final List<ReviewModel> reviews = await tvShowRepository.getTvShowReviews(id: event.id);
      emit(state.copyWith(
          id: event.id, reviews: reviews, isLoadingReviews: false, isReviewsFailed: false));
    } catch (e) {
      emit(state.copyWith(id: event.id, isLoadingReviews: false, isReviewsFailed: true));
    }
  }
}

Future<void> _handleShowSimilarTabLoadEvent(Emitter emit, TvShowSimilarTabLoadEvent event) async {
  final TvShowTabsState state = event.state;

  if (state.similarTvShows == null) {
    try {
      emit(state.copyWith(id: event.id, isLoadingSimilar: true, isSimilarFailed: false));
      final List<TvShowModel> similarMovies =
          await tvShowRepository.getSimilarTvShows(id: event.id);
      emit(state.copyWith(
          id: event.id,
          similarTvShows: similarMovies,
          isLoadingSimilar: false,
          isSimilarFailed: false));
    } catch (e) {
      emit(state.copyWith(id: event.id, isLoadingSimilar: false, isSimilarFailed: true));
    }
  }
}
