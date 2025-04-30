import 'package:cinemate/data/repo/discover_repo.dart';
import 'package:cinemate/utils/web/urls.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/genre_model.dart';
import '../../../data/model/movie_model.dart';
import '../../../data/model/person_model.dart';
import '../../../data/model/tv_show_model.dart';
import '../../../data/repo/genre_repo.dart';
import '../../../data/repo/movie_repo.dart';
import '../../../data/repo/person_repo.dart';
import '../../../data/repo/tv_repo.dart';
import '../../../utils/helpers/exception.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<HomeLoadEvent>((event, emit) async {
      try {
        emit(HomeLoadingState());

        final popularGenres = await genreRepository.getPopularGenres();
        final trendingMovies = await movieRepository.getPopularMovies();
        final lastEpisodeToAir = await tvShowRepository.getLatestFeaturedEpisode();
        final bestDrama = await discoverRepo.getMoviesInGenre(genreId: dramaGenreId, page: 1);
        final popularArtists = await personRepository.getPopularArtists();
        final topTvShows = await tvShowRepository.getTopTvShows();

        emit(HomeSuccessState(
          popularGenres: popularGenres,
          trendingMovies: trendingMovies,
          lastEpisodeToAir: lastEpisodeToAir,
          bestDrama: bestDrama.movies,
          popularArtists: popularArtists,
          topTvShow: topTvShows,
        ));
      } catch (e) {
        emit(HomeErrorState(exception: e is AppException ? e : AppException()));
      }
    });
  }
}
