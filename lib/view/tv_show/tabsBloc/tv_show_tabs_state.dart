part of 'tv_show_tabs_bloc.dart';

class TvShowTabsState extends Equatable {
  final int id;
  final List<SeasonDetailModel>? seasonsData;
  final bool isLoadingSeasons;
  final bool isSeasonsFailed;
  final CreditModel? credits;
  final bool isLoadingCredits;
  final bool isCreditsFailed;
  final List<ReviewModel>? reviews;
  final bool isLoadingReviews;
  final bool isReviewsFailed;
  final List<TvShowModel>? similarTvShows;
  final bool isLoadingSimilar;
  final bool isSimilarFailed;

  const TvShowTabsState(
      {required this.id,
      required this.seasonsData,
      required this.isLoadingSeasons,
      required this.isSeasonsFailed,
      required this.credits,
      required this.isLoadingCredits,
      required this.isCreditsFailed,
      required this.reviews,
      required this.isLoadingReviews,
      required this.isReviewsFailed,
      required this.similarTvShows,
      required this.isLoadingSimilar,
      required this.isSimilarFailed});

  @override
  List<Object?> get props => [
        id,
        seasonsData,
        isLoadingSeasons,
        isSeasonsFailed,
        credits,
        isLoadingCredits,
        isCreditsFailed,
        reviews,
        isLoadingReviews,
        isReviewsFailed,
        similarTvShows,
        isLoadingSimilar,
        isSimilarFailed,
      ];

  TvShowTabsState copyWith({
    int? id,
    List<SeasonDetailModel>? seasonsData,
    bool? isLoadingSeasons,
    bool? isSeasonsFailed,
    CreditModel? credits,
    bool? isLoadingCredits,
    bool? isCreditsFailed,
    List<ReviewModel>? reviews,
    bool? isLoadingReviews,
    bool? isReviewsFailed,
    List<TvShowModel>? similarTvShows,
    bool? isLoadingSimilar,
    bool? isSimilarFailed,
  }) {
    return TvShowTabsState(
      id: id ?? this.id,
      seasonsData: seasonsData ?? this.seasonsData,
      isLoadingSeasons: isLoadingSeasons ?? this.isLoadingSeasons,
      isSeasonsFailed: isSeasonsFailed ?? this.isSeasonsFailed,
      credits: credits ?? this.credits,
      isLoadingCredits: isLoadingCredits ?? this.isLoadingCredits,
      isCreditsFailed: isCreditsFailed ?? this.isCreditsFailed,
      reviews: reviews ?? this.reviews,
      isLoadingReviews: isLoadingReviews ?? this.isLoadingReviews,
      isReviewsFailed: isReviewsFailed ?? this.isReviewsFailed,
      similarTvShows: similarTvShows ?? this.similarTvShows,
      isLoadingSimilar: isLoadingSimilar ?? this.isLoadingSimilar,
      isSimilarFailed: isSimilarFailed ?? this.isSimilarFailed,
    );
  }
}
