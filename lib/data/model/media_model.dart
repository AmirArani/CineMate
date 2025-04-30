import 'movie_model.dart';
import 'person_model.dart';
import 'tv_show_model.dart';

class MediaModel {
  final MediaType mediaType;
  final MovieModel? movie;
  final TvShowModel? show;
  final PersonModel? person;

  MediaModel({required this.mediaType, this.movie, this.show, this.person});

  MediaModel.fromJson(Map<String, dynamic> json)
      : mediaType = convertToMediaType(json['media_type']),
        movie = json['media_type'] == 'movie' ? MovieModel.fromJson(json) : null,
        show = json['media_type'] == 'tv' ? TvShowModel.fromJson(json) : null,
        person = json['media_type'] == 'person' ? PersonModel.fromJson(json) : null;

  static List<MediaModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<MediaModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(MediaModel.fromJson(jsonObject));
    }
    return items;
  }
}

class MediaListResponseModel {
  final List<MediaModel> results;
  final int totalResults;
  final int totalPages;
  final int page;

  MediaListResponseModel(
      {required this.results,
      required this.totalResults,
      required this.totalPages,
      required this.page});

  MediaListResponseModel.fromJson(Map<String, dynamic> json)
      : results = MediaModel.parseJsonArray(json['results']),
        totalResults = json['total_results'],
        totalPages = json['total_pages'],
        page = json['page'];
}

enum MediaType { movie, tv, person, notSet }

MediaType convertToMediaType(String type) {
  switch (type) {
    case 'movie':
      return MediaType.movie;
    case 'tv':
      return MediaType.tv;
    case 'person':
      return MediaType.person;
    default:
      return MediaType.notSet;
  }
}

String convertFromMediaType(MediaType type) {
  switch (type) {
    case MediaType.movie:
      return 'movie';
    case MediaType.tv:
      return 'tv';
    case MediaType.person:
      return 'person';
    case MediaType.notSet:
      return 'not_set';
  }
}

int? getMediaId(MediaModel media) {
  if (media.movie != null) {
    return media.movie!.id;
  } else if (media.show != null) {
    return media.show!.id;
  } else if (media.person != null) {
    return media.person!.id;
  } else {
    return null;
  }
}
