part of 'rating_bloc.dart';

sealed class RatingState extends Equatable {
  final int selectedTabIndex;

  const RatingState({required this.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}

final class RatingInitial extends RatingState {
  const RatingInitial({required super.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}
