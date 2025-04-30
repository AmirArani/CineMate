class GenreModel {
  final int id;
  final String name;

  GenreModel(this.id, this.name);

  GenreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  static List<GenreModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<GenreModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(GenreModel.fromJson(jsonObject));
    }
    return items;
  }
}