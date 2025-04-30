import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc() : super(RatingInitial(selectedTabIndex: 0)) {
    on<SelectMovieTabEvent>((event, emit) {
      emit(RatingInitial(selectedTabIndex: event.index));
    });
  }
}
