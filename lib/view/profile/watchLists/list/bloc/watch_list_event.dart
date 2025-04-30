part of 'watch_list_bloc.dart';

sealed class WatchListEvent extends Equatable {
  const WatchListEvent();
}

class SelectWatchListTabEvent extends WatchListEvent {
  final int index;

  const SelectWatchListTabEvent(this.index);

  @override
  List<Object> get props => [index];
}
