part of 'recommended_movies_bloc.dart';

abstract class RecommendedMoviesEvent extends Equatable {
  const RecommendedMoviesEvent();

  @override
  List<Object> get props => [];
}

class RecommendedMoviesPageRequested extends RecommendedMoviesEvent {
  final int page;

  const RecommendedMoviesPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
