part of 'list_detail_bloc.dart';

sealed class ListDetailState extends Equatable {
  final ListPreferences preferences;

  const ListDetailState({required this.preferences});

  @override
  List<Object> get props => [preferences];
}

class ListDetailInitial extends ListDetailState {
  const ListDetailInitial({required super.preferences});
}

class ListDetailLoadInProgress extends ListDetailState {
  const ListDetailLoadInProgress({required super.preferences});
}

class ListDetailLoadSuccess extends ListDetailState {
  final ListModel listData;
  final String createdBy;
  final ListDetailIemModel? itemToEdit;
  final TextEditingController commentTEC;
  final bool editLoading;
  final bool deleteLoading;
  final bool closeSuccess;
  final bool closeFailed;

  const ListDetailLoadSuccess(
      {required super.preferences,
      required this.listData,
      required this.createdBy,
      required this.itemToEdit,
      required this.commentTEC,
      required this.editLoading,
      required this.deleteLoading,
      required this.closeSuccess,
      required this.closeFailed});

  @override
  List<Object> get props =>
      [listData, createdBy, commentTEC, editLoading, deleteLoading, closeSuccess, closeFailed];

  ListDetailLoadSuccess copyWith(
      {ListModel? listData,
      String? createdBy,
      ListDetailIemModel? itemToEdit,
      TextEditingController? commentTEC,
      bool? editLoading,
      bool? deleteLoading,
      bool? closeSuccess,
      bool? closeFailed}) {
    return ListDetailLoadSuccess(
        preferences: preferences,
        listData: listData ?? this.listData,
        createdBy: createdBy ?? this.createdBy,
        itemToEdit: itemToEdit ?? this.itemToEdit,
        commentTEC: commentTEC ?? this.commentTEC,
        editLoading: editLoading ?? this.editLoading,
        deleteLoading: deleteLoading ?? this.deleteLoading,
        closeSuccess: closeSuccess ?? this.closeSuccess,
        closeFailed: closeFailed ?? this.closeFailed);
  }
}

class ListDetailLoadFailure extends ListDetailState {
  final String error;

  const ListDetailLoadFailure({required super.preferences, required this.error});

  @override
  List<Object> get props => [error, preferences];
}
