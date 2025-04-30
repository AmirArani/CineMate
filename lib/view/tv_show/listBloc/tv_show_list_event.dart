part of 'tv_show_list_bloc.dart';

sealed class TvShowListEvent extends Equatable {
  const TvShowListEvent();

  @override
  List<Object> get props => [];
}

class TvShowListFetchEvent extends TvShowListEvent {
  final int page;

  const TvShowListFetchEvent({this.page = 1});

  @override
  List<Object> get props => [page];
}

class TvShowListAddTvShowEvent extends TvShowListEvent {
  final int listId;
  final String listName;
  final TvShowModel show;

  const TvShowListAddTvShowEvent(
      {required this.listId, required this.show, required this.listName});

  @override
  List<Object> get props => [listId, show, listName];
}

class TvShowListCreateEvent extends TvShowListEvent {
  final String name;
  final String description;
  final bool isPublic;

  const TvShowListCreateEvent({
    required this.name,
    required this.description,
    required this.isPublic,
  });

  @override
  List<Object> get props => [name, description, isPublic];
}
