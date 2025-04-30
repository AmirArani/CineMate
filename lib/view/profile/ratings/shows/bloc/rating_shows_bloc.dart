import 'package:bloc/bloc.dart';
import 'package:cinemate/data/model/rating_model.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/repo/account_repo.dart';
import '../../../../../utils/helpers/list_preferences.dart';

part 'rating_shows_event.dart';
part 'rating_shows_state.dart';

class RatingShowsBloc extends Bloc<RatingShowsEvent, RatingShowsState> {
  final AccountRepository accountRepo;
  final PagingController<int, RatedShowModel> pagingController = PagingController(firstPageKey: 1);

  RatingShowsBloc({
    required this.accountRepo,
    required ListPreferences initialPreferences,
  }) : super(RatingShowsInitial(initialPreferences)) {
    pagingController.addPageRequestListener((pageKey) {
      add(RatingShowsPageRequested(pageKey));
    });

    on<RatingShowsPreferencesChanged>(_onPreferencesChanged);
    on<RatingShowsPageRequested>(_onPageRequested);
  }

  Future<void> _onPreferencesChanged(
    RatingShowsPreferencesChanged event,
    Emitter<RatingShowsState> emit,
  ) async {
    // Only update if preferences actually changed
    if (state.preferences != event.preferences) {
      emit(RatingShowsLoadInProgress(event.preferences));
      pagingController.refresh();
    }
  }

  Future<void> _onPageRequested(
    RatingShowsPageRequested event,
    Emitter<RatingShowsState> emit,
  ) async {
    try {
      final currentPrefs = state.preferences;
      final nextPage = await accountRepo.getRatedShows(
        page: event.page,
        sortMethod: currentPrefs.sortMethod,
      );

      final isLastPage = nextPage.page >= nextPage.totalPages;
      final nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.ratedShows);
      } else {
        pagingController.appendPage(nextPage.ratedShows, nextPageKey);
      }

      emit(RatingShowsLoadSuccess(currentPrefs));
    } catch (e) {
      pagingController.error = e;
      emit(RatingShowsLoadFailure(state.preferences, e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
