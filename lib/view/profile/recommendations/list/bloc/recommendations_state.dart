part of 'recommendations_bloc.dart';

sealed class RecommendationsState extends Equatable {
  final int selectedTabIndex;

  const RecommendationsState({required this.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}

final class RecommendationsInitial extends RecommendationsState {
  const RecommendationsInitial({required super.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}
