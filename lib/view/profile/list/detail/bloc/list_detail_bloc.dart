import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../data/model/list_model.dart';
import '../../../../../data/repo/list_repo.dart';
import '../../../../../utils/helpers/list_preferences.dart';

part 'list_detail_event.dart';
part 'list_detail_state.dart';

class ListDetailBloc extends Bloc<ListDetailEvent, ListDetailState> {
  final PagingController<int, ListDetailIemModel> pagingController =
      PagingController(firstPageKey: 1);

  ListDetailBloc()
      : super(
            ListDetailInitial(preferences: ListPreferences(sortMethod: SortMethod.createdAtAsc))) {
    on<ListDetailPreferencesChanged>(_onPreferencesChanged);
    on<ListDetailPageRequested>(_onPageRequested);

    on<LoadListDetailEvent>((event, emit) {
      pagingController.addPageRequestListener((pageKey) {
        add(ListDetailPageRequested(page: pageKey, id: event.id));
      });
      add(ListDetailPageRequested(id: event.id, page: 1));
    });

    on<OpenCommentModalEvent>((event, emit) {
      emit(event.state.copyWith(
          commentTEC: TextEditingController()..text = event.item.comment ?? '',
          itemToEdit: event.item,
          closeSuccess: false,
          closeFailed: false,
          editLoading: false,
          deleteLoading: false));
    });

    on<SubmitCommentEvent>((event, emit) async {
      ListDetailLoadSuccess oldState = event.state;
      emit(oldState.copyWith(editLoading: true));

      try {
        bool success = await listRepo.editItemInList(
            item: event.itemToEdit, listId: event.listId, newComment: oldState.commentTEC.text);

        success
            ? emit(oldState.copyWith(closeSuccess: true, editLoading: true))
            : throw Exception();
      } catch (e) {
        emit(oldState.copyWith(closeFailed: true, editLoading: true));
      }
    });

    on<DeleteCommentEvent>((event, emit) async {
      ListDetailLoadSuccess oldState = event.state;
      emit(oldState.copyWith(deleteLoading: true));

      try {
        bool success = await listRepo.editItemInList(
            item: event.itemToEdit, listId: event.listId, newComment: '');

        success
            ? emit(oldState.copyWith(closeSuccess: true, deleteLoading: true))
            : throw Exception();
      } catch (e) {
        emit(oldState.copyWith(closeFailed: true, deleteLoading: true));
      }
    });
  }

  Future<void> _onPreferencesChanged(
      ListDetailPreferencesChanged event, Emitter<ListDetailState> emit) async {
    // Only update if preferences actually changed
    if (state.preferences != event.preferences) {
      emit(ListDetailLoadInProgress(preferences: event.preferences));
      pagingController.refresh();
    }
  }

  Future<void> _onPageRequested(
      ListDetailPageRequested event, Emitter<ListDetailState> emit) async {
    try {
      final currentPrefs = state.preferences;
      ListDetailModel nextPage = await listRepo.getListDetail(
        listId: event.id,
        page: event.page,
        sortMethod: currentPrefs.sortMethod,
      );

      bool isLastPage = nextPage.page >= nextPage.totalPages;
      int? nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.items);
      } else {
        pagingController.appendPage(nextPage.items, nextPageKey);
      }

      emit(ListDetailLoadSuccess(
          preferences: currentPrefs,
          listData: nextPage.listData,
          createdBy: nextPage.createdBy,
          itemToEdit: null,
          commentTEC: TextEditingController()..clear(),
          editLoading: false,
          deleteLoading: false,
          closeSuccess: false,
          closeFailed: false));
    } catch (e) {
      pagingController.error = e;
      emit(ListDetailLoadFailure(preferences: state.preferences, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
