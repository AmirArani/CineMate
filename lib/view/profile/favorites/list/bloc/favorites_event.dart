part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

class SelectMovieTabEvent extends FavoritesEvent {
  final int index;

  const SelectMovieTabEvent(this.index);

  @override
  List<Object> get props => [index];
}
