part of 'rating_movies_bloc.dart';

abstract class RatingMoviesEvent extends Equatable {
  const RatingMoviesEvent();

  @override
  List<Object> get props => [];
}

class RatingMoviesPreferencesChanged extends RatingMoviesEvent {
  final ListPreferences preferences;

  const RatingMoviesPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class RatingMoviesPageRequested extends RatingMoviesEvent {
  final int page;

  const RatingMoviesPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
