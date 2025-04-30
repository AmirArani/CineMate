import 'package:cinemate/utils/web/urls.dart';
import 'package:dio/dio.dart';

import '../model/person_model.dart';

abstract class IPersonDataSource {
  Future<List<PersonModel>> getPopularArtists({required PersonCacheSrc cache});
  Future<PersonDetailModel> getPersonDetail({required int id});
  Future<PersonMovieCreditModel> getCreditMovies({required int id});
  Future<PersonTvsShowCreditModel> getCreditTvShows({required int id});
  Future<List<String>> getImages({required int id});
}

class PersonRemoteSrc implements IPersonDataSource {
  final Dio httpClient;
  PersonRemoteSrc(this.httpClient);

  @override
  Future<List<PersonModel>> getPopularArtists({required PersonCacheSrc cache}) async {
    final response = await httpClient.get(getPopularArtistsURL);

    final List<PersonModel> popularArtists =
        PersonListResponseModel.fromJson(response.data).personList;

    cache.updateCachedPersons(popularArtists);

    return popularArtists;
  }

  @override
  Future<PersonDetailModel> getPersonDetail({required int id}) async {
    final response = await httpClient.get(getPersonDetailURL(id));
    final PersonDetailModel detail;

    detail = PersonDetailModel.fromJson(response.data);

    return detail;
  }

  @override
  Future<List<String>> getImages({required int id}) async {
    final response = await httpClient.get(getPersonImagesURL(id));
    final List<String> images = [];

    for (var image in (response.data['profiles'])) {
      images.add(image['file_path']);
      if (images.length == 25) break;
    }

    return images;
  }

  @override
  Future<PersonMovieCreditModel> getCreditMovies({required int id}) async {
    final response = await httpClient.get(getPersonMoviesURL(id));

    final PersonMovieCreditModel movieCredits = PersonMovieCreditModel.fromJson(response.data);

    return movieCredits;
  }

  @override
  Future<PersonTvsShowCreditModel> getCreditTvShows({required int id}) async {
    final response = await httpClient.get(getPersonTvShowsURL(id));

    final PersonTvsShowCreditModel showCredits = PersonTvsShowCreditModel.fromJson(response.data);

    return showCredits;
  }
}

class PersonCacheSrc {
  final Map<int, PersonModel> personCache = {};

  void updateCachedPersons(List<PersonModel> newPersons) {
    for (final newPerson in newPersons) {
      personCache[newPerson.id] = newPerson;
    }
  }

  PersonModel? getPersonById(int personId) {
    return personCache[personId];
  }
}
