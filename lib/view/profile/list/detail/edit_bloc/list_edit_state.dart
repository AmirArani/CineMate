part of 'list_edit_bloc.dart';

sealed class ListEditState extends Equatable {
  const ListEditState();
}

final class ListEditInitial extends ListEditState {
  @override
  List<Object> get props => [];
}

final class ListEditLoaded extends ListEditState {
  final TextEditingController nameTEC;
  final TextEditingController descTEC;
  final bool public;
  final bool editLoading;
  final bool deleteLoading;
  final bool closeSuccess;
  final bool closeFailed;
  final ListModel listData;

  const ListEditLoaded(
      {required this.nameTEC,
      required this.descTEC,
      required this.listData,
      required this.public,
      required this.editLoading,
      required this.deleteLoading,
      required this.closeSuccess,
      required this.closeFailed});

  ListEditLoaded copyWith(
      {TextEditingController? nameTEC,
      TextEditingController? descTEC,
      bool? public,
      bool? editLoading,
      bool? deleteLoading,
      bool? closeSuccess,
      bool? closeFailed,
      ListModel? listData}) {
    return ListEditLoaded(
        nameTEC: nameTEC ?? this.nameTEC,
        descTEC: descTEC ?? this.descTEC,
        public: public ?? this.public,
        editLoading: editLoading ?? this.editLoading,
        deleteLoading: deleteLoading ?? this.deleteLoading,
        closeSuccess: closeSuccess ?? this.closeSuccess,
        closeFailed: closeFailed ?? this.closeFailed,
        listData: listData ?? this.listData);
  }

  @override
  List<Object> get props =>
      [nameTEC, descTEC, public, editLoading, deleteLoading, closeSuccess, closeFailed, listData];
}
