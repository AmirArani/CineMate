import 'package:cinemate/data/model/genre_model.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String originalLanguage;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double vote;

  MovieModel(
      {required this.id,
      required this.title,
      required this.overview,
      required this.originalLanguage,
      required this.posterPath,
      required this.backdropPath,
      required this.releaseDate,
      required this.vote});

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        overview = json['overview'] ?? 'null',
        title = json['title'] ?? 'null',
        originalLanguage = json['original_language'] ?? 'null',
        posterPath = json['poster_path'] ?? 'null',
        backdropPath = json['backdrop_path'] ?? 'null',
        releaseDate = json['release_date'] ?? 'null',
        vote = json['vote_average'] ?? -1;

  static List<MovieModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<MovieModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(MovieModel.fromJson(jsonObject));
    }
    return items;
  }
}

class MovieListResponseModel {
  final int page;
  final List<MovieModel> movies;
  final int totalPages;
  final int totalResults;

  MovieListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        movies = MovieModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}

class MovieDetailModel {
  final int id;
  final String title;
  final String tagLine;
  final String overview;
  final String originalLanguage;
  final String originCountry;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final int runtime;
  final double vote;
  final List<GenreModel> genres;
  final String homepageUrl;
  final String imdbId;
  final String status;

  MovieDetailModel(
      {required this.id,
      required this.title,
      required this.tagLine,
      required this.overview,
      required this.originalLanguage,
      required this.originCountry,
      required this.posterPath,
      required this.backdropPath,
      required this.releaseDate,
      required this.runtime,
      required this.vote,
      required this.genres,
      required this.homepageUrl,
      required this.imdbId,
      required this.status});

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? 'null',
        tagLine = json['tagline'] ?? 'null',
        overview = json['overview'] ?? 'null',
        originalLanguage = json['original_language'] ?? 'null',
        originCountry = json['origin_country'][0] ?? 'null',
        posterPath = json['poster_path'] ?? 'null',
        backdropPath = json['backdrop_path'] ?? 'null',
        releaseDate = json['release_date'] ?? 'null',
        runtime = json['runtime'] ?? -1,
        vote = json['vote_average'] ?? -1,
        genres = GenreModel.parseJsonArray(json['genres']),
        homepageUrl = json['homepage'] ?? 'null',
        imdbId = json['imdb_id'] ?? '',
        status = json['status'] ?? 'null';
}
