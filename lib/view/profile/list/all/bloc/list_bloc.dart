import 'package:bloc/bloc.dart';
import 'package:cinemate/data/model/list_model.dart';
import 'package:cinemate/data/repo/list_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final PagingController<int, ListModel> pagingController = PagingController(firstPageKey: 1);

  ListBloc() : super(ListInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      add(ListPageRequested(pageKey));
    });

    on<ListPageRequested>(_onPageRequested);
    on<ListRefreshRequested>((event, emit) async {
      pagingController.refresh();
    });
  }

  Future<void> _onPageRequested(
    ListPageRequested event,
    Emitter<ListState> emit,
  ) async {
    try {
      final nextPage = await listRepo.getAllLists(page: event.page);

      final isLastPage = nextPage.page >= nextPage.totalPages;
      final nextPageKey = isLastPage ? null : nextPage.page + 1;

      if (isLastPage) {
        pagingController.appendLastPage(nextPage.lists);
      } else {
        pagingController.appendPage(nextPage.lists, nextPageKey);
      }

      emit(ListLoadSuccess());
    } catch (e) {
      pagingController.error = e;
      emit(ListLoadFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
