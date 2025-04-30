part of 'tv_show_bloc.dart';

sealed class TvShowEvent extends Equatable {
  const TvShowEvent();
}

final class TvShowLoadEvent extends TvShowEvent {
  final BuildContext context;
  final int id;

  const TvShowLoadEvent({required this.context, required this.id});

  @override
  List<Object> get props => [context, id];
}

final class ActionUpdateEvent extends TvShowEvent {
  final TvShowLoaded state;

  const ActionUpdateEvent({required this.state});

  @override
  List<Object> get props => [state];
}

final class ActionClickEvent extends TvShowEvent {
  final TvShowLoaded state;
  final bool favoriteLoading;
  final bool watchlistLoading;
  final bool ratingLoading;

  const ActionClickEvent(
      {required this.state,
      this.favoriteLoading = false,
      this.watchlistLoading = false,
      this.ratingLoading = false});

  @override
  List<Object> get props => [state, favoriteLoading, watchlistLoading, ratingLoading];
}

// New events for the rating flow
final class OpenRatingBottomSheetEvent extends TvShowEvent {
  final TvShowLoaded state;
  final BuildContext context;

  const OpenRatingBottomSheetEvent({required this.state, required this.context});

  @override
  List<Object> get props => [state, context];
}

final class SubmitRatingEvent extends TvShowEvent {
  final TvShowLoaded state;
  final BuildContext context;
  final double rating;

  const SubmitRatingEvent({
    required this.state,
    required this.context,
    required this.rating,
  });

  @override
  List<Object> get props => [state, context, rating];
}

final class CloseRatingBottomSheetEvent extends TvShowEvent {
  final BuildContext context;

  const CloseRatingBottomSheetEvent({required this.context});

  @override
  List<Object> get props => [context];
}

// New events for favorite action
final class ToggleFavoriteEvent extends TvShowEvent {
  final TvShowLoaded state;
  final BuildContext context;

  const ToggleFavoriteEvent({required this.state, required this.context});

  @override
  List<Object> get props => [state, context];
}

// New events for watchlist action
final class ToggleWatchlistEvent extends TvShowEvent {
  final TvShowLoaded state;
  final BuildContext context;

  const ToggleWatchlistEvent({required this.state, required this.context});

  @override
  List<Object> get props => [state, context];
}
