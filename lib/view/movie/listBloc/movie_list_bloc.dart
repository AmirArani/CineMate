import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/model/list_model.dart';
import '../../../data/model/media_model.dart';
import '../../../data/model/movie_model.dart';
import '../../../data/repo/list_repo.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final PagingController<int, ListModel> pagingController = PagingController(firstPageKey: 1);

  MovieListBloc() : super(MovieListInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      add(MovieListFetchEvent(page: pageKey));
    });

    on<MovieListFetchEvent>(_onFetchLists);
    on<MovieListAddMovieEvent>(_onAddMovieToList);
    on<MovieListCreateEvent>(_onCreateList);
  }

  Future<void> _onFetchLists(MovieListFetchEvent event, Emitter<MovieListState> emit) async {
    if (event.page == 1) {
      emit(MovieListLoading());
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

      emit(MovieListLoaded());
    } catch (e) {
      pagingController.error = e;
      emit(MovieListError(error: e.toString()));
    }
  }

  Future<void> _onAddMovieToList(MovieListAddMovieEvent event, Emitter<MovieListState> emit) async {
    emit(MovieListAdding());
    try {
      // Convert MovieModel to MediaModel
      final MediaModel mediaModel = MediaModel(
        mediaType: MediaType.movie,
        movie: event.movie,
      );

      // Call the API to add the movie to the list with the optional comment
      final success = await listRepo.addItemToList(
        media: mediaModel,
        listId: event.listId,
      );

      if (success) {
        emit(MovieListAddSuccess(listName: event.listName));
      } else {
        emit(MovieListError(error: 'Failed to add movie to list.'));
      }
    } catch (e) {
      emit(MovieListError(error: e.toString()));
    }
  }

  Future<void> _onCreateList(MovieListCreateEvent event, Emitter<MovieListState> emit) async {
    emit(MovieListCreating());
    try {
      final success = await listRepo.createNewList(
        name: event.name,
        desc: event.description,
        public: event.isPublic,
      );

      if (success) {
        emit(MovieListCreateSuccess(listName: event.name));

        // Wait a short moment before refreshing lists to ensure the backend has updated
        await Future.delayed(Duration(milliseconds: 500));

        // Refresh the paging controller to fetch the updated lists
        pagingController.refresh();

        emit(MovieListLoaded());
      } else {
        emit(MovieListError(error: 'Failed to create new list.'));
      }
    } catch (e) {
      emit(MovieListError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
