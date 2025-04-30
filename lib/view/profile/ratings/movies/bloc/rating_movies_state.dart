part of 'rating_movies_bloc.dart';

abstract class RatingMoviesState extends Equatable {
  final ListPreferences preferences;

  const RatingMoviesState(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class RatingMoviesInitial extends RatingMoviesState {
  const RatingMoviesInitial(super.preferences);
}

class RatingMoviesLoadInProgress extends RatingMoviesState {
  const RatingMoviesLoadInProgress(super.preferences);
}

class RatingMoviesLoadSuccess extends RatingMoviesState {
  const RatingMoviesLoadSuccess(super.preferences);
}

class RatingMoviesLoadFailure extends RatingMoviesState {
  final String error;

  const RatingMoviesLoadFailure(super.preferences, this.error);

  @override
  List<Object> get props => [super.preferences, error];
}
