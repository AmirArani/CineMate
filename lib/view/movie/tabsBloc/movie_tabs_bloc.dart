import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/credit_model.dart';
import '../../../data/model/movie_model.dart';
import '../../../data/model/review_model.dart';
import '../../../data/repo/movie_repo.dart';

part 'movie_tabs_event.dart';
part 'movie_tabs_state.dart';

class MovieTabsBloc extends Bloc<MovieTabsEvent, MovieTabsState> {
  MovieTabsBloc()
      : super(const MovieTabsState(
            id: -1,
            credits: null,
            isLoadingCredits: true,
            isCreditsFailed: false,
            reviews: null,
            isLoadingReviews: true,
            isReviewsFailed: false,
            similarMovies: null,
            isLoadingSimilar: true,
            isSimilarFailed: false)) {
    on<MovieTabsEvent>((event, emit) async {
      if (event is MovieTabsReloadEvent) {
        emit(MovieTabsState(
            id: event.id,
            credits: null,
            isLoadingCredits: true,
            isCreditsFailed: false,
            reviews: null,
            isLoadingReviews: true,
            isReviewsFailed: false,
            similarMovies: null,
            isLoadingSimilar: true,
            isSimilarFailed: false));
      } else if (event is MovieCreditsTabLoadEvent) {
        await _handleMovieCreditsTabLoadEvent(emit, event);
      } else if (event is MovieReviewsTabLoadEvent) {
        await _handleMovieReviewsTabLoadEvent(emit, event);
      } else if (event is MovieSimilarTabLoadEvent) {
        await _handleMovieSimilarTabLoadEvent(emit, event);
      }
    });
  }
}

Future<void> _handleMovieCreditsTabLoadEvent(Emitter emit, MovieCreditsTabLoadEvent event) async {
  final MovieTabsState state = event.state;

  if (state.credits == null) {
    try {
      emit(state.copyWith(id: event.id, isLoadingCredits: true, isCreditsFailed: false));
      final CreditModel credits = await movieRepository.getMovieCastAndCrew(id: event.id);
      emit(state.copyWith(
          id: event.id, credits: credits, isLoadingCredits: false, isCreditsFailed: false));
    } catch (e) {
      emit(state.copyWith(id: event.id, isLoadingCredits: false, isCreditsFailed: true));
    }
  }
}

Future<void> _handleMovieReviewsTabLoadEvent(Emitter emit, MovieReviewsTabLoadEvent event) async {
  final MovieTabsState state = event.state;

  if (state.reviews == null) {
    try {
      emit(state.copyWith(id: event.id, isLoadingReviews: true, isReviewsFailed: false));
      final List<ReviewModel> reviews = await movieRepository.getMovieReviews(id: event.id);
      emit(state.copyWith(
          id: event.id, reviews: reviews, isLoadingReviews: false, isReviewsFailed: false));
    } catch (e) {
      emit(state.copyWith(id: event.id, isLoadingReviews: false, isReviewsFailed: true));
    }
  }
}

Future<void> _handleMovieSimilarTabLoadEvent(Emitter emit, MovieSimilarTabLoadEvent event) async {
  final MovieTabsState state = event.state;

  if (state.similarMovies == null) {
    try {
      emit(state.copyWith(id: event.id, isLoadingSimilar: true, isSimilarFailed: false));
      final List<MovieModel> similarMovies = await movieRepository.getSimilarMovies(id: event.id);
      emit(state.copyWith(
          id: event.id,
          similarMovies: similarMovies,
          isLoadingSimilar: false,
          isSimilarFailed: false));
    } catch (e) {
      emit(state.copyWith(id: event.id, isLoadingSimilar: false, isSimilarFailed: true));
    }
  }
}
