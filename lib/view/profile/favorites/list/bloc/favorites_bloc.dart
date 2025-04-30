import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial(selectedTabIndex: 0)) {
    on<SelectMovieTabEvent>((event, emit) {
      emit(FavoritesInitial(selectedTabIndex: event.index));
    });
  }
}
