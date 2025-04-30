part of 'recommended_shows_bloc.dart';

abstract class RecommendedShowsEvent extends Equatable {
  const RecommendedShowsEvent();

  @override
  List<Object> get props => [];
}

class RecommendedShowsPageRequested extends RecommendedShowsEvent {
  final int page;

  const RecommendedShowsPageRequested(this.page);

  @override
  List<Object> get props => [page];
}
