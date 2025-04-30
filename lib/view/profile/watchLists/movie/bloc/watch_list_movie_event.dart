part of 'watch_list_movie_bloc.dart';

abstract class WatchListMoviesEvent extends Equatable {
  const WatchListMoviesEvent();

  @override
  List<Object> get props => [];
}

class WatchListMoviesPreferencesChanged extends WatchListMoviesEvent {
  final ListPreferences preferences;

  const WatchListMoviesPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class WatchListMoviesPageRequested extends WatchListMoviesEvent {
  final int page;

  const WatchListMoviesPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
