import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/tv_show_model.dart';
import '../../../../../data/repo/account_repo.dart';

part 'recommended_shows_event.dart';
part 'recommended_shows_state.dart';

class RecommendedShowsBloc extends Bloc<RecommendedShowsEvent, RecommendedShowsState> {
  final AccountRepository accountRepo;
  final PagingController<int, TvShowModel> pagingController = PagingController(firstPageKey: 1);

  RecommendedShowsBloc({
    required this.accountRepo,
  }) : super(RecommendedShowsInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      add(RecommendedShowsPageRequested(pageKey));
    });

    on<RecommendedShowsPageRequested>(_onPageRequested);
  }

  Future<void> _onPageRequested(
    RecommendedShowsPageRequested event,
    Emitter<RecommendedShowsState> emit,
  ) async {
    try {
      final nextPage = await accountRepo.getRecommendedTvShows(page: event.page);

      final isLastPage = nextPage.page >= nextPage.totalPages;
      final nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.shows);
      } else {
        pagingController.appendPage(nextPage.shows, nextPageKey);
      }

      emit(RecommendedShowsLoadSuccess());
    } catch (e) {
      pagingController.error = e;
      emit(RecommendedShowsLoadFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
