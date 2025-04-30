part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object> get props => [];
}

class DiscoverTabSelected extends DiscoverEvent {
  final int index;

  const DiscoverTabSelected(this.index);

  @override
  List<Object> get props => [index];
}

class DiscoverMoviePageRequested extends DiscoverEvent {
  final int page;

  const DiscoverMoviePageRequested(this.page);

  @override
  List<Object> get props => [page];
}

class DiscoverTvShowPageRequested extends DiscoverEvent {
  final int page;

  const DiscoverTvShowPageRequested(this.page);

  @override
  List<Object> get props => [page];
}

class DiscoverMovieParamsChanged extends DiscoverEvent {
  final DiscoverMovieParams params;

  const DiscoverMovieParamsChanged(this.params);

  @override
  List<Object> get props => [params];
}

class DiscoverTvParamsChanged extends DiscoverEvent {
  final DiscoverTvParams params;

  const DiscoverTvParamsChanged(this.params);

  @override
  List<Object> get props => [params];
}
