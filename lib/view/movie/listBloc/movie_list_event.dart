part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class MovieListFetchEvent extends MovieListEvent {
  final int page;

  const MovieListFetchEvent({this.page = 1});

  @override
  List<Object> get props => [page];
}

class MovieListAddMovieEvent extends MovieListEvent {
  final int listId;
  final String listName;
  final MovieModel movie;

  const MovieListAddMovieEvent({required this.listId, required this.movie, required this.listName});

  @override
  List<Object> get props => [listId, movie, listName];
}

class MovieListCreateEvent extends MovieListEvent {
  final String name;
  final String description;
  final bool isPublic;

  const MovieListCreateEvent({
    required this.name,
    required this.description,
    required this.isPublic,
  });

  @override
  List<Object> get props => [name, description, isPublic];
}
