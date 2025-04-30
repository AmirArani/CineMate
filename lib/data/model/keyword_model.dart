class KeywordModel {
  final int id;
  final String name;

  KeywordModel({required this.id, required this.name});

  KeywordModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  static List<KeywordModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<KeywordModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(KeywordModel.fromJson(jsonObject));
    }
    return items;
  }
}

class KeywordListResponseModel {
  final int page;
  final List<KeywordModel> keywords;
  final int totalPages;
  final int totalResults;

  KeywordListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        keywords = KeywordModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}
