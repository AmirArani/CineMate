import 'package:equatable/equatable.dart';

class DiscoverMovieParams extends Equatable {
  final String? sortBy;
  final String? withGenres;
  final String? withoutGenres;
  final String? withKeywords;
  final String? withoutKeywords;
  final String? withCompanies;
  final String? withPeople;
  final String? withCast;
  final String? withCrew;
  final String? withWatchProviders;
  final String? withOriginalLanguage;
  final String? withReleaseType;
  final String? region;
  final String? certificationCountry;
  final String? certification;
  final String? certificationLte;
  final String? certificationGte;
  final String? includeAdult;
  final String? includeVideo;
  final String? primaryReleaseYear;
  final String? primaryReleaseDateGte;
  final String? primaryReleaseDateLte;
  final String? releaseDateGte;
  final String? releaseDateLte;
  final num? voteAverageGte;
  final num? voteAverageLte;
  final int? voteCountGte;
  final int? voteCountLte;
  final num? withRuntimeGte;
  final num? withRuntimeLte;

  const DiscoverMovieParams({
    this.sortBy,
    this.withGenres,
    this.withoutGenres,
    this.withKeywords,
    this.withoutKeywords,
    this.withCompanies,
    this.withPeople,
    this.withCast,
    this.withCrew,
    this.withWatchProviders,
    this.withOriginalLanguage,
    this.withReleaseType,
    this.region,
    this.certificationCountry,
    this.certification,
    this.certificationLte,
    this.certificationGte,
    this.includeAdult,
    this.includeVideo,
    this.primaryReleaseYear,
    this.primaryReleaseDateGte,
    this.primaryReleaseDateLte,
    this.releaseDateGte,
    this.releaseDateLte,
    this.voteAverageGte,
    this.voteAverageLte,
    this.voteCountGte,
    this.voteCountLte,
    this.withRuntimeGte,
    this.withRuntimeLte,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (sortBy != null) map['sort_by'] = sortBy;
    if (withGenres != null) map['with_genres'] = withGenres;
    if (withoutGenres != null) map['without_genres'] = withoutGenres;
    if (withKeywords != null) map['with_keywords'] = withKeywords;
    if (withoutKeywords != null) map['without_keywords'] = withoutKeywords;
    if (withCompanies != null) map['with_companies'] = withCompanies;
    if (withPeople != null) map['with_people'] = withPeople;
    if (withCast != null) map['with_cast'] = withCast;
    if (withCrew != null) map['with_crew'] = withCrew;
    if (withWatchProviders != null) map['with_watch_providers'] = withWatchProviders;
    if (withOriginalLanguage != null) map['with_original_language'] = withOriginalLanguage;
    if (withReleaseType != null) map['with_release_type'] = withReleaseType;
    if (region != null) map['region'] = region;
    if (certificationCountry != null) map['certification_country'] = certificationCountry;
    if (certification != null) map['certification'] = certification;
    if (certificationLte != null) map['certification.lte'] = certificationLte;
    if (certificationGte != null) map['certification.gte'] = certificationGte;
    if (includeAdult != null) map['include_adult'] = includeAdult;
    if (includeVideo != null) map['include_video'] = includeVideo;
    if (primaryReleaseYear != null) map['primary_release_year'] = primaryReleaseYear;
    if (primaryReleaseDateGte != null) map['primary_release_date.gte'] = primaryReleaseDateGte;
    if (primaryReleaseDateLte != null) map['primary_release_date.lte'] = primaryReleaseDateLte;
    if (releaseDateGte != null) map['release_date.gte'] = releaseDateGte;
    if (releaseDateLte != null) map['release_date.lte'] = releaseDateLte;
    if (voteAverageGte != null) map['vote_average.gte'] = voteAverageGte;
    if (voteAverageLte != null) map['vote_average.lte'] = voteAverageLte;
    if (voteCountGte != null) map['vote_count.gte'] = voteCountGte;
    if (voteCountLte != null) map['vote_count.lte'] = voteCountLte;
    if (withRuntimeGte != null) map['with_runtime.gte'] = withRuntimeGte;
    if (withRuntimeLte != null) map['with_runtime.lte'] = withRuntimeLte;
    return map;
  }

  @override
  List<Object?> get props => [
        sortBy,
        withGenres,
        withoutGenres,
        withKeywords,
        withoutKeywords,
        withCompanies,
        withPeople,
        withCast,
        withCrew,
        withWatchProviders,
        withOriginalLanguage,
        withReleaseType,
        region,
        certificationCountry,
        certification,
        certificationLte,
        certificationGte,
        includeAdult,
        includeVideo,
        primaryReleaseYear,
        primaryReleaseDateGte,
        primaryReleaseDateLte,
        releaseDateGte,
        releaseDateLte,
        voteAverageGte,
        voteAverageLte,
        voteCountGte,
        voteCountLte,
        withRuntimeGte,
        withRuntimeLte,
      ];
}

class DiscoverTvParams extends Equatable {
  final String? sortBy;
  final String? airDateGte;
  final String? airDateLte;
  final String? firstAirDateGte;
  final String? firstAirDateLte;
  final String? firstAirDateYear;
  final String? withGenres;
  final String? withoutGenres;
  final String? withKeywords;
  final String? withoutKeywords;
  final String? withCompanies;
  final String? withWatchProviders;
  final String? withOriginalLanguage;
  final String? withStatus;
  final String? withType;
  final String? screenedTheatrically;
  final String? timezone;
  final num? voteAverageGte;
  final num? voteAverageLte;
  final int? voteCountGte;
  final int? voteCountLte;
  final num? withRuntimeGte;
  final num? withRuntimeLte;
  final int? includeNullFirstAirDates;

