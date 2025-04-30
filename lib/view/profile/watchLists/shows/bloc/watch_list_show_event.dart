part of 'watch_list_show_bloc.dart';

sealed class WatchListShowEvent extends Equatable {
  const WatchListShowEvent();

  @override
  List<Object> get props => [];
}

class WatchListShowsPreferencesChanged extends WatchListShowEvent {
  final ListPreferences preferences;

  const WatchListShowsPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class WatchListShowsPageRequested extends WatchListShowEvent {
  final int page;

  const WatchListShowsPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
