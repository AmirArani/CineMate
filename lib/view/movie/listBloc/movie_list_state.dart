part of 'movie_list_bloc.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListLoaded extends MovieListState {}

class MovieListAdding extends MovieListState {}

class MovieListAddSuccess extends MovieListState {
  final String listName;

  const MovieListAddSuccess({required this.listName});

  @override
  List<Object> get props => [listName];
}

class MovieListError extends MovieListState {
  final String error;

  const MovieListError({required this.error});

  @override
  List<Object> get props => [error];
}

class MovieListCreating extends MovieListState {}

class MovieListCreateSuccess extends MovieListState {
  final String listName;

  const MovieListCreateSuccess({required this.listName});

  @override
  List<Object> get props => [listName];
}
