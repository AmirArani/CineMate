part of 'tv_show_tabs_bloc.dart';

sealed class TvShowTabsEvent extends Equatable {
  const TvShowTabsEvent();
}

final class TvShowTabsReloadEvent extends TvShowTabsEvent {
  final int id;

  const TvShowTabsReloadEvent({required this.id});

  @override
  List<Object> get props => [id];
}

final class TvShowSeasonsAndEpisodesTabLoadEvent extends TvShowTabsEvent {
  final int id;
  final TvShowTabsState state;
  final TvShowDetailModel? showData;

  const TvShowSeasonsAndEpisodesTabLoadEvent(
      {required this.id, required this.state, required this.showData});

  @override
  List<Object> get props => [id, state];
}

final class TvShowGetSeasonEpisodesEvent extends TvShowTabsEvent {
  final int seasonNumber;
  final TvShowTabsState state;

  const TvShowGetSeasonEpisodesEvent({required this.seasonNumber, required this.state});

  @override
  List<Object> get props => [seasonNumber, state];
}

final class TvShowCreditsTabLoadEvent extends TvShowTabsEvent {
  final int id;
  final TvShowTabsState state;

  const TvShowCreditsTabLoadEvent({required this.id, required this.state});

  @override
  List<Object> get props => [id, state];
}

final class TvShowReviewsTabLoadEvent extends TvShowTabsEvent {
  final int id;
  final TvShowTabsState state;

  const TvShowReviewsTabLoadEvent({required this.id, required this.state});

  @override
  List<Object> get props => [id, state];
}

final class TvShowSimilarTabLoadEvent extends TvShowTabsEvent {
  final int id;
  final TvShowTabsState state;

  const TvShowSimilarTabLoadEvent({required this.id, required this.state});

  @override
  List<Object> get props => [id, state];
}
