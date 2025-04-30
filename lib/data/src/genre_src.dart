import 'package:cinemate/utils/web/urls.dart';
import 'package:dio/dio.dart';

import '../model/genre_model.dart';

abstract class IGenreDataSource {
  Future<List<GenreModel>> getPopularGenres();

  Future<List<GenreModel>> getMovieGenres();

  Future<List<GenreModel>> getTvShowGenres();
}

class GenreRemoteSrc implements IGenreDataSource {
  final Dio httpClient;

  GenreRemoteSrc(this.httpClient);

  @override
  Future<List<GenreModel>> getPopularGenres() async {
    final response = await httpClient.get(getPopularGenresURL);
    return GenreModel.parseJsonArray(response.data['genres']);
  }

  @override
  Future<List<GenreModel>> getMovieGenres() async {
    final response = await httpClient.get(getMovieGenresURL);
    return GenreModel.parseJsonArray(response.data['genres']);
  }

  @override
  Future<List<GenreModel>> getTvShowGenres() async {
    final response = await httpClient.get(getTvShowGenresURL);
    return GenreModel.parseJsonArray(response.data['genres']);
  }
}
