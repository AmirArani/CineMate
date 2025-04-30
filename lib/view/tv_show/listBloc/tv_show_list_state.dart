part of 'tv_show_list_bloc.dart';

sealed class TvShowListState extends Equatable {
  const TvShowListState();

  @override
  List<Object> get props => [];
}

class TvShowListInitial extends TvShowListState {}

class TvShowListLoading extends TvShowListState {}

class TvShowListLoaded extends TvShowListState {}

class TvShowListAdding extends TvShowListState {}

class TvShowListAddSuccess extends TvShowListState {
  final String listName;

  const TvShowListAddSuccess({required this.listName});

  @override
  List<Object> get props => [listName];
}

class TvShowListError extends TvShowListState {
  final String error;

  const TvShowListError({required this.error});

  @override
  List<Object> get props => [error];
}

class TvShowListCreating extends TvShowListState {}

class TvShowListCreateSuccess extends TvShowListState {
  final String listName;

  const TvShowListCreateSuccess({required this.listName});

  @override
  List<Object> get props => [listName];
}
