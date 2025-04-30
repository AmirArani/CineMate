import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/movie_model.dart';
import '../../../../../data/repo/account_repo.dart';
import '../../../../../utils/helpers/list_preferences.dart';

part 'watch_list_movie_event.dart';
part 'watch_list_movie_state.dart';

class WatchListMoviesBloc extends Bloc<WatchListMoviesEvent, WatchListMoviesState> {
  final AccountRepository accountRepo;
  final PagingController<int, MovieModel> pagingController = PagingController(firstPageKey: 1);

  WatchListMoviesBloc({
    required this.accountRepo,
    required ListPreferences initialPreferences,
  }) : super(WatchListMoviesInitial(initialPreferences)) {
    pagingController.addPageRequestListener((pageKey) {
      add(WatchListMoviesPageRequested(pageKey));
    });

    on<WatchListMoviesPreferencesChanged>(_onPreferencesChanged);
    on<WatchListMoviesPageRequested>(_onPageRequested);
  }

  Future<void> _onPreferencesChanged(
    WatchListMoviesPreferencesChanged event,
    Emitter<WatchListMoviesState> emit,
  ) async {
    // Only update if preferences actually changed
    if (state.preferences != event.preferences) {
      emit(WatchListMoviesLoadInProgress(event.preferences));
      pagingController.refresh();
    }
  }

  Future<void> _onPageRequested(
    WatchListMoviesPageRequested event,
    Emitter<WatchListMoviesState> emit,
  ) async {
    try {
      final currentPrefs = state.preferences;
      final nextPage = await accountRepo.getWatchListMovies(
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

      emit(WatchListMoviesLoadSuccess(currentPrefs));
    } catch (e) {
      pagingController.error = e;
      emit(WatchListMoviesLoadFailure(state.preferences, e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
