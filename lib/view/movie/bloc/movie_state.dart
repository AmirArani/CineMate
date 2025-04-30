part of 'movie_bloc.dart';

sealed class MovieState extends Equatable {
  final MovieModel movie;

  const MovieState({required this.movie});

  @override
  List<Object> get props => [movie];
}

final class MovieLoaded extends MovieState {
  final MovieDetailModel movieData;
  final List<String> backdropPaths;
  final AccountStateModel accountState;
  final bool favoriteLoading;
  final bool watchlistLoading;
  final bool ratingLoading;

  const MovieLoaded({
    required super.movie,
    required this.movieData,
    required this.backdropPaths,
    required this.accountState,
    required this.favoriteLoading,
    required this.watchlistLoading,
    required this.ratingLoading,
  });

  @override
  List<Object> get props => [
        movieData,
        backdropPaths,
        accountState,
        favoriteLoading,
        watchlistLoading,
        ratingLoading,
      ];

  MovieLoaded copyWith({
    MovieModel? movie,
    MovieDetailModel? movieData,
    List<String>? backdropPaths,
    AccountStateModel? accountState,
    bool? favoriteLoading,
    bool? watchlistLoading,
    bool? ratingLoading,
  }) {
    return MovieLoaded(
      movie: movie ?? this.movie,
      movieData: movieData ?? this.movieData,
      backdropPaths: backdropPaths ?? this.backdropPaths,
      accountState: accountState ?? this.accountState,
      favoriteLoading: favoriteLoading ?? this.favoriteLoading,
      watchlistLoading: watchlistLoading ?? this.watchlistLoading,
      ratingLoading: ratingLoading ?? this.ratingLoading,
    );
  }
}

final class MovieLoading extends MovieState {
  const MovieLoading({required super.movie});

  @override
  List<Object> get props => [movie];
}

final class MovieError extends MovieState {
  const MovieError({required super.movie});

  @override
  List<Object> get props => [movie];
}
