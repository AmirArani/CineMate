import 'package:intl/intl.dart';

import 'media_model.dart';

DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss 'UTC'");

class ListModel {
  final int id;
  final int itemCount;
  final String name;
  final String desc;
  final String backdropPath;
  final double averageRating;
  final bool public;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListModel(
      {required this.id,
      required this.itemCount,
      required this.name,
      required this.desc,
      required this.averageRating,
      required this.backdropPath,
      required this.public,
      required this.createdAt,
      required this.updatedAt});

  ListModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        itemCount = json['number_of_items'],
        name = json['name'],
        desc = json['description'],
        averageRating = json['average_rating'],
        backdropPath = json['backdrop_path'] ?? '',
        public = json['public'] == 1 ? true : false,
        createdAt = format.parseUTC(json['created_at']),
        updatedAt = format.parseUTC(json['updated_at']);

  static List<ListModel> parseJsonArray(List<dynamic> jsonArray) {
    final List<ListModel> items = List.empty(growable: true);
    for (var jsonObject in jsonArray) {
      items.add(ListModel.fromJson(jsonObject));
    }
    return items;
  }
}

class ListResponseModel {
  final int page;
  final List<ListModel> lists;
  final int totalPages;
  final int totalResults;

  ListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        lists = ListModel.parseJsonArray(json['results']),
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}

class ListDetailModel {
  final ListModel listData;
  final List<ListDetailIemModel> items;
  final String createdBy;
  final int page;
  final int totalPages;
  final int totalResults;

  ListDetailModel(
      {required this.listData,
      required this.items,
      required this.createdBy,
      required this.page,
      required this.totalPages,
      required this.totalResults});

  ListDetailModel.fromJson(Map<String, dynamic> json)
      : listData = ListModel(
          id: json['id'],
          itemCount: json['item_count'],
          name: json['name'],
          desc: json['description'],
          averageRating: json['average_rating'],
          backdropPath: json['backdrop_path'] ?? '',
          public: json['public'],
          createdAt: DateTime.now(),
          //todo: wrong!
          updatedAt: DateTime.now(),
        ),
        items = List.generate(json['item_count'],
            (index) => ListDetailIemModel.fromJson(json['results'][index], json['comments'])),
        createdBy = json['created_by']['name'] ?? '',
        page = json['page'],
        totalPages = json['total_pages'],
        totalResults = json['total_results'];
}

class ListDetailIemModel {
  final MediaModel media;
  final String? comment;

  ListDetailIemModel({required this.media, required this.comment});

  factory ListDetailIemModel.fromJson(
      Map<String, dynamic> mediaJson, Map<String, dynamic> comments) {
    final mediaType = mediaJson['media_type'];
    final mediaId = mediaJson['id'].toString();
    final commentKey = '$mediaType:$mediaId';

    return ListDetailIemModel(
      media: MediaModel.fromJson(mediaJson),
      comment: comments[commentKey],
    );
  }
}
