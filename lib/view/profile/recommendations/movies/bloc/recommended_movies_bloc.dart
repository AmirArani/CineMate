import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/movie_model.dart';
import '../../../../../data/repo/account_repo.dart';

part 'recommended_movies_event.dart';
part 'recommended_movies_state.dart';

class RecommendedMoviesBloc extends Bloc<RecommendedMoviesEvent, RecommendedMoviesState> {
  final AccountRepository accountRepo;
  final PagingController<int, MovieModel> pagingController = PagingController(firstPageKey: 1);

  RecommendedMoviesBloc({
    required this.accountRepo,
  }) : super(RecommendedMoviesInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      add(RecommendedMoviesPageRequested(pageKey));
    });

    on<RecommendedMoviesPageRequested>(_onPageRequested);
  }

  Future<void> _onPageRequested(
    RecommendedMoviesPageRequested event,
    Emitter<RecommendedMoviesState> emit,
  ) async {
    try {
      final nextPage = await accountRepo.getRecommendedMovies(page: event.page);

      final isLastPage = nextPage.page >= nextPage.totalPages;
      final nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.movies);
      } else {
        pagingController.appendPage(nextPage.movies, nextPageKey);
      }

      emit(RecommendedMoviesLoadSuccess());
    } catch (e) {
      pagingController.error = e;
      emit(RecommendedMoviesLoadFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
