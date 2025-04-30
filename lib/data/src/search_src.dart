import 'package:cinemate/data/model/tv_show_model.dart';
import 'package:cinemate/utils/web/urls.dart';
import 'package:dio/dio.dart';

import '../model/company_model.dart';
import '../model/keyword_model.dart';
import '../model/media_model.dart';
import '../model/movie_model.dart';
import '../model/person_model.dart';

class SearchSrc {
  final Dio _httpClient;

  SearchSrc({required Dio httpClient}) : _httpClient = httpClient;

  Future<MediaListResponseModel> search({required String query, required int page}) async {
    final response = await _httpClient.get(
      searchMultiURL,
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': true,
        'language': 'en-US',
      },
    );
    //TODO: handle error
    return MediaListResponseModel.fromJson(response.data);
  }

  Future<MovieListResponseModel> searchMovies({required String query, required int page}) async {
    final response = await _httpClient.get(
      searchMoviesURL,
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': true,
        'language': 'en-US',
      },
    );
    //TODO: handle error
    return MovieListResponseModel.fromJson(response.data);
  }

  Future<TvShowListResponseModel> searchShows({required String query, required int page}) async {
    final response = await _httpClient.get(
      searchShowsURL,
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': true,
        'language': 'en-US',
      },
    );
    //TODO: handle error
    return TvShowListResponseModel.fromJson(response.data);
  }

  Future<PersonListResponseModel> searchPersons({required String query, required int page}) async {
    final response = await _httpClient.get(
      searchPersonsURL,
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': true,
        'language': 'en-US',
      },
    );
    //TODO: handle error
    return PersonListResponseModel.fromJson(response.data);
  }

  Future<KeywordListResponseModel> searchKeywords(
      {required String query, required int page}) async {
    final response = await _httpClient.get(
      searchKeywordsURL,
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': true,
        'language': 'en-US',
      },
    );
    //TODO: handle error
    return KeywordListResponseModel.fromJson(response.data);
  }

  Future<CompanyListResponseModel> searchCompanies(
      {required String query, required int page}) async {
    final response = await _httpClient.get(
      searchCompaniesURL,
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': true,
        'language': 'en-US',
      },
    );
    //TODO: handle error
    return CompanyListResponseModel.fromJson(response.data);
  }
}
