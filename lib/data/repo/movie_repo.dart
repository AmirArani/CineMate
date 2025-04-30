import '../../utils/web/http_client.dart';
import '../model/account_state_model.dart';
import '../model/credit_model.dart';
import '../model/movie_model.dart';
import '../model/person_model.dart';
import '../model/review_model.dart';
import '../src/movie_src.dart';
import 'person_repo.dart';

final movieRepository = MovieRepository(MovieRemoteSrc(httpClient), MovieCacheSrc());

abstract class IMovieRepository {
  Future<List<MovieModel>> getPopularMovies();
  Future<MovieDetailModel> getMovieDetail({required int id});
  Future<List<String>> getMovieImages({required int id});
  Future<CreditModel> getMovieCastAndCrew({required int id});
  Future<List<ReviewModel>> getMovieReviews({required int id});
  Future<List<MovieModel>> getSimilarMovies({required int id});
  MovieModel? getMovieById({required int id});
  void updateCachedMovies({required List<MovieModel> newMovies});

  Future<AccountStateModel> getAccountState({required int id});
}

class MovieRepository implements IMovieRepository {
  final IMovieDataSource _remoteSrc;
  final MovieCacheSrc _cacheSrc;

  MovieRepository(this._remoteSrc, this._cacheSrc);

  @override
  Future<List<MovieModel>> getPopularMovies() {
    return _remoteSrc.getPopularMovies(cache: _cacheSrc);
  }

  @override
  Future<MovieDetailModel> getMovieDetail({required int id}) {
    return _remoteSrc.getMovieDetail(id: id);
  }

  @override
  Future<List<String>> getMovieImages({required int id}) {
    return _remoteSrc.getMovieImages(id: id);
  }

  @override
  Future<CreditModel> getMovieCastAndCrew({required int id}) async {
    final CreditModel credit = await _remoteSrc.getMovieCastAndCrew(id: id);
    final List<PersonModel> newPersons = List.empty(growable: true);

    for (CastModel cast in credit.cast) {
      newPersons.add(PersonModel(
          id: cast.id,
          name: cast.name,
          gender: Gender.notSet,
          profilePath: cast.profilePath,
          knownForDepartment: cast.knownForDepartment,
          knownFor: null));
    }
    for (CrewModel cast in credit.crew) {
      newPersons.add(PersonModel(
          id: cast.id,
          name: cast.name,
          gender: Gender.notSet,
          profilePath: cast.profilePath,
          knownForDepartment: cast.knownForDepartment,
          knownFor: null));
    }

    personRepository.updateCachedPersons(newPersons: newPersons);

    return credit;
  }

  @override
  Future<List<ReviewModel>> getMovieReviews({required int id}) {
    return _remoteSrc.getMovieReviews(id: id);
  }

  @override
  Future<List<MovieModel>> getSimilarMovies({required int id}) {
    return _remoteSrc.getSimilarMovies(id: id, cache: _cacheSrc);
  }

  @override
  MovieModel? getMovieById({required int id}) => _cacheSrc.getMovieById(id);

  @override
  void updateCachedMovies({required List<MovieModel> newMovies}) =>
      _cacheSrc.updateCachedMovies(newMovies);

  @override
  Future<AccountStateModel> getAccountState({required int id}) =>
      _remoteSrc.getAccountState(id: id);
}
