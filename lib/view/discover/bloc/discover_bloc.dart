import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/model/discover_params_model.dart';
import '../../../data/model/movie_model.dart';
import '../../../data/model/tv_show_model.dart';
import '../../../data/repo/discover_repo.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final PagingController<int, MovieModel> moviePagingController = PagingController(firstPageKey: 1);
  final PagingController<int, TvShowModel> tvShowPagingController =
      PagingController(firstPageKey: 1);

  final Map<String, String> keywordNames = {};

  DiscoverMovieParams _movieParams = const DiscoverMovieParams(
    sortBy: DiscoverSortOptions.popularityDesc,
  );
  DiscoverTvParams _tvParams = const DiscoverTvParams(
    sortBy: DiscoverSortOptions.popularityDesc,
  );

  DiscoverMovieParams get movieParams => _movieParams;
  DiscoverTvParams get tvParams => _tvParams;

  DiscoverBloc({
    DiscoverMovieParams? initialMovieParams,
    DiscoverTvParams? initialTvParams,
    Map<String, String>? initialKeywordNames,
  }) : super(const DiscoverState(selectedTabIndex: 0)) {
    // Apply initial params if provided
    if (initialMovieParams != null) {
      _movieParams = initialMovieParams;
    }
    if (initialTvParams != null) {
      _tvParams = initialTvParams;
    }
    if (initialKeywordNames != null) {
      keywordNames.addAll(initialKeywordNames);
    }

    moviePagingController.addPageRequestListener((pageKey) {
      add(DiscoverMoviePageRequested(pageKey));
    });

    tvShowPagingController.addPageRequestListener((pageKey) {
      add(DiscoverTvShowPageRequested(pageKey));
    });

    on<DiscoverTabSelected>(_onTabSelected);
    on<DiscoverMoviePageRequested>(_onMoviePageRequested);
    on<DiscoverTvShowPageRequested>(_onTvShowPageRequested);
    on<DiscoverMovieParamsChanged>(_onMovieParamsChanged);
    on<DiscoverTvParamsChanged>(_onTvParamsChanged);

    // Refresh with initial params
    moviePagingController.refresh();
    tvShowPagingController.refresh();
  }

  void _onTabSelected(
    DiscoverTabSelected event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  Future<void> _onMoviePageRequested(
    DiscoverMoviePageRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    try {
      print('Requesting movies page ${event.page} with params: ${_movieParams.toJson()}');
      final results = await discoverRepo.discoverMovies(
        params: _movieParams,
        page: event.page,
      );

      final isLastPage = results.page >= results.totalPages;
      if (isLastPage) {
        moviePagingController.appendLastPage(results.movies);
      } else {
        moviePagingController.appendPage(results.movies, event.page + 1);
      }
    } catch (e) {
      print('Error loading movies: $e');
      moviePagingController.error = e;
    }
  }

  Future<void> _onTvShowPageRequested(
    DiscoverTvShowPageRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    try {
      print('Requesting TV shows page ${event.page} with params: ${_tvParams.toJson()}');
      final results = await discoverRepo.discoverTvShows(
        params: _tvParams,
        page: event.page,
      );

      final isLastPage = results.page >= results.totalPages;
      if (isLastPage) {
        tvShowPagingController.appendLastPage(results.shows);
      } else {
        tvShowPagingController.appendPage(results.shows, event.page + 1);
      }
    } catch (e) {
      print('Error loading TV shows: $e');
      tvShowPagingController.error = e;
    }
  }

  void _onMovieParamsChanged(
    DiscoverMovieParamsChanged event,
    Emitter<DiscoverState> emit,
  ) {
    print('Movie params changed: ${event.params.toJson()}');
    _movieParams = event.params;

    // Clear keyword names if keywords are cleared
    if (event.params.withKeywords == null) {
      keywordNames.clear();
    }

    emit(state.copyWith(
      movieParams: event.params,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    ));
    moviePagingController.refresh();
  }

  void _onTvParamsChanged(
    DiscoverTvParamsChanged event,
    Emitter<DiscoverState> emit,
  ) {
    print('TV show params changed: ${event.params.toJson()}');
    _tvParams = event.params;

    // Clear keyword names if keywords are cleared
    if (event.params.withKeywords == null) {
      keywordNames.clear();
    }

    emit(state.copyWith(
      tvParams: event.params,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    ));
    tvShowPagingController.refresh();
  }

  @override
  Future<void> close() {
    moviePagingController.dispose();
    tvShowPagingController.dispose();
    return super.close();
  }
}
