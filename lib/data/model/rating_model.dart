import 'package:cinemate/data/model/tv_show_model.dart';

import 'movie_model.dart';

class RatedMovieModel {
  final MovieModel movie;
  final double rate;

  RatedMovieModel({required this.movie, required this.rate});

  RatedMovieModel.fromJson(Map<String, dynamic> json)
      : movie = MovieModel.fromJson(json),
        rate = json['rating'];

  static List<RatedMovieModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<RatedMovieModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(RatedMovieModel.fromJson(jsonObject));
    }
    return items;
  }
}

class RatedShowModel {
  final TvShowModel show;
  final double rate;

  RatedShowModel({required this.show, required this.rate});

  RatedShowModel.fromJson(Map<String, dynamic> json)
      : show = TvShowModel.fromJson(json),
        rate = json['rating'];

  static List<RatedShowModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<RatedShowModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(RatedShowModel.fromJson(jsonObject));
    }
    return items;
  }
}

class RatingMovieListResponseModel {
  final int page;
  final List<RatedMovieModel> ratedMovies;
  final int totalPages;
  final int totalResults;

  RatingMovieListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        ratedMovies = RatedMovieModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}

class RatingShowsListResponseModel {
  final int page;
  final List<RatedShowModel> ratedShows;
  final int totalPages;
  final int totalResults;

  RatingShowsListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        ratedShows = RatedShowModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}
