part of 'recommended_movies_bloc.dart';

abstract class RecommendedMoviesState extends Equatable {
  const RecommendedMoviesState();

  @override
  List<Object> get props => [];
}

class RecommendedMoviesInitial extends RecommendedMoviesState {
  const RecommendedMoviesInitial();
}

class RecommendedMoviesLoadInProgress extends RecommendedMoviesState {
  const RecommendedMoviesLoadInProgress();
}

class RecommendedMoviesLoadSuccess extends RecommendedMoviesState {
  const RecommendedMoviesLoadSuccess();
}

class RecommendedMoviesLoadFailure extends RecommendedMoviesState {
  final String error;

  const RecommendedMoviesLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
