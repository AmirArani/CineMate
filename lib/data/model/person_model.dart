import 'media_model.dart';
import 'movie_model.dart';
import 'tv_show_model.dart';

class PersonModel {
  final int id;
  final String name;
  final Gender gender;
  final String? profilePath;
  final String knownForDepartment;
  final List<MediaModel>? knownFor;

  PersonModel(
      {required this.id,
      required this.name,
      required this.gender,
      required this.profilePath,
      required this.knownForDepartment,
      required this.knownFor});

  PersonModel copyWith({
    int? id,
    String? name,
    Gender? gender,
    String? profilePath,
    String? knownForDepartment,
    List<MediaModel>? knownFor,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      profilePath: profilePath ?? this.profilePath,
      knownForDepartment: knownForDepartment ?? this.knownForDepartment,
      knownFor: knownFor ?? this.knownFor,
    );
  }

  PersonModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        gender = convertToGender(json['gender']),
        profilePath = json['profile_path'],
        knownForDepartment = json['known_for_department'] ?? 'null',
        knownFor = json['known_for'] == null ? null : MediaModel.parseJsonArray(json['known_for']);

  static List<PersonModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<PersonModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(PersonModel.fromJson(jsonObject));
    }
    return items;
  }
}

class PersonListResponseModel {
  final int page;
  final List<PersonModel> personList;
  final int totalPages;
  final int totalResults;

  PersonListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        personList = PersonModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}

class PersonDetailModel {
  final int id;
  final String name;
  final Gender gender;
  final String? profilePath;
  final double popularity;
  final String knownForDepartment;
  final List<String> alsoKnownAs;
  final String biography;
  final String birthday;
  final String? deathday;
  final String homepageUrl;
  final String imdbId;
  final String placeOfBirth;

  PersonDetailModel(
      {required this.id,
      required this.name,
      required this.gender,
      required this.profilePath,
      required this.popularity,
      required this.knownForDepartment,
      required this.alsoKnownAs,
      required this.biography,
      required this.birthday,
      required this.deathday,
      required this.homepageUrl,
      required this.imdbId,
      required this.placeOfBirth});

  PersonDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        gender = convertToGender(json['gender']),
        profilePath = json['profile_path'],
        popularity = json['popularity'] ?? -1,
        knownForDepartment = json['known_for_department'] ?? 'null',
        alsoKnownAs = parseJsonStringArray(json['also_known_as']),
        biography = json['biography'] ?? 'null',
        birthday = json['birthday'] ?? 'null',
        deathday = json['deathday'] ?? 'null',
        homepageUrl = json['homepage'] ?? 'null',
        imdbId = json['imdb_id'] ?? '',
        placeOfBirth = json['place_of_birth'] ?? 'null';
}

class PersonTvsShowCreditModel {
  final List<PersonTvShowCastItemModel> cast;
  final List<PersonTvShowCrewItemModel> crew;

  PersonTvsShowCreditModel({required this.cast, required this.crew});

  PersonTvsShowCreditModel.fromJson(Map<String, dynamic> json)
      : cast = PersonTvShowCastItemModel.parseJsonArray(json['cast']),
        crew = PersonTvShowCrewItemModel.parseJsonArray(json['crew']);
}

class PersonMovieCreditModel {
  final List<PersonMovieCastItemModel> cast;
  final List<PersonMovieCrewItemModel> crew;

  PersonMovieCreditModel({required this.cast, required this.crew});

  PersonMovieCreditModel.fromJson(Map<String, dynamic> json)
      : cast = PersonMovieCastItemModel.parseJsonArray(json['cast']),
        crew = PersonMovieCrewItemModel.parseJsonArray(json['crew']);
}

class PersonTvShowCastItemModel {
  final TvShowModel show;
  final double popularity;
  final String character;

  PersonTvShowCastItemModel.fromJson(Map<String, dynamic> json)
      : show = TvShowModel(
            id: json['id'],
            title: json['name'],
            overview: json['overview'],
            originalLanguage: json['original_language'] ?? 'null',
            originCountry: parseOriginCountry(json['origin_country']),
            posterPath: json['poster_path'] ?? 'null',
            backdropPath: json['backdrop_path'] ?? 'null',
            releaseDate: json['first_air_date'] ?? 'null',
            vote: json['vote_average'] ?? -1),
        popularity = json['popularity'] ?? -1,
        character = json['character'] ?? 'null';

