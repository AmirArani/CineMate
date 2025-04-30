class AccountAuthModel {
  final String accessToken;
  final String accountId;

  AccountAuthModel({required this.accessToken, required this.accountId});
}

class AccountModel {
  final int id;
  final String? name;
  final String userName;
  final String? avatarPath;
  final String? gravatarHash;
  final String? language;
  final String? country;

  AccountModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.avatarPath,
    required this.gravatarHash,
    required this.language,
    required this.country,
  });

  AccountModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        userName = json['username'],
        avatarPath = json['avatar']['tmdb']['avatar_path'],
        gravatarHash = json['avatar']['gravatar']['hash'],
        language = json['iso_639_1'],
        country = json['iso_3166_1'];
}
