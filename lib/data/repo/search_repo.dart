import 'package:cinemate/data/repo/person_repo.dart';
import 'package:cinemate/data/repo/tv_repo.dart';

import '../../utils/web/http_client.dart';
import '../model/company_model.dart';
import '../model/keyword_model.dart';
import '../model/media_model.dart';
import '../model/movie_model.dart';
import '../model/person_model.dart';
import '../model/tv_show_model.dart';
import '../src/search_src.dart';
import 'movie_repo.dart';

final searchRepo = SearchRepository(remoteSrc: SearchSrc(httpClient: httpClient));

class SearchRepository {
  final SearchSrc _remoteSrc;

  SearchRepository({required SearchSrc remoteSrc}) : _remoteSrc = remoteSrc;

  Future<MediaListResponseModel> search({required String query, required int page}) async {
    final MediaListResponseModel results = await _remoteSrc.search(query: query, page: page);

    if (results.results.isNotEmpty) {
      for (MediaModel item in results.results) {
        if (item.mediaType == MediaType.movie && item.movie != null) {
          movieRepository.updateCachedMovies(newMovies: [item.movie!]);
        } else if (item.mediaType == MediaType.tv && item.show != null) {
          tvShowRepository.updateCachedTvShows(newShows: [item.show!]);
        } else if (item.mediaType == MediaType.person && item.person != null) {
          personRepository.updateCachedPersons(newPersons: [item.person!]);
        }
      }
    }

    return results;
  }

  Future<MovieListResponseModel> searchMovies({required String query, required int page}) async {
    final MovieListResponseModel moviesResponse =
        await _remoteSrc.searchMovies(query: query, page: page);

    if (moviesResponse.movies.isNotEmpty) {
      movieRepository.updateCachedMovies(newMovies: moviesResponse.movies);
    }

    return moviesResponse;
  }

  Future<TvShowListResponseModel> searchShows({required String query, required int page}) async {
    final TvShowListResponseModel showsResponse =
        await _remoteSrc.searchShows(query: query, page: page);

    if (showsResponse.shows.isNotEmpty) {
      tvShowRepository.updateCachedTvShows(newShows: showsResponse.shows);
    }

    return showsResponse;
  }

  Future<PersonListResponseModel> searchPersons({required String query, required int page}) async {
    final PersonListResponseModel personsResponse =
        await _remoteSrc.searchPersons(query: query, page: page);

    if (personsResponse.personList.isNotEmpty) {
      personRepository.updateCachedPersons(newPersons: personsResponse.personList);
    }

    return personsResponse;
  }

  Future<KeywordListResponseModel> searchKeywords({required String query, required int page}) =>
      _remoteSrc.searchKeywords(query: query, page: page);

  Future<CompanyListResponseModel> searchCompanies({required String query, required int page}) =>
      _remoteSrc.searchCompanies(query: query, page: page);
}
