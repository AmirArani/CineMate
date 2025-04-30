part of 'discover_bloc.dart';

class DiscoverState extends Equatable {
  final int selectedTabIndex;
  final DiscoverMovieParams? movieParams;
  final DiscoverTvParams? tvParams;
  final int lastUpdate;

  const DiscoverState({
    required this.selectedTabIndex,
    this.movieParams,
    this.tvParams,
    this.lastUpdate = 0,
  });

  DiscoverState copyWith({
    int? selectedTabIndex,
    DiscoverMovieParams? movieParams,
    DiscoverTvParams? tvParams,
    int? lastUpdate,
  }) {
    return DiscoverState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      movieParams: movieParams ?? this.movieParams,
      tvParams: tvParams ?? this.tvParams,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex, movieParams, tvParams, lastUpdate];
}
