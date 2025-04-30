import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/account_state_model.dart';
import '../../../data/model/movie_model.dart';
import '../../../data/repo/account_repo.dart';
import '../../../data/repo/auth_repo.dart';
import '../../../data/repo/movie_repo.dart';
import '../../../utils/routes/route_data.dart';
import '../../common_widgets/rating_bar.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading(movie: _tempMovie)) {
    on<MovieLoadEvent>((event, emit) async {
      await _handleMovieLoadEvent(emit, event);
    });

    on<ActionUpdateEvent>((event, emit) async {
      final AccountStateModel accountState;
      final String? session = await authRepo.getSessionToken();
      if (session != null) {
        await Future.delayed(const Duration(seconds: 1));
        accountState = await movieRepository.getAccountState(id: event.state.movie.id);
      } else {
        accountState = AccountStateModel(id: -1, favorite: false, watchlist: false, rate: null);
      }

      emit(event.state.copyWith(
          accountState: accountState,
          favoriteLoading: false,
          watchlistLoading: false,
          ratingLoading: false));
    });

    on<ActionClickEvent>((event, emit) async {
      emit(event.state.copyWith(
        favoriteLoading: event.favoriteLoading,
        watchlistLoading: event.watchlistLoading,
        ratingLoading: event.ratingLoading,
      ));
    });

    // Handle the opening of rating bottom sheet
    on<OpenRatingBottomSheetEvent>((event, emit) async {
      _showRatingBottomSheet(event.context, event.state);
    });

    // Handle the rating submission
    on<SubmitRatingEvent>((event, emit) async {
      if (event.rating > 0) {
        add(ActionClickEvent(state: event.state, ratingLoading: true));

        final String? session = await authRepo.getSessionToken();

        if (session != null) {
          final bool success =
              await accountRepo.editRating(item: event.state.movie, newRating: event.rating * 2);

          if (success) {
            // Create updated state with new rating
            final updatedAccountState = event.state.accountState.copyWith(rate: event.rating);
            final updatedState = event.state.copyWith(accountState: updatedAccountState);

            add(ActionUpdateEvent(state: updatedState));
          } else {
            ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
              content: Text('Failed! try again...'),
              behavior: SnackBarBehavior.floating,
            ));
          }
        } else {
          _showLoginSnackBar(event.context);
          add(ActionUpdateEvent(state: event.state));
        }
      }

      // Close the bottom sheet
      add(CloseRatingBottomSheetEvent(context: event.context));
    });

    // Handle closing the rating bottom sheet
    on<CloseRatingBottomSheetEvent>((event, emit) {
      Navigator.of(event.context).pop();
    });

    // Handle toggling favorite status
    on<ToggleFavoriteEvent>((event, emit) async {
      add(ActionClickEvent(state: event.state, favoriteLoading: true));

      final String? session = await authRepo.getSessionToken();

      if (session != null) {
        final bool success = await accountRepo.editFavorite(
            item: event.state.movie, delete: event.state.accountState.favorite);
        if (success) {
          // Create updated state with toggled favorite status
          final updatedAccountState =
              event.state.accountState.copyWith(favorite: !event.state.accountState.favorite);
          final updatedState = event.state.copyWith(accountState: updatedAccountState);

          add(ActionUpdateEvent(state: updatedState));
        } else {
          ScaffoldMessenger.of(event.context)
              .showSnackBar(SnackBar(content: Text('Failed! try again...')));
        }
      } else {
        _showLoginSnackBar(event.context);
        add(ActionUpdateEvent(state: event.state));
      }
    });

    // Handle toggling watchlist status
    on<ToggleWatchlistEvent>((event, emit) async {
      add(ActionClickEvent(state: event.state, watchlistLoading: true));

      final String? session = await authRepo.getSessionToken();

      if (session != null) {
        final bool success = await accountRepo.editWatchList(
            item: event.state.movie, delete: event.state.accountState.watchlist);
        if (success) {
          // Create updated state with toggled watchlist status
          final updatedAccountState =
              event.state.accountState.copyWith(watchlist: !event.state.accountState.watchlist);
          final updatedState = event.state.copyWith(accountState: updatedAccountState);

          add(ActionUpdateEvent(state: updatedState));
        } else {
          ScaffoldMessenger.of(event.context)
              .showSnackBar(SnackBar(content: Text('Failed! try again...')));
        }
      } else {
        _showLoginSnackBar(event.context);
        add(ActionUpdateEvent(state: event.state));
      }
    });
  }

  // Helper method to show rating bottom sheet
  void _showRatingBottomSheet(BuildContext context, MovieLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (bottomSheetContext) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rate this movie',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            RatingBar(
              alignment: Alignment.center,
              size: 35,
              initialRating: state.accountState.rate ?? 0,
              onRatingChanged: (value) async {
                // Dispatch submit rating event
                add(SubmitRatingEvent(
                  state: state,
                  context: bottomSheetContext,
                  rating: value,
                ));
              },
            ),
            SizedBox(height: 8),
            state.accountState.watchlist
                ? Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Warning! This movie is in your watchlist, But if you rate it, it will be removed from watchlist automatically.\nYou can turn-off this feature in your account setting, "Sharing Setting" section.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  // Helper method to show login snackbar
  void _showLoginSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please Login first!'),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Login',
        onPressed: () {
          ProfileScreenRouteData().push(context);
        },
      ),
    ));
  }
}

Future<void> _handleMovieLoadEvent(Emitter emit, MovieLoadEvent event) async {
  final int id = event.id;
  MovieModel? movie = movieRepository.getMovieById(id: id);

  try {
    emit(MovieLoading(movie: movie ?? _tempMovie));

    MovieDetailModel movieData = await movieRepository.getMovieDetail(id: id);
    List<String> posterPaths = await movieRepository.getMovieImages(id: id);

    AccountStateModel accountState;
    final String? session = await authRepo.getSessionToken();
    if (session != null) {
      accountState = await movieRepository.getAccountState(id: id);
    } else {
      accountState = AccountStateModel(id: -1, favorite: false, watchlist: false, rate: null);
    }

    emit(MovieLoaded(
      movie: movie ??
          MovieModel(
              id: id,
              title: movieData.title,
              overview: movieData.overview,
              originalLanguage: movieData.originalLanguage,
              posterPath: movieData.posterPath,
              backdropPath: movieData.backdropPath,
              releaseDate: movieData.releaseDate,
              vote: movieData.vote),
      movieData: movieData,
      backdropPaths: posterPaths,
      accountState: accountState,
      favoriteLoading: false,
      watchlistLoading: false,
      ratingLoading: false,
    ));
  } catch (error) {
    emit(MovieError(movie: movie ?? _tempMovie));
  }
}

MovieModel _tempMovie = MovieModel(
    id: -1,
    title: 'null',
    overview: 'null',
    originalLanguage: '',
    posterPath: '',
    backdropPath: '',
    releaseDate: '',
    vote: -1);
