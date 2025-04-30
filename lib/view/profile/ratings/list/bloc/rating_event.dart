part of 'rating_bloc.dart';

sealed class RatingEvent extends Equatable {
  const RatingEvent();
}

class SelectMovieTabEvent extends RatingEvent {
  final int index;

  const SelectMovieTabEvent(this.index);

  @override
  List<Object> get props => [index];
}
