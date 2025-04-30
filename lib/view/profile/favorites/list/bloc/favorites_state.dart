part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  final int selectedTabIndex;

  const FavoritesState({required this.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial({required super.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}
