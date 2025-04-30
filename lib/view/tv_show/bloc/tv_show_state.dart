part of 'tv_show_bloc.dart';

sealed class TvShowState extends Equatable {
  final TvShowModel tvShow;

  const TvShowState({required this.tvShow});

  @override
  List<Object> get props => [tvShow];
}

final class TvShowLoaded extends TvShowState {
  final TvShowDetailModel tvShowData;
  final List<String> backdropPaths;
  final AccountStateModel accountState;
  final bool favoriteLoading;
  final bool watchlistLoading;
  final bool ratingLoading;

  const TvShowLoaded(
      {required super.tvShow,
      required this.tvShowData,
      required this.backdropPaths,
      required this.accountState,
      required this.favoriteLoading,
      required this.watchlistLoading,
      required this.ratingLoading});

  @override
  List<Object> get props => [
        tvShowData,
        backdropPaths,
        accountState,
        favoriteLoading,
        watchlistLoading,
        ratingLoading,
      ];

  TvShowLoaded copyWith({
    TvShowModel? tvShow,
    TvShowDetailModel? tvShowData,
    List<String>? backdropPaths,
    AccountStateModel? accountState,
    bool? favoriteLoading,
    bool? watchlistLoading,
    bool? ratingLoading,
  }) {
    return TvShowLoaded(
      tvShow: tvShow ?? this.tvShow,
      tvShowData: tvShowData ?? this.tvShowData,
      backdropPaths: backdropPaths ?? this.backdropPaths,
      accountState: accountState ?? this.accountState,
      favoriteLoading: favoriteLoading ?? this.favoriteLoading,
      watchlistLoading: watchlistLoading ?? this.watchlistLoading,
      ratingLoading: ratingLoading ?? this.ratingLoading,
    );
  }
}

final class TvShowLoading extends TvShowState {
  const TvShowLoading({required super.tvShow});

  @override
  List<Object> get props => [tvShow];
}

final class TvShowError extends TvShowState {
  const TvShowError({required super.tvShow});

  @override
  List<Object> get props => [tvShow];
}
