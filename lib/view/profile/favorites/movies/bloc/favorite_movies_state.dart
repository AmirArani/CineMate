part of 'favorite_movies_bloc.dart';

abstract class FavoriteMoviesState extends Equatable {
  final ListPreferences preferences;

  const FavoriteMoviesState(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class FavoriteMoviesInitial extends FavoriteMoviesState {
  const FavoriteMoviesInitial(super.preferences);
}

class FavoriteMoviesLoadInProgress extends FavoriteMoviesState {
  const FavoriteMoviesLoadInProgress(super.preferences);
}

class FavoriteMoviesLoadSuccess extends FavoriteMoviesState {
  const FavoriteMoviesLoadSuccess(super.preferences);
}

class FavoriteMoviesLoadFailure extends FavoriteMoviesState {
  final String error;

  const FavoriteMoviesLoadFailure(super.preferences, this.error);

  @override
  List<Object> get props => [super.preferences, error];
}
