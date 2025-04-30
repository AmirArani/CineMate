part of 'favorite_shows_bloc.dart';

abstract class FavoriteShowsEvent extends Equatable {
  const FavoriteShowsEvent();

  @override
  List<Object> get props => [];
}

class FavoriteShowsPreferencesChanged extends FavoriteShowsEvent {
  final ListPreferences preferences;

  const FavoriteShowsPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class FavoriteShowsPageRequested extends FavoriteShowsEvent {
  final int page;

  const FavoriteShowsPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
