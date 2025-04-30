import 'package:cinemate/data/model/person_model.dart';

import 'genre_model.dart';

class TvShowModel {
  final int id;
  final String title;
  final String overview;
  final String originalLanguage;
  final String originCountry;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double vote;

  TvShowModel(
      {required this.id,
      required this.title,
      required this.overview,
      required this.originalLanguage,
      required this.originCountry,
      required this.posterPath,
      required this.backdropPath,
      required this.releaseDate,
      required this.vote});

  TvShowModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        overview = json['overview'],
        title = json['name'],
        originalLanguage = json['original_language'],
        originCountry =
            (json['origin_country'] as List).isNotEmpty ? json['origin_country'][0] : '',
        posterPath = json['poster_path'] ?? 'null',
        backdropPath = json['backdrop_path'] ?? 'null',
        releaseDate = json['first_air_date'],
        vote = json['vote_average'] ?? -1;

  static List<TvShowModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<TvShowModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(TvShowModel.fromJson(jsonObject));
    }
    return items;
  }
}

class TvShowListResponseModel {
  final int page;
  final List<TvShowModel> shows;
  final int totalPages;
  final int totalResults;

  TvShowListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        shows = TvShowModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}

class TvShowDetailModel {
  final int id;
  final String name;
  final String tagLine;
  final String overview;
  final String originalLanguage;
  final String originCountry;
  final String posterPath;
  final String backdropPath;
  final double vote;
  final List<GenreModel> genres;
  final String homepageUrl;
  final String status;
  final String firstAirDate;
  final String lastAirDate;
  final EpisodeModel lastEpisodeToAir;
  final EpisodeModel? nextEpisodeToAir;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<PersonModel> creators;
  final List<SeasonModel> seasons;

  TvShowDetailModel(
      {required this.id,
      required this.name,
      required this.tagLine,
      required this.overview,
      required this.originalLanguage,
      required this.originCountry,
      required this.posterPath,
      required this.backdropPath,
      required this.vote,
      required this.genres,
      required this.homepageUrl,
      required this.status,
      required this.firstAirDate,
      required this.lastAirDate,
      required this.lastEpisodeToAir,
      required this.nextEpisodeToAir,
      required this.numberOfEpisodes,
      required this.numberOfSeasons,
      required this.creators,
      required this.seasons});

  TvShowDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? 'null',
        tagLine = json['tagline'] ?? 'null',
        overview = json['overview'] ?? 'null',
        originalLanguage = json['original_language'] ?? 'null',
        originCountry = json['origin_country'][0] ?? 'null',
        posterPath = json['poster_path'] ?? 'null',
        backdropPath = json['backdrop_path'] ?? 'null',
        vote = json['vote_average'] ?? -1,
        genres = GenreModel.parseJsonArray(json['genres']),
        homepageUrl = json['homepage'] ?? 'null',
        status = json['status'] ?? 'null',
        firstAirDate = json['first_air_date'] ?? 'null',
        lastAirDate = json['last_air_date'] ?? 'null',
        lastEpisodeToAir = EpisodeModel.fromJson(json['last_episode_to_air']),
        nextEpisodeToAir = json['next_episode_to_air'] == null
            ? null
            : EpisodeModel.fromJson(json['next_episode_to_air']),
        numberOfEpisodes = json['number_of_episodes'] ?? -1,
        numberOfSeasons = json['number_of_seasons'] ?? -1,
        creators = PersonModel.parseJsonArray(json['created_by']),
        seasons = SeasonModel.parseJsonArray(json['seasons']);
}

class SeasonModel {
  final int id;
  final String name;
  final String overview;
  final double vote;
  final String airDate;
  final int seasonNumber;
  final int episodeCount;
  final String posterPath;

  SeasonModel(
      {required this.id,
      required this.name,
      required this.overview,
      required this.vote,
      required this.airDate,
      required this.seasonNumber,
      required this.episodeCount,
      required this.posterPath});

  SeasonModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? 'null',
        overview = json['overview'] ?? 'null',
        vote = json['vote_average'] ?? -1,
        airDate = json['air_date'] ?? 'null',
        seasonNumber = json['season_number'] ?? -1,
        episodeCount = json['episode_count'] ?? -1,
        posterPath = json['poster_path'] ?? 'null';

  static List<SeasonModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<SeasonModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(SeasonModel.fromJson(jsonObject));
    }
    return items.reversed.toList();
  }
}

class SeasonDetailModel {
  final int id;
  final String name;
  final String overview;
  final double vote;
  final String airDate;
  final int seasonNumber;
  final String posterPath;
  final List<EpisodeModel> episodes;

  SeasonDetailModel(
      {required this.id,
      required this.name,
      required this.overview,
      required this.vote,
      required this.airDate,
      required this.seasonNumber,
      required this.posterPath,
      required this.episodes});

  SeasonDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        overview = json['overview'],
        vote = json['vote_average'],
        airDate = json['air_date'],
        seasonNumber = json['season_number'],
        posterPath = json['poster_path'],
        episodes = EpisodeModel.parseJsonArray(json['episodes']);

  static List<SeasonDetailModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<SeasonDetailModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(SeasonDetailModel.fromJson(jsonObject));
    }
    return items;
  }
}

class EpisodeModel {
  final int id;
  final int showId;
  final String name;
  final String overview;
  final double vote;
  final String airDate;
  final int episodeNumber;
  final int seasonNumber;
  final int runtime;
  final String posterPath;
  final String stillPath;

  EpisodeModel(
      {required this.id,
      required this.showId,
      required this.name,
      required this.overview,
      required this.vote,
      required this.airDate,
      required this.episodeNumber,
      required this.seasonNumber,
      required this.runtime,
      required this.posterPath,
      required this.stillPath});

  EpisodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        showId = json['show_id'],
        name = json['name'] ?? 'null',
        overview = json['overview'] ?? 'null',
        vote = json['vote_average'] ?? -1,
        airDate = json['air_date'] ?? 'null',
        episodeNumber = json['episode_number'] ?? -1,
        seasonNumber = json['season_number'] ?? -1,
        runtime = json['runtime'] ?? -1,
        posterPath = json['poster_path'] ?? 'null',
        stillPath = json['still_path'] ?? 'null';

  static List<EpisodeModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<EpisodeModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(EpisodeModel.fromJson(jsonObject));
    }
    return items;
  }
}

// class EpisodeDetailModel {}
