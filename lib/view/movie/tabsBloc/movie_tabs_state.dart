part of 'movie_tabs_bloc.dart';

class MovieTabsState extends Equatable {
  final int id;
  final CreditModel? credits;
  final bool isLoadingCredits;
  final bool isCreditsFailed;
  final List<ReviewModel>? reviews;
  final bool isLoadingReviews;
  final bool isReviewsFailed;
  final List<MovieModel>? similarMovies;
  final bool isLoadingSimilar;
  final bool isSimilarFailed;

  const MovieTabsState(
      {required this.id,
      required this.credits,
      required this.isLoadingCredits,
      required this.isCreditsFailed,
      required this.reviews,
      required this.isLoadingReviews,
      required this.isReviewsFailed,
      required this.similarMovies,
      required this.isLoadingSimilar,
      required this.isSimilarFailed});

  @override
  List<Object?> get props => [
        id,
        credits,
        isLoadingCredits,
        isCreditsFailed,
        reviews,
        isLoadingReviews,
        isReviewsFailed,
        similarMovies,
        isLoadingSimilar,
        isSimilarFailed
      ];

  MovieTabsState copyWith({
    int? id,
    CreditModel? credits,
    bool? isLoadingCredits,
    bool? isCreditsFailed,
    List<ReviewModel>? reviews,
    bool? isLoadingReviews,
    bool? isReviewsFailed,
    List<MovieModel>? similarMovies,
    bool? isLoadingSimilar,
    bool? isSimilarFailed,
  }) {
    return MovieTabsState(
      id: id ?? this.id,
      credits: credits ?? this.credits,
      isLoadingCredits: isLoadingCredits ?? this.isLoadingCredits,
      isCreditsFailed: isCreditsFailed ?? this.isCreditsFailed,
      reviews: reviews ?? this.reviews,
      isLoadingReviews: isLoadingReviews ?? this.isLoadingReviews,
      isReviewsFailed: isReviewsFailed ?? this.isReviewsFailed,
      similarMovies: similarMovies ?? this.similarMovies,
      isLoadingSimilar: isLoadingSimilar ?? this.isLoadingSimilar,
      isSimilarFailed: isSimilarFailed ?? this.isSimilarFailed,
    );
  }
}
