part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final int selectedTabIndex;
  final Map<int, int> resultCounts;
  final bool isLoadingKeywords;
  final bool isLoadingCompanies;

  const SearchState({
    this.selectedTabIndex = 0,
    this.resultCounts = const {},
    this.isLoadingKeywords = false,
    this.isLoadingCompanies = false,
  });

  SearchState copyWith({
    int? selectedTabIndex,
    Map<int, int>? resultCounts,
    bool? isLoadingKeywords,
    bool? isLoadingCompanies,
  }) {
    if (this is SearchInitial) {
      return SearchInitial(
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        resultCounts: resultCounts ?? this.resultCounts,
        isLoadingKeywords: isLoadingKeywords ?? this.isLoadingKeywords,
        isLoadingCompanies: isLoadingCompanies ?? this.isLoadingCompanies,
      );
    } else if (this is SearchLoadInProgress) {
      return SearchLoadInProgress(
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        resultCounts: resultCounts ?? this.resultCounts,
        isLoadingKeywords: isLoadingKeywords ?? this.isLoadingKeywords,
        isLoadingCompanies: isLoadingCompanies ?? this.isLoadingCompanies,
      );
    } else if (this is SearchLoadSuccess) {
      return SearchLoadSuccess(
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        resultCounts: resultCounts ?? this.resultCounts,
        isLoadingKeywords: isLoadingKeywords ?? this.isLoadingKeywords,
        isLoadingCompanies: isLoadingCompanies ?? this.isLoadingCompanies,
      );
    } else if (this is SearchLoadFailure) {
      return SearchLoadFailure(
        (this as SearchLoadFailure).error,
        selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
        resultCounts: resultCounts ?? this.resultCounts,
        isLoadingKeywords: isLoadingKeywords ?? this.isLoadingKeywords,
        isLoadingCompanies: isLoadingCompanies ?? this.isLoadingCompanies,
      );
    }
    return this;
  }

  @override
  List<Object> get props => [selectedTabIndex, resultCounts, isLoadingKeywords, isLoadingCompanies];
}

class SearchInitial extends SearchState {
  const SearchInitial({
    super.selectedTabIndex = 0,
    super.resultCounts = const {},
    super.isLoadingKeywords = false,
    super.isLoadingCompanies = false,
  });
}

class SearchLoadInProgress extends SearchState {
  const SearchLoadInProgress({
    super.selectedTabIndex = 0,
    super.resultCounts = const {},
    super.isLoadingKeywords = false,
    super.isLoadingCompanies = false,
  });
}

class SearchLoadSuccess extends SearchState {
  const SearchLoadSuccess({
    super.selectedTabIndex = 0,
    super.resultCounts = const {},
    super.isLoadingKeywords = false,
    super.isLoadingCompanies = false,
  });
}

class SearchLoadFailure extends SearchState {
  final String error;

  const SearchLoadFailure(
    this.error, {
    super.selectedTabIndex = 0,
    super.resultCounts = const {},
    super.isLoadingKeywords = false,
    super.isLoadingCompanies = false,
  });

  @override
  List<Object> get props => [...super.props, error];
}
