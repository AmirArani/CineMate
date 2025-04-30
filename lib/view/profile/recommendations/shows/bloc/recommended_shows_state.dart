part of 'recommended_shows_bloc.dart';

abstract class RecommendedShowsState extends Equatable {
  const RecommendedShowsState();

  @override
  List<Object> get props => [];
}

class RecommendedShowsInitial extends RecommendedShowsState {
  const RecommendedShowsInitial();
}

class RecommendedShowsLoadInProgress extends RecommendedShowsState {
  const RecommendedShowsLoadInProgress();
}

class RecommendedShowsLoadSuccess extends RecommendedShowsState {
  const RecommendedShowsLoadSuccess();
}

class RecommendedShowsLoadFailure extends RecommendedShowsState {
  final String error;

  const RecommendedShowsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
