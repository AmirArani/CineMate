part of 'watch_list_bloc.dart';

sealed class WatchListState extends Equatable {
  final int selectedTabIndex;

  const WatchListState({required this.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}

final class WatchListInitial extends WatchListState {
  const WatchListInitial({required super.selectedTabIndex});

  @override
  List<Object> get props => [selectedTabIndex];
}
