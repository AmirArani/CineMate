part of 'watch_list_show_bloc.dart';

sealed class WatchListShowState extends Equatable {
  final ListPreferences preferences;

  const WatchListShowState(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class WatchListShowsInitial extends WatchListShowState {
  const WatchListShowsInitial(super.preferences);
}

class WatchListShowsLoadInProgress extends WatchListShowState {
  const WatchListShowsLoadInProgress(super.preferences);
}

class WatchListShowsLoadSuccess extends WatchListShowState {
  const WatchListShowsLoadSuccess(super.preferences);
}

class WatchListShowsLoadFailure extends WatchListShowState {
  final String error;

  const WatchListShowsLoadFailure(super.preferences, this.error);

  @override
  List<Object> get props => [super.preferences, error];
}
