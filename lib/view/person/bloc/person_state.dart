part of 'person_bloc.dart';

sealed class PersonState extends Equatable {
  final PersonModel person;
  final List<dynamic> knownForItems;

  const PersonState({required this.person, required this.knownForItems});

  @override
  List<Object> get props => [person, knownForItems];
}

final class PersonLoaded extends PersonState {
  final PersonDetailModel personData;
  final List<String> imagesPaths;
  final PersonMovieCreditModel movieCredits;
  final PersonTvsShowCreditModel showCredits;

  const PersonLoaded(
      {required super.person,
      required super.knownForItems,
      required this.personData,
      required this.imagesPaths,
      required this.movieCredits,
      required this.showCredits});

  @override
  List<Object> get props => [
        personData,
        imagesPaths,
        movieCredits,
        showCredits,
      ];
}

final class PersonLoading extends PersonState {
  const PersonLoading({required super.person, required super.knownForItems});

  @override
  List<Object> get props => [person, knownForItems];
}

final class PersonError extends PersonState {
  const PersonError({required super.person, required super.knownForItems});

  @override
  List<Object> get props => [person, knownForItems];
}
