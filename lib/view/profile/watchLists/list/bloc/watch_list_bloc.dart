import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watch_list_event.dart';
part 'watch_list_state.dart';

class WatchListBloc extends Bloc<WatchListEvent, WatchListState> {
  WatchListBloc() : super(WatchListInitial(selectedTabIndex: 0)) {
    on<SelectWatchListTabEvent>((event, emit) {
      emit(WatchListInitial(selectedTabIndex: event.index));
    });
  }
}
