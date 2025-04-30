import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/model/list_model.dart';
import '../../../data/model/media_model.dart';
import '../../../data/model/tv_show_model.dart';
import '../../../data/repo/list_repo.dart';

part 'tv_show_list_event.dart';
part 'tv_show_list_state.dart';

class TvShowListBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final PagingController<int, ListModel> pagingController = PagingController(firstPageKey: 1);

  TvShowListBloc() : super(TvShowListInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      add(TvShowListFetchEvent(page: pageKey));
    });

    on<TvShowListFetchEvent>(_onFetchLists);
    on<TvShowListAddTvShowEvent>(_onAddTvShowToList);
    on<TvShowListCreateEvent>(_onCreateList);
  }

  Future<void> _onFetchLists(TvShowListFetchEvent event, Emitter<TvShowListState> emit) async {
    if (event.page == 1) {
      emit(TvShowListLoading());
    }

    try {
      final listsResponse = await listRepo.getAllLists(page: event.page);
      final isLastPage = listsResponse.page >= listsResponse.totalPages;
      final nextPageKey = isLastPage ? null : listsResponse.page + 1;

      // Clear existing items if this is the first page to prevent duplicates
      if (event.page == 1 && pagingController.itemList != null) {
        pagingController.itemList!.clear();
      }

      if (isLastPage) {
        pagingController.appendLastPage(listsResponse.lists);
      } else {
        pagingController.appendPage(listsResponse.lists, nextPageKey);
      }

      emit(TvShowListLoaded());
    } catch (e) {
      pagingController.error = e;
      emit(TvShowListError(error: e.toString()));
    }
  }

  Future<void> _onAddTvShowToList(
      TvShowListAddTvShowEvent event, Emitter<TvShowListState> emit) async {
    emit(TvShowListAdding());
    try {
      // Convert TvShowModel to MediaModel
      final MediaModel mediaModel = MediaModel(mediaType: MediaType.tv, show: event.show);

      // Call the API to add the show to the list with the optional comment
      final success = await listRepo.addItemToList(
        media: mediaModel,
        listId: event.listId,
      );

      if (success) {
        emit(TvShowListAddSuccess(listName: event.listName));
      } else {
        emit(TvShowListError(error: 'Failed to add show to list.'));
      }
    } catch (e) {
      emit(TvShowListError(error: e.toString()));
    }
  }

  Future<void> _onCreateList(TvShowListCreateEvent event, Emitter<TvShowListState> emit) async {
    emit(TvShowListCreating());
    try {
      final success = await listRepo.createNewList(
        name: event.name,
        desc: event.description,
        public: event.isPublic,
      );

      if (success) {
        emit(TvShowListCreateSuccess(listName: event.name));

        // Wait a short moment before refreshing lists to ensure the backend has updated
        await Future.delayed(Duration(milliseconds: 500));

        // Refresh the paging controller to fetch the updated lists
        pagingController.refresh();

        emit(TvShowListLoaded());
      } else {
        emit(TvShowListError(error: 'Failed to create new list.'));
      }
    } catch (e) {
      emit(TvShowListError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
