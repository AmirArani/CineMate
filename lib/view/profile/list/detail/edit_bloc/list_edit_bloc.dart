import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/list_model.dart';
import '../../../../../data/repo/list_repo.dart';

part 'list_edit_event.dart';
part 'list_edit_state.dart';

class ListEditBloc extends Bloc<ListEditEvent, ListEditState> {
  ListEditBloc() : super(ListEditInitial()) {
    on<OpenListEditEvent>((event, emit) {
      emit(ListEditLoaded(
        nameTEC: TextEditingController()..text = event.name,
        descTEC: TextEditingController()..text = event.desc,
        listData: event.listData,
        public: event.public,
        editLoading: false,
        deleteLoading: false,
        closeSuccess: false,
        closeFailed: false,
      ));
    });

    on<ListEditChangePublicEvent>((event, emit) {
      emit(event.state.copyWith(public: event.value));
    });

    on<ListEditPreserveStateEvent>((event, emit) {
      if (state is ListEditLoaded) {
        final currentState = state as ListEditLoaded;
        emit(currentState.copyWith(
          nameTEC: event.nameTEC,
          descTEC: event.descTEC,
        ));
      }
    });

    on<ListEditSubmitEvent>((event, emit) async {
      emit(event.state.copyWith(
        editLoading: true,
        closeFailed: false,
        closeSuccess: false,
      ));

      try {
        await listRepo.editList(
            name: event.state.nameTEC.text,
            desc: event.state.descTEC.text,
            public: event.state.public,
            id: event.state.listData.id);
        await Future.delayed(Duration(seconds: 1));
        emit(event.state.copyWith(closeSuccess: true, closeFailed: false, editLoading: true));
      } catch (e) {
        emit(event.state.copyWith(closeSuccess: false, closeFailed: true, editLoading: true));
      }
    });

    on<ListDeleteSubmitEvent>((event, emit) async {
      emit(event.state.copyWith(deleteLoading: true, closeFailed: false, closeSuccess: false));

      try {
        await listRepo.deleteList(id: event.state.listData.id);
        await Future.delayed(Duration(seconds: 1));
        emit(event.state.copyWith(closeSuccess: true, closeFailed: false, deleteLoading: true));
      } catch (e) {
        emit(event.state.copyWith(closeSuccess: false, closeFailed: true, deleteLoading: true));
      }
    });
  }

  // Add this to preserve state during rebuilds
  @override
  void onTransition(Transition<ListEditEvent, ListEditState> transition) {
    super.onTransition(transition);
    if (transition.nextState is ListEditLoaded) {
      final nextState = transition.nextState as ListEditLoaded;
      add(ListEditPreserveStateEvent(nextState.nameTEC, nextState.descTEC));
    }
  }
}