  const DiscoverTvParams({
    this.sortBy,
    this.airDateGte,
    this.airDateLte,
    this.firstAirDateGte,
    this.firstAirDateLte,
    this.firstAirDateYear,
    this.withGenres,
    this.withoutGenres,
    this.withKeywords,
    this.withoutKeywords,
    this.withCompanies,
    this.withWatchProviders,
    this.withOriginalLanguage,
    this.withStatus,
    this.withType,
    this.screenedTheatrically,
    this.timezone,
    this.voteAverageGte,
    this.voteAverageLte,
    this.voteCountGte,
    this.voteCountLte,
    this.withRuntimeGte,
    this.withRuntimeLte,
    this.includeNullFirstAirDates,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (sortBy != null) map['sort_by'] = sortBy;
    if (airDateGte != null) map['air_date.gte'] = airDateGte;
    if (airDateLte != null) map['air_date.lte'] = airDateLte;
    if (firstAirDateGte != null) map['first_air_date.gte'] = firstAirDateGte;
    if (firstAirDateLte != null) map['first_air_date.lte'] = firstAirDateLte;
    if (firstAirDateYear != null) map['first_air_date_year'] = firstAirDateYear;
    if (withGenres != null) map['with_genres'] = withGenres;
    if (withoutGenres != null) map['without_genres'] = withoutGenres;
    if (withKeywords != null) map['with_keywords'] = withKeywords;
    if (withoutKeywords != null) map['without_keywords'] = withoutKeywords;
    if (withCompanies != null) map['with_companies'] = withCompanies;
    if (withWatchProviders != null) map['with_watch_providers'] = withWatchProviders;
    if (withOriginalLanguage != null) map['with_original_language'] = withOriginalLanguage;
    if (withStatus != null) map['with_status'] = withStatus;
    if (withType != null) map['with_type'] = withType;
    if (screenedTheatrically != null) map['screened_theatrically'] = screenedTheatrically;
    if (timezone != null) map['timezone'] = timezone;
    if (voteAverageGte != null) map['vote_average.gte'] = voteAverageGte;
    if (voteAverageLte != null) map['vote_average.lte'] = voteAverageLte;
    if (voteCountGte != null) map['vote_count.gte'] = voteCountGte;
    if (voteCountLte != null) map['vote_count.lte'] = voteCountLte;
    if (withRuntimeGte != null) map['with_runtime.gte'] = withRuntimeGte;
    if (withRuntimeLte != null) map['with_runtime.lte'] = withRuntimeLte;
    if (includeNullFirstAirDates != null) {
      map['include_null_first_air_dates'] = includeNullFirstAirDates;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        sortBy,
        airDateGte,
        airDateLte,
        firstAirDateGte,
        firstAirDateLte,
        firstAirDateYear,
        withGenres,
        withoutGenres,
        withKeywords,
        withoutKeywords,
        withCompanies,
        withWatchProviders,
        withOriginalLanguage,
        withStatus,
        withType,
        screenedTheatrically,
        timezone,
        voteAverageGte,
        voteAverageLte,
        voteCountGte,
        voteCountLte,
        withRuntimeGte,
        withRuntimeLte,
        includeNullFirstAirDates,
      ];
}

// Constants for sort options
class DiscoverSortOptions {
  static const popularityAsc = 'popularity.asc';
  static const popularityDesc = 'popularity.desc';
  static const revenueAsc = 'revenue.asc';
  static const revenueDesc = 'revenue.desc';
  static const primaryReleaseDateAsc = 'primary_release_date.asc';
  static const primaryReleaseDateDesc = 'primary_release_date.desc';
  static const voteAverageAsc = 'vote_average.asc';
  static const voteAverageDesc = 'vote_average.desc';
  static const voteCountAsc = 'vote_count.asc';
  static const voteCountDesc = 'vote_count.desc';
}

// Constants for TV show status
class TvShowStatus {
  static const returning = '0';
  static const planned = '1';
  static const inProduction = '2';
  static const ended = '3';
  static const cancelled = '4';
  static const pilot = '5';
}

// Constants for TV show types
class TvShowType {
  static const documentary = '0';
  static const news = '1';
  static const miniseries = '2';
  static const reality = '3';
  static const scripted = '4';
  static const talkShow = '5';
  static const video = '6';
}
