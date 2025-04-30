import '../../utils/web/http_client.dart';
import '../model/genre_model.dart';
import '../src/genre_src.dart';

final genreRepository = GenreRepository(GenreRemoteSrc(httpClient));

abstract class IGenreRepository {
  Future<List<GenreModel>> getPopularGenres();

  Future<List<GenreModel>> getMovieGenres();

  Future<List<GenreModel>> getTvShowGenres();
}

class GenreRepository implements IGenreRepository {
  final IGenreDataSource _dataSource;

  GenreRepository(this._dataSource);

  @override
  Future<List<GenreModel>> getPopularGenres() {
    return _dataSource.getPopularGenres();
  }

  @override
  Future<List<GenreModel>> getMovieGenres() {
    return _dataSource.getMovieGenres();
  }

  @override
  Future<List<GenreModel>> getTvShowGenres() {
    return _dataSource.getTvShowGenres();
  }
}
