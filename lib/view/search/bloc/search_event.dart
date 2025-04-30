part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SearchPageRequested extends SearchEvent {
  final int page;

  const SearchPageRequested(this.page);

  @override
  List<Object> get props => [page];
}

class SearchTabSelected extends SearchEvent {
  final int index;

  const SearchTabSelected(this.index);

  @override
  List<Object> get props => [index];
}
