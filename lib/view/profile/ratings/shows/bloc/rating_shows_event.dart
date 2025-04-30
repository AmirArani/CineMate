part of 'rating_shows_bloc.dart';

abstract class RatingShowsEvent extends Equatable {
  const RatingShowsEvent();

  @override
  List<Object> get props => [];
}

class RatingShowsPreferencesChanged extends RatingShowsEvent {
  final ListPreferences preferences;

  const RatingShowsPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class RatingShowsPageRequested extends RatingShowsEvent {
  final int page;

  const RatingShowsPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