  static List<PersonTvShowCastItemModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<PersonTvShowCastItemModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(PersonTvShowCastItemModel.fromJson(jsonObject));
    }
    return items;
  }
}

class PersonTvShowCrewItemModel {
  final TvShowModel show;
  final double popularity;
  final String job;
  final String department;

  PersonTvShowCrewItemModel.fromJson(Map<String, dynamic> json)
      : show = TvShowModel(
            id: json['id'],
            title: json['name'],
            overview: json['overview'],
            originalLanguage: json['original_language'] ?? 'null',
            originCountry: parseOriginCountry(json['origin_country']),
            posterPath: json['poster_path'] ?? 'null',
            backdropPath: json['backdrop_path'] ?? 'null',
            releaseDate: json['first_air_date'] ?? 'null',
            vote: json['vote_average'] ?? -1),
        popularity = json['popularity'] ?? -1,
        job = json['job'] ?? 'null',
        department = json['department'] ?? 'null';

  static List<PersonTvShowCrewItemModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<PersonTvShowCrewItemModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(PersonTvShowCrewItemModel.fromJson(jsonObject));
    }
    return items;
  }
}

class PersonMovieCastItemModel {
  final MovieModel movie;
  final double popularity;
  final String character;

  PersonMovieCastItemModel.fromJson(Map<String, dynamic> json)
      : movie = MovieModel(
            id: json['id'],
            title: json['title'] ?? 'null',
            overview: json['overview'] ?? 'null',
            originalLanguage: json['original_language'] ?? 'null',
            posterPath: json['poster_path'] ?? 'null',
            backdropPath: json['backdrop_path'] ?? 'null',
            releaseDate: json['first_air_date'] ?? 'null',
            vote: json['vote_average'] ?? -1),
        popularity = json['popularity'] ?? -1,
        character = json['character'] ?? 'null';

  static List<PersonMovieCastItemModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<PersonMovieCastItemModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(PersonMovieCastItemModel.fromJson(jsonObject));
    }
    return items;
  }
}

class PersonMovieCrewItemModel {
  final MovieModel movie;
  final double popularity;
  final String job;
  final String department;

  PersonMovieCrewItemModel.fromJson(Map<String, dynamic> json)
      : movie = MovieModel(
            id: json['id'],
            title: json['title'],
            overview: json['overview'],
            originalLanguage: json['original_language'] ?? 'null',
            posterPath: json['poster_path'] ?? 'null',
            backdropPath: json['backdrop_path'] ?? 'null',
            releaseDate: json['first_air_date'] ?? 'null',
            vote: json['vote_average'] ?? -1),
        popularity = json['popularity'],
        job = json['job'] ?? 'null',
        department = json['department'] ?? 'null';

  static List<PersonMovieCrewItemModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<PersonMovieCrewItemModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(PersonMovieCrewItemModel.fromJson(jsonObject));
    }
    return items;
  }
}

enum Gender { notSet, male, female, nonBinary }

Gender convertToGender(int gender) {
  switch (gender) {
    case 0:
      return Gender.notSet;
    case 1:
      return Gender.female;
    case 2:
      return Gender.male;
    case 3:
      return Gender.nonBinary;
    default:
      return Gender.nonBinary;
  }
}

extension GenderExtension on Gender {
  String toHumanString() {
    switch (this) {
      case Gender.notSet:
        return 'Not Set';
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.nonBinary:
        return 'Non-Binary';
    }
  }
}

List<String> parseJsonStringArray(List<dynamic> jsonArray) {
  final List<String> items = List.empty(growable: true);
  for (var jsonObject in jsonArray) {
    items.add(jsonObject);
  }
  return items;
}

String parseOriginCountry(dynamic originCountryJson) {
  if (originCountryJson is List && originCountryJson.isNotEmpty) {
    return originCountryJson[0]
        .toString(); // Safely access first element if list is not empty and convert to String
  } else {
    return 'N/A'; // Default value if originCountry is not a list or is empty
  }
}
