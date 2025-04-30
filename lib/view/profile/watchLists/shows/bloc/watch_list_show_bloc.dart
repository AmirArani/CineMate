import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/tv_show_model.dart';
import '../../../../../data/repo/account_repo.dart';
import '../../../../../utils/helpers/list_preferences.dart';

part 'watch_list_show_event.dart';
part 'watch_list_show_state.dart';

class WatchListShowsBloc extends Bloc<WatchListShowEvent, WatchListShowState> {
  final AccountRepository accountRepo;
  final PagingController<int, TvShowModel> pagingController = PagingController(firstPageKey: 1);

  WatchListShowsBloc({
    required this.accountRepo,
    required ListPreferences initialPreferences,
  }) : super(WatchListShowsInitial(initialPreferences)) {
    pagingController.addPageRequestListener((pageKey) {
      add(WatchListShowsPageRequested(pageKey));
    });

    on<WatchListShowsPreferencesChanged>(_onPreferencesChanged);
    on<WatchListShowsPageRequested>(_onPageRequested);
  }

  Future<void> _onPreferencesChanged(
    WatchListShowsPreferencesChanged event,
    Emitter<WatchListShowState> emit,
  ) async {
    // Only update if preferences actually changed
    if (state.preferences != event.preferences) {
      emit(WatchListShowsLoadInProgress(event.preferences));
      pagingController.refresh();
    }
  }

  Future<void> _onPageRequested(
    WatchListShowsPageRequested event,
    Emitter<WatchListShowState> emit,
  ) async {
    try {
      final currentPrefs = state.preferences;
      final nextPage = await accountRepo.getWatchListShows(
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

      emit(WatchListShowsLoadSuccess(currentPrefs));
    } catch (e) {
      pagingController.error = e;
      emit(WatchListShowsLoadFailure(state.preferences, e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
