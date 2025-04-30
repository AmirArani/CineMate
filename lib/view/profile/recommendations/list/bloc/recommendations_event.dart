part of 'recommendations_bloc.dart';

sealed class RecommendationsEvent extends Equatable {
  const RecommendationsEvent();
}

class SelectRecommendationTabEvent extends RecommendationsEvent {
  final int index;

  const SelectRecommendationTabEvent(this.index);

  @override
  List<Object> get props => [index];
}
