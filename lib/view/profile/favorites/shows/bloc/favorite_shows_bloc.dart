import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/tv_show_model.dart';
import '../../../../../data/repo/account_repo.dart';
import '../../../../../utils/helpers/list_preferences.dart';

part 'favorite_shows_event.dart';
part 'favorite_shows_state.dart';

class FavoriteShowsBloc extends Bloc<FavoriteShowsEvent, FavoriteShowsState> {
  final AccountRepository accountRepo;
  final PagingController<int, TvShowModel> pagingController = PagingController(firstPageKey: 1);

  FavoriteShowsBloc({
    required this.accountRepo,
    required ListPreferences initialPreferences,
  }) : super(FavoriteShowsInitial(initialPreferences)) {
    pagingController.addPageRequestListener((pageKey) {
      add(FavoriteShowsPageRequested(pageKey));
    });

    on<FavoriteShowsPreferencesChanged>(_onPreferencesChanged);
    on<FavoriteShowsPageRequested>(_onPageRequested);
  }

  Future<void> _onPreferencesChanged(
    FavoriteShowsPreferencesChanged event,
    Emitter<FavoriteShowsState> emit,
  ) async {
    // Only update if preferences actually changed
    if (state.preferences != event.preferences) {
      emit(FavoriteShowsLoadInProgress(event.preferences));
      pagingController.refresh();
    }
  }

  Future<void> _onPageRequested(
    FavoriteShowsPageRequested event,
    Emitter<FavoriteShowsState> emit,
  ) async {
    try {
      final currentPrefs = state.preferences;
      final nextPage = await accountRepo.getFavoriteShows(
        page: event.page,
        sortMethod: currentPrefs.sortMethod,
      );

      final isLastPage = nextPage.page >= nextPage.totalPages;
      final nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.shows);
      } else {
        pagingController.appendPage(nextPage.shows, nextPageKey);
      }

      emit(FavoriteShowsLoadSuccess(currentPrefs));
    } catch (e) {
      pagingController.error = e;
      emit(FavoriteShowsLoadFailure(state.preferences, e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
