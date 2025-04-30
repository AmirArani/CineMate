import '../../utils/web/http_client.dart';
import '../model/media_model.dart';
import '../model/movie_model.dart';
import '../model/person_model.dart';
import '../model/tv_show_model.dart';
import '../src/person_src.dart';
import 'movie_repo.dart';
import 'tv_repo.dart';

final personRepository = PersonRepository(PersonRemoteSrc(httpClient), PersonCacheSrc());

abstract class IPersonRepository {
  Future<List<PersonModel>> getPopularArtists();
  Future<PersonDetailModel> getPersonDetail({required int id});
  Future<PersonMovieCreditModel> getCreditMovies({required int id});
  Future<PersonTvsShowCreditModel> getCreditTvShows({required int id});
  Future<List<String>> getImages({required int id});
  PersonModel? getPersonById({required int id});
  void updateCachedPersons({required List<PersonModel> newPersons});
}

class PersonRepository implements IPersonRepository {
  final IPersonDataSource _remoteSrc;
  final PersonCacheSrc _cacheSrc;

  PersonRepository(this._remoteSrc, this._cacheSrc);

  @override
  Future<List<PersonModel>> getPopularArtists() async {
    List<PersonModel> popularArtists = await _remoteSrc.getPopularArtists(cache: _cacheSrc);

    _cacheSrc.updateCachedPersons(popularArtists);

    for (PersonModel person in popularArtists) {
      if (person.knownFor != null) {
        for (MediaModel item in person.knownFor!) {
          if (item.mediaType == MediaType.movie && item.movie != null) {
            MovieModel newMovie = item.movie!;
            movieRepository.updateCachedMovies(newMovies: [newMovie]);
          } else if (item.mediaType == MediaType.tv && item.show != null) {
            TvShowModel newShow = item.show!;
            tvShowRepository.updateCachedTvShows(newShows: [newShow]);
          } else {
            Exception('Unknown media type');
          }
        }
      }
    }

    return popularArtists;
  }

  @override
  Future<PersonDetailModel> getPersonDetail({required int id}) {
    return _remoteSrc.getPersonDetail(id: id);
  }

  @override
  Future<List<String>> getImages({required int id}) {
    return _remoteSrc.getImages(id: id);
  }

  @override
  Future<PersonMovieCreditModel> getCreditMovies({required int id}) async {
    PersonMovieCreditModel movieCredits = await _remoteSrc.getCreditMovies(id: id);

    movieRepository.updateCachedMovies(newMovies: movieCredits.cast.map((e) => e.movie).toList());

    return movieCredits;
  }

  @override
  PersonModel? getPersonById({required int id}) => _cacheSrc.getPersonById(id);

  @override
  Future<PersonTvsShowCreditModel> getCreditTvShows({required int id}) async {
    PersonTvsShowCreditModel showCredits = await _remoteSrc.getCreditTvShows(id: id);

    tvShowRepository.updateCachedTvShows(newShows: showCredits.cast.map((e) => e.show).toList());

    return showCredits;
  }

  @override
  void updateCachedPersons({required List<PersonModel> newPersons}) =>
      _cacheSrc.updateCachedPersons(newPersons);
}
