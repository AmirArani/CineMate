import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/movie_model.dart';
import '../../../../../data/repo/account_repo.dart';
import '../../../../../utils/helpers/list_preferences.dart';

part 'favorite_movies_event.dart';
part 'favorite_movies_state.dart';

class FavoriteMoviesBloc extends Bloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  final AccountRepository accountRepo;
  final PagingController<int, MovieModel> pagingController = PagingController(firstPageKey: 1);

  FavoriteMoviesBloc({
    required this.accountRepo,
    required ListPreferences initialPreferences,
  }) : super(FavoriteMoviesInitial(initialPreferences)) {
    pagingController.addPageRequestListener((pageKey) {
      add(FavoriteMoviesPageRequested(pageKey));
    });

    on<FavoriteMoviesPreferencesChanged>(_onPreferencesChanged);
    on<FavoriteMoviesPageRequested>(_onPageRequested);
  }

  Future<void> _onPreferencesChanged(
    FavoriteMoviesPreferencesChanged event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    // Only update if preferences actually changed
    if (state.preferences != event.preferences) {
      emit(FavoriteMoviesLoadInProgress(event.preferences));
      pagingController.refresh();
    }
  }

  Future<void> _onPageRequested(
    FavoriteMoviesPageRequested event,
    Emitter<FavoriteMoviesState> emit,
  ) async {
    try {
      final currentPrefs = state.preferences;
      final nextPage = await accountRepo.getFavoriteMovies(
        page: event.page,
        sortMethod: currentPrefs.sortMethod,
      );

      final isLastPage = nextPage.page >= nextPage.totalPages;
      final nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.movies);
      } else {
        pagingController.appendPage(nextPage.movies, nextPageKey);
      }

      emit(FavoriteMoviesLoadSuccess(currentPrefs));
    } catch (e) {
      pagingController.error = e;
      emit(FavoriteMoviesLoadFailure(state.preferences, e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
