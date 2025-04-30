import 'package:cinemate/data/repo/movie_repo.dart';
import 'package:cinemate/data/repo/tv_repo.dart';

import '../../utils/helpers/list_preferences.dart';
import '../../utils/web/http_client.dart';
import '../model/account_model.dart';
import '../model/list_model.dart';
import '../model/media_model.dart';
import '../model/movie_model.dart';
import '../model/tv_show_model.dart';
import '../src/list_src.dart';
import 'auth_repo.dart';

final listRepo = ListRepository(remoteSrc: ListRemoteSrc(httpClient: httpClient));

abstract class IListRepository {
  Future<ListResponseModel> getAllLists({required int page});
  Future<ListDetailModel> getListDetail(
      {required int listId, required int page, required SortMethod sortMethod});

  Future<bool> createNewList({required String name, required String desc, required bool public});
  Future<bool> editList(
      {required String name, required String desc, required bool public, required int id});
  Future<bool> deleteList({required int id});

  Future<bool> editItemInList(
      {required final ListDetailIemModel item,
      required final int listId,
      required final String newComment});

  Future<bool> deleteItemFromList({required final MediaModel media, required final int listId});

  Future<bool> addItemToList({required final MediaModel media, required final int listId});
}

class ListRepository implements IListRepository {
  final ListRemoteSrc _remoteSrc;

  ListRepository({required ListRemoteSrc remoteSrc}) : _remoteSrc = remoteSrc;

  @override
  Future<ListResponseModel> getAllLists({required int page}) async {
    final String? session = await authRepo.getSessionToken();
    final AccountAuthModel accountData = await authRepo.getAccountAuthData();

    return await _remoteSrc.getAllLists(
        accountId: accountData.accountId, page: page, session: session!);
  }

  @override
  Future<ListDetailModel> getListDetail(
      {required int listId, required int page, required SortMethod sortMethod}) async {
    final ListDetailModel result =
        await _remoteSrc.getListDetail(listId: listId, page: page, sortMethod: sortMethod);

    final List<MovieModel> newMovies = List.empty(growable: true);
    final List<TvShowModel> newShows = List.empty(growable: true);

    for (final ListDetailIemModel item in result.items) {
      if (item.media.mediaType == MediaType.movie) {
        newMovies.add(item.media as MovieModel);
      } else if (item.media.mediaType == MediaType.tv) {
        newShows.add(item.media as TvShowModel);
      }
    }
    movieRepository.updateCachedMovies(newMovies: newMovies);
    tvShowRepository.updateCachedTvShows(newShows: newShows);

    return result;
  }

  @override
  Future<bool> createNewList(
      {required String name, required String desc, required bool public}) async {
    AccountAuthModel authData = await authRepo.getAccountAuthData();
    return await _remoteSrc.createNewList(
        accessToken: authData.accessToken, name: name, desc: desc, public: public);
  }

  @override
  Future<bool> editList(
      {required String name, required String desc, required bool public, required int id}) async {
    AccountAuthModel authData = await authRepo.getAccountAuthData();
    return await _remoteSrc.editList(
        accessToken: authData.accessToken, name: name, desc: desc, public: public, id: id);
  }

  @override
  Future<bool> deleteList({required int id}) async {
    AccountAuthModel authData = await authRepo.getAccountAuthData();
    return await _remoteSrc.deleteList(accessToken: authData.accessToken, id: id);
  }

  @override
  Future<bool> editItemInList(
      {required ListDetailIemModel item, required int listId, required String newComment}) async {
    AccountAuthModel authData = await authRepo.getAccountAuthData();
    return await _remoteSrc.editItemInList(
        item: item, listId: listId, accessToken: authData.accessToken, newComment: newComment);
  }

  @override
  Future<bool> deleteItemFromList({required MediaModel media, required int listId}) async {
    AccountAuthModel authData = await authRepo.getAccountAuthData();
    return await _remoteSrc.deleteItemFromList(
        media: media, listId: listId, accessToken: authData.accessToken);
  }

  @override
  Future<bool> addItemToList({
    required MediaModel media,
    required int listId,
  }) async {
    AccountAuthModel authData = await authRepo.getAccountAuthData();
    try {
      final result = await _remoteSrc.addItemToList(
          item: ListDetailIemModel(media: media, comment: ''),
          listId: listId,
          accessToken: authData.accessToken);
      return result;
    } catch (e) {
      return false;
    }
  }
}
