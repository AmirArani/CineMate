part of 'watch_list_movie_bloc.dart';

abstract class WatchListMoviesState extends Equatable {
  final ListPreferences preferences;

  const WatchListMoviesState(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class WatchListMoviesInitial extends WatchListMoviesState {
  const WatchListMoviesInitial(super.preferences);
}

class WatchListMoviesLoadInProgress extends WatchListMoviesState {
  const WatchListMoviesLoadInProgress(super.preferences);
}

class WatchListMoviesLoadSuccess extends WatchListMoviesState {
  const WatchListMoviesLoadSuccess(super.preferences);
}

class WatchListMoviesLoadFailure extends WatchListMoviesState {
  final String error;

  const WatchListMoviesLoadFailure(super.preferences, this.error);

  @override
  List<Object> get props => [super.preferences, error];
}
