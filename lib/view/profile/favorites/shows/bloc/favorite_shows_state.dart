part of 'favorite_shows_bloc.dart';

abstract class FavoriteShowsState extends Equatable {
  final ListPreferences preferences;

  const FavoriteShowsState(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class FavoriteShowsInitial extends FavoriteShowsState {
  const FavoriteShowsInitial(super.preferences);
}

class FavoriteShowsLoadInProgress extends FavoriteShowsState {
  const FavoriteShowsLoadInProgress(super.preferences);
}

class FavoriteShowsLoadSuccess extends FavoriteShowsState {
  const FavoriteShowsLoadSuccess(super.preferences);
}

class FavoriteShowsLoadFailure extends FavoriteShowsState {
  final String error;

  const FavoriteShowsLoadFailure(super.preferences, this.error);

  @override
  List<Object> get props => [super.preferences, error];
}
