import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/rating_model.dart';
import '../../../../../data/repo/account_repo.dart';
import '../../../../../utils/helpers/list_preferences.dart';

part 'rating_movies_event.dart';
part 'rating_movies_state.dart';

class RatingMoviesBloc extends Bloc<RatingMoviesEvent, RatingMoviesState> {
  final AccountRepository accountRepo;
  final PagingController<int, RatedMovieModel> pagingController = PagingController(firstPageKey: 1);

  RatingMoviesBloc({
    required this.accountRepo,
    required ListPreferences initialPreferences,
  }) : super(RatingMoviesInitial(initialPreferences)) {
    pagingController.addPageRequestListener((pageKey) {
      add(RatingMoviesPageRequested(pageKey));
    });

    on<RatingMoviesPreferencesChanged>(_onPreferencesChanged);
    on<RatingMoviesPageRequested>(_onPageRequested);
  }

  Future<void> _onPreferencesChanged(
    RatingMoviesPreferencesChanged event,
    Emitter<RatingMoviesState> emit,
  ) async {
    // Only update if preferences actually changed
    if (state.preferences != event.preferences) {
      emit(RatingMoviesLoadInProgress(event.preferences));
      pagingController.refresh();
    }
  }

  Future<void> _onPageRequested(
    RatingMoviesPageRequested event,
    Emitter<RatingMoviesState> emit,
  ) async {
    try {
      final currentPrefs = state.preferences;
      final nextPage = await accountRepo.getRatedMovies(
        page: event.page,
        sortMethod: currentPrefs.sortMethod,
      );

      final isLastPage = nextPage.page >= nextPage.totalPages;
      final nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.ratedMovies);
      } else {
        pagingController.appendPage(nextPage.ratedMovies, nextPageKey);
      }

      emit(RatingMoviesLoadSuccess(currentPrefs));
    } catch (e) {
      pagingController.error = e;
      emit(RatingMoviesLoadFailure(state.preferences, e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
