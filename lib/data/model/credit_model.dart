class CastModel {
  final int id;
  final String name;
  final String profilePath;
  final String character;
  final String knownForDepartment;

  CastModel(
      {required this.id,
      required this.name,
      required this.profilePath,
      required this.character,
      required this.knownForDepartment});

  CastModel.fromJsom(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        profilePath = json['profile_path'] ?? '',
        knownForDepartment = json['known_for_department'] ?? 'null',
        character = json['character'];
}

class CrewModel {
  final int id;
  final String name;
  final String profilePath;
  final String job;
  final double popularity;
  final String knownForDepartment;

  CrewModel(
      {required this.id,
      required this.name,
      required this.profilePath,
      required this.job,
      required this.popularity,
      required this.knownForDepartment});

  CrewModel.fromJsom(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        profilePath = json['profile_path'] ?? '',
        job = json['job'],
        knownForDepartment = json['known_for_department'] ?? 'null',
        popularity = json['popularity'];
}

class CreditModel {
  final List<CastModel> cast;
  final List<CrewModel> crew;

  CreditModel({required this.cast, required this.crew});
}
