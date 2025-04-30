part of 'favorite_movies_bloc.dart';

abstract class FavoriteMoviesEvent extends Equatable {
  const FavoriteMoviesEvent();

  @override
  List<Object> get props => [];
}

class FavoriteMoviesPreferencesChanged extends FavoriteMoviesEvent {
  final ListPreferences preferences;

  const FavoriteMoviesPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class FavoriteMoviesPageRequested extends FavoriteMoviesEvent {
  final int page;

  const FavoriteMoviesPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
