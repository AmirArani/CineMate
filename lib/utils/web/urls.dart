const String callbackPath = 'cinemate://login-callback';
const int dramaGenreId = 18;

const String getRequestTokenURL = '4/auth/request_token';
const String getAccessTokenURL = '4/auth/access_token';
const String getNewSessionURL = '3/authentication/session/convert/4';
const String deleteSessionURL = '3/authentication/session';

const String getAccountDetail = '3/account';
String getFavoriteMoviesURL({required int accountId}) => '3/account/$accountId/favorite/movies';
String getFavoriteShowsURL({required int accountId}) => '3/account/$accountId/favorite/tv';
String editMediaFavoriteURL({required int accountId}) => '3/account/$accountId/favorite';
String getWatchListMoviesURL({required int accountId}) => '3/account/$accountId/watchlist/movies';
String getWatchListShowsURL({required int accountId}) => '3/account/$accountId/watchlist/tv';
String editMediaWatchlistURL({required int accountId}) => '3/account/$accountId/watchlist';
String getRatedMoviesURL({required int accountId}) => '3/account/$accountId/rated/movies';
String getRatedShowsURL({required int accountId}) => '3/account/$accountId/rated/tv';
String editMovieRatingURL({required int movieId}) => '3/movie/$movieId/rating';
String editShowRatingURL({required int showId}) => '3/tv/$showId/rating';

String getListsURL({required String accountId}) => '4/account/$accountId/lists';
String getListDetailURL({required int listId}) => '4/list/$listId';
String listItemURL({required int listId}) => '4/list/$listId/items';
const String createListURL = '4/list';

const String getPopularGenresURL = '3/genre/movie/list';
const String getMovieGenresURL = '3/genre/movie/list';
const String getTvShowGenresURL = '3/genre/tv/list';

String getMovieDetailsURL(int id) => '3/movie/$id';
const String getPopularMoviesURL = '3/movie/popular';
String getMovieImagesURL(int id) => '3/movie/$id/images';
String getMovieCastAndCrewURL(int id) => '3/movie/$id/credits';
String getMovieReviewsURL(int id) => '3/movie/$id/reviews';
String getSimilarMoviesURL(int id) => '3/movie/$id/similar';
String getMovieAccountStateURL(int id) => '3/movie/$id/account_states';

String getTvShowDetailsURL(int id) => '3/tv/$id';
const String getAiringTodayShowsURL = '3/tv/airing_today';
const String getTopShowsURL = '3/tv/top_rated';
String getTvShowImagesURL(int id) => '3/tv/$id/images';
String getTvShowSeasonsAndEpisodes({required int seriesId, required int seasonNumber}) =>
    '3/tv/$seriesId/season/$seasonNumber';
String getTvShowCastAndCrewURL(int id) => '3/tv/$id/credits';
String getTvShowReviewsURL(int id) => '3/tv/$id/reviews';
String getSimilarTvShowsURL(int id) => '3/tv/$id/similar';
String getTvShowAccountStateURL(int id) => '3/tv/$id/account_states';

String getPersonDetailURL(int id) => '3/person/$id';
const String getPopularArtistsURL = '3/person/popular';
String getPersonMoviesURL(int id) => '3/person/$id/movie_credits';
String getPersonTvShowsURL(int id) => '3/person/$id/tv_credits';
String getPersonImagesURL(int id) => '3/person/$id/images';

const String searchMultiURL = '3/search/multi';
const String searchMoviesURL = '3/search/movie';
const String searchShowsURL = '3/search/tv';
const String searchPersonsURL = '3/search/person';
const String searchKeywordsURL = '3/search/keyword';
const String searchCompaniesURL = '3/search/company';

const String discoverMoviesURL = '3/discover/movie';
const String discoverTvShowsURL = '3/discover/tv';

String getRecommendedMoviesURL({required String accountId}) =>
    '4/account/$accountId/movie/recommendations';

String getRecommendedTvShowsURL({required String accountId}) =>
    '4/account/$accountId/tv/recommendations';
