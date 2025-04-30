part of 'rating_shows_bloc.dart';

abstract class RatingShowsState extends Equatable {
  final ListPreferences preferences;

  const RatingShowsState(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class RatingShowsInitial extends RatingShowsState {
  const RatingShowsInitial(super.preferences);
}

class RatingShowsLoadInProgress extends RatingShowsState {
  const RatingShowsLoadInProgress(super.preferences);
}

class RatingShowsLoadSuccess extends RatingShowsState {
  const RatingShowsLoadSuccess(super.preferences);
}

class RatingShowsLoadFailure extends RatingShowsState {
  final String error;

  const RatingShowsLoadFailure(super.preferences, this.error);

  @override
  List<Object> get props => [super.preferences, error];
}
