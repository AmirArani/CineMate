class CompanyModel {
  final int id;
  final String name;
  final String? logoPath;
  final String originCountry;

  CompanyModel({
    required this.id,
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  CompanyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        logoPath = json['logo_path'],
        originCountry = json['origin_country'];

  static List<CompanyModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<CompanyModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(CompanyModel.fromJson(jsonObject));
    }
    return items;
  }
}

class CompanyListResponseModel {
  final int page;
  final List<CompanyModel> companies;
  final int totalPages;
  final int totalResults;

  CompanyListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        companies = CompanyModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}
