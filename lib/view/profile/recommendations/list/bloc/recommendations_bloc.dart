import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recommendations_event.dart';
part 'recommendations_state.dart';

class RecommendationsBloc extends Bloc<RecommendationsEvent, RecommendationsState> {
  RecommendationsBloc() : super(RecommendationsInitial(selectedTabIndex: 0)) {
    on<SelectRecommendationTabEvent>((event, emit) {
      emit(RecommendationsInitial(selectedTabIndex: event.index));
    });
  }
}
