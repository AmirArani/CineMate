import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/model/company_model.dart';
import '../../../data/model/keyword_model.dart';
import '../../../data/model/media_model.dart';
import '../../../data/model/movie_model.dart';
import '../../../data/model/person_model.dart';
import '../../../data/model/tv_show_model.dart';
import '../../../data/repo/search_repo.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Map<int, PagingController> _pagingControllers = {
    0: PagingController<int, MediaModel>(firstPageKey: 1),
    1: PagingController<int, MovieModel>(firstPageKey: 1),
    2: PagingController<int, TvShowModel>(firstPageKey: 1),
    3: PagingController<int, PersonModel>(firstPageKey: 1),
    4: PagingController<int, KeywordModel>(firstPageKey: 1),
    5: PagingController<int, CompanyModel>(firstPageKey: 1),
  };

  PagingController getController(int index) => _pagingControllers[index]!;
  Timer? _debounceTimer;
  String _lastQuery = '';
  Map<int, int> _resultCounts = {};
  bool _isFirstSearch = true;
  final Set<int> _loadedTabs = {};

  SearchBloc() : super(const SearchInitial()) {
    for (var controller in _pagingControllers.values) {
      controller.addPageRequestListener((pageKey) {
        if (_lastQuery.isNotEmpty) {
          add(SearchPageRequested(pageKey));
        }
      });
    }

    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchPageRequested>(_onSearchPageRequested);
    on<SearchTabSelected>(_onSearchTabSelected);
  }

  Future<void> _onSearchTabSelected(
    SearchTabSelected event,
    Emitter<SearchState> emit,
  ) async {
    emit(state is SearchLoadSuccess
        ? SearchLoadSuccess(
            selectedTabIndex: event.index,
            resultCounts: _resultCounts,
            isLoadingKeywords: state.isLoadingKeywords,
            isLoadingCompanies: state.isLoadingCompanies,
          )
        : SearchInitial(selectedTabIndex: event.index));

    // Only load data if this tab hasn't been loaded before and we have a query
    if (_lastQuery.isNotEmpty && !_loadedTabs.contains(event.index)) {
      _loadedTabs.add(event.index);
      getController(event.index).refresh();
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      _lastQuery = '';
      _resultCounts.clear();
      _loadedTabs.clear();
      for (var controller in _pagingControllers.values) {
        controller.refresh();
      }
      emit(SearchInitial(selectedTabIndex: state.selectedTabIndex));
      return;
    }

    // Start new timer
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      if (query != _lastQuery) {
        _lastQuery = query;
        _isFirstSearch = true;
        _loadedTabs.clear();
        for (var controller in _pagingControllers.values) {
          controller.refresh();
        }
        add(SearchPageRequested(1));
      }
    });
  }

  Future<void> _onSearchPageRequested(
    SearchPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(SearchLoadInProgress(
        selectedTabIndex: state.selectedTabIndex,
        resultCounts: _resultCounts,
        isLoadingKeywords: state.isLoadingKeywords,
        isLoadingCompanies: state.isLoadingCompanies,
      ));

      if (_isFirstSearch) {
        // For the first search, call all APIs sequentially
        final results = await Future.wait([
          searchRepo.search(query: _lastQuery, page: event.page),
          searchRepo.searchMovies(query: _lastQuery, page: event.page),
          searchRepo.searchShows(query: _lastQuery, page: event.page),
          searchRepo.searchPersons(query: _lastQuery, page: event.page),
          searchRepo.searchKeywords(query: _lastQuery, page: event.page),
          searchRepo.searchCompanies(query: _lastQuery, page: event.page),
        ]);

        final allResults = results[0] as MediaListResponseModel;
        final movieResults = results[1] as MovieListResponseModel;
        final showResults = results[2] as TvShowListResponseModel;
        final personResults = results[3] as PersonListResponseModel;
        final keywordResults = results[4] as KeywordListResponseModel;
        final companyResults = results[5] as CompanyListResponseModel;

        _resultCounts = {
          0: allResults.totalResults,
          1: movieResults.totalResults,
          2: showResults.totalResults,
          3: personResults.totalResults,
          4: keywordResults.totalResults,
          5: companyResults.totalResults,
        };

        _isFirstSearch = false;
        // Mark all tabs as loaded since we have data for all of them
        _loadedTabs.addAll([0, 1, 2, 3, 4, 5]);

        // Update all paging controllers with their respective results
        _updatePagingController(
            0, allResults.results, allResults.page, allResults.totalPages, event.page);
        _updatePagingController(
            1, movieResults.movies, movieResults.page, movieResults.totalPages, event.page);
        _updatePagingController(
            2, showResults.shows, showResults.page, showResults.totalPages, event.page);
        _updatePagingController(
            3, personResults.personList, personResults.page, personResults.totalPages, event.page);
        _updatePagingController(
            4, keywordResults.keywords, keywordResults.page, keywordResults.totalPages, event.page);
        _updatePagingController(5, companyResults.companies, companyResults.page,
            companyResults.totalPages, event.page);
      } else {
        // For subsequent searches, only call the API for the selected tab
        final results = await _getTabResults(state.selectedTabIndex, event.page);
        _updatePagingControllerFromResults(state.selectedTabIndex, results, event.page);
        _loadedTabs.add(state.selectedTabIndex);
      }

      emit(SearchLoadSuccess(
        selectedTabIndex: state.selectedTabIndex,
        resultCounts: _resultCounts,
        isLoadingKeywords: false,
        isLoadingCompanies: false,
      ));
    } catch (e) {
      getController(state.selectedTabIndex).error = e;
      emit(SearchLoadFailure(
        e.toString(),
        selectedTabIndex: state.selectedTabIndex,
        resultCounts: _resultCounts,
      ));
    }
  }

  void _updatePagingController(
      int tabIndex, List items, int page, int totalPages, int currentPage) {
    final controller = getController(tabIndex);
    final isLastPage = page >= totalPages;
    final nextPageKey = isLastPage ? null : currentPage + 1;

    if (isLastPage) {
      controller.appendLastPage(items);
    } else {
      controller.appendPage(items, nextPageKey);
    }
  }

  void _updatePagingControllerFromResults(int tabIndex, dynamic results, int currentPage) {
    switch (tabIndex) {
      case 0:
        final typedResults = results as MediaListResponseModel;
        _updatePagingController(tabIndex, typedResults.results, typedResults.page,
            typedResults.totalPages, currentPage);
        break;
      case 1:
        final typedResults = results as MovieListResponseModel;
        _updatePagingController(
            tabIndex, typedResults.movies, typedResults.page, typedResults.totalPages, currentPage);
        break;
      case 2:
        final typedResults = results as TvShowListResponseModel;
        _updatePagingController(
            tabIndex, typedResults.shows, typedResults.page, typedResults.totalPages, currentPage);
        break;
      case 3:
        final typedResults = results as PersonListResponseModel;
        _updatePagingController(tabIndex, typedResults.personList, typedResults.page,
            typedResults.totalPages, currentPage);
        break;
      case 4:
        final typedResults = results as KeywordListResponseModel;
        _updatePagingController(tabIndex, typedResults.keywords, typedResults.page,
            typedResults.totalPages, currentPage);
        break;
      case 5:
        final typedResults = results as CompanyListResponseModel;
        _updatePagingController(tabIndex, typedResults.companies, typedResults.page,
            typedResults.totalPages, currentPage);
        break;
    }
  }

  Future<dynamic> _getTabResults(int tabIndex, int page) async {
    switch (tabIndex) {
      case 0:
        return searchRepo.search(query: _lastQuery, page: page);
      case 1:
        return searchRepo.searchMovies(query: _lastQuery, page: page);
      case 2:
        return searchRepo.searchShows(query: _lastQuery, page: page);
      case 3:
        return searchRepo.searchPersons(query: _lastQuery, page: page);
      case 4:
        return searchRepo.searchKeywords(query: _lastQuery, page: page);
      case 5:
        return searchRepo.searchCompanies(query: _lastQuery, page: page);
      default:
        return searchRepo.search(query: _lastQuery, page: page);
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    for (var controller in _pagingControllers.values) {
      controller.dispose();
    }
    return super.close();
  }
}
