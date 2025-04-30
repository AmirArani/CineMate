part of 'movie_tabs_bloc.dart';

sealed class MovieTabsEvent extends Equatable {
  const MovieTabsEvent();
}

final class MovieTabsReloadEvent extends MovieTabsEvent {
  final int id;

  const MovieTabsReloadEvent({required this.id});

  @override
  List<Object> get props => [id];
}

final class MovieCreditsTabLoadEvent extends MovieTabsEvent {
  final int id;
  final MovieTabsState state;

  const MovieCreditsTabLoadEvent({required this.id, required this.state});

  @override
  List<Object> get props => [id, state];
}

final class MovieReviewsTabLoadEvent extends MovieTabsEvent {
  final int id;
  final MovieTabsState state;

  const MovieReviewsTabLoadEvent({required this.id, required this.state});

  @override
  List<Object> get props => [id, state];
}

final class MovieSimilarTabLoadEvent extends MovieTabsEvent {
  final int id;
  final MovieTabsState state;

  const MovieSimilarTabLoadEvent({required this.id, required this.state});

  @override
  List<Object> get props => [id, state];
}
