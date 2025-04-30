import 'package:dio/dio.dart';

import '../../utils/helpers/list_preferences.dart';
import '../../utils/web/http_client.dart';
import '../../utils/web/urls.dart';
import '../model/list_model.dart';
import '../model/media_model.dart';

abstract class IListDataSource {
  Future<ListResponseModel> getAllLists(
      {required String accountId, required int page, required String session});
  Future<ListDetailModel> getListDetail(
      {required int listId, required int page, required SortMethod sortMethod});

  Future<bool> createNewList(
      {required String accessToken,
      required String name,
      required String desc,
      required bool public});
  Future<bool> editList(
      {required String accessToken,
      required String name,
      required String desc,
      required bool public,
      required int id});
  Future<bool> deleteList({required String accessToken, required int id});

  Future<bool> addItemToList(
      {required ListDetailIemModel item, required int listId, required String accessToken});
  Future<bool> editItemInList(
      {required final ListDetailIemModel item,
      required final int listId,
      required final String accessToken,
      required final String newComment});

  Future<bool> deleteItemFromList(
      {required final MediaModel media,
      required final int listId,
      required final String accessToken});
}

class ListRemoteSrc implements IListDataSource {
  final Dio _httpClient;

  ListRemoteSrc({required Dio httpClient}) : _httpClient = httpClient;

  @override
  Future<ListResponseModel> getAllLists(
      {required String accountId, required int page, required String session}) async {
    try {
      final response = await _httpClient.get(
        getListsURL(accountId: accountId),
        queryParameters: {'page': page},
      );
      final ListResponseModel listModel = ListResponseModel.fromJson(response.data);

      return listModel;
    } catch (e) {
      throw Exception('Getting lists failed');
    }
  }

  @override
  Future<ListDetailModel> getListDetail(
      {required int listId, required int page, required SortMethod sortMethod}) async {
    final response = await _httpClient.get(
      getListDetailURL(listId: listId),
      queryParameters: {
        'page': page,
        'sort_by': sortMethod.toServerString,
      },
    );

    final ListDetailModel listDetail = ListDetailModel.fromJson(response.data);

    return listDetail;
  }

  @override
  Future<bool> createNewList(
      {required String accessToken,
      required String name,
      required String desc,
      required bool public}) async {
    try {
      final response =
          await httpClientV4(accessToken: accessToken).post('https://api.themoviedb.org/4/list',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $accessToken',
                  'Content-Type': 'application/json',
                },
              ),
              data: {
            'name': name,
            'description': desc,
            'public': public ? 'true' : 'false',
            'iso_639_1': 'en',
          });
      final success = response.data['success'];

      return success;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> editList(
      {required String accessToken,
      required String name,
      required String desc,
      required bool public,
      required int id}) async {
    try {
      final response =
          await httpClientV4(accessToken: accessToken).put(getListDetailURL(listId: id), data: {
        'name': name,
        'description': desc,
        'public': public,
        'iso_639_1': 'en',
      });

      final success = response.data['success'];

      return success;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> deleteList({required String accessToken, required int id}) async {
    try {
      final response =
          await httpClientV4(accessToken: accessToken).delete(getListDetailURL(listId: id));

      final success = response.data['success'];

      return success;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> addItemToList(
      {required ListDetailIemModel item, required int listId, required String accessToken}) async {
    try {
      final response = await httpClientV4(accessToken: accessToken).post(
        listItemURL(listId: listId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "items": [
            {
              "media_id": getMediaId(item.media),
              "media_type": convertFromMediaType(item.media.mediaType),
            },
          ]
        },
      );

      final success = response.data['success'];
      return success;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> editItemInList(
      {required ListDetailIemModel item,
      required int listId,
      required String accessToken,
      required String newComment}) async {
    try {
      final response = await httpClientV4(accessToken: accessToken).put(listItemURL(listId: listId),
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            "items": [
              {
                "media_id": getMediaId(item.media),
                "media_type": convertFromMediaType(item.media.mediaType),
                "comment": newComment,
              },
            ]
          });

      final success = response.data['success'];

      return success;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteItemFromList(
      {required MediaModel media, required int listId, required String accessToken}) async {
    try {
      final response =
          await httpClientV4(accessToken: accessToken).delete(listItemURL(listId: listId), data: {
        "items": [
          {
            "media_id": getMediaId(media),
            "media_type": convertFromMediaType(media.mediaType),
          },
        ]
      });

      final success = response.data['success'];

      return success;
    } catch (e) {
      return false;
    }
  }
}
