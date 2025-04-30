part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

class HomeLoadingState extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeErrorState extends HomeState {
  final AppException exception;

  const HomeErrorState({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class HomeSuccessState extends HomeState {
  final List<GenreModel> popularGenres;
  final List<MovieModel> trendingMovies;
  final TvShowDetailModel lastEpisodeToAir;
  final List<MovieModel> bestDrama;
  final List<PersonModel> popularArtists;
  final List<TvShowModel> topTvShow;

  const HomeSuccessState({
    required this.popularGenres,
    required this.trendingMovies,
    required this.lastEpisodeToAir,
    required this.bestDrama,
    required this.popularArtists,
    required this.topTvShow,
  });

  @override
  List<Object?> get props => [];
}
