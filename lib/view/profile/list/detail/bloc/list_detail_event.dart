part of 'list_detail_bloc.dart';

sealed class ListDetailEvent extends Equatable {
  const ListDetailEvent();
}

class ListDetailPreferencesChanged extends ListDetailEvent {
  final ListPreferences preferences;

  const ListDetailPreferencesChanged(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class ListDetailPageRequested extends ListDetailEvent {
  final int id;
  final int page;

  const ListDetailPageRequested({required this.id, required this.page});

  @override
  List<Object> get props => [page, id];
}

class LoadListDetailEvent extends ListDetailEvent {
  final int id;

  const LoadListDetailEvent({required this.id});

  @override
  List<Object> get props => [id];
}

final class OpenCommentModalEvent extends ListDetailEvent {
  final ListDetailLoadSuccess state;
  final ListDetailIemModel item;

  const OpenCommentModalEvent({required this.state, required this.item});

  @override
  List<Object> get props => [state, item];
}

final class SubmitCommentEvent extends ListDetailEvent {
  final int listId;
  final ListDetailIemModel itemToEdit;
  final ListDetailLoadSuccess state;

  const SubmitCommentEvent({required this.listId, required this.itemToEdit, required this.state});

  @override
  List<Object> get props => [listId, itemToEdit, state];
}

final class DeleteCommentEvent extends ListDetailEvent {
  final int listId;
  final ListDetailIemModel itemToEdit;
  final ListDetailLoadSuccess state;

  const DeleteCommentEvent({required this.listId, required this.itemToEdit, required this.state});

  @override
  List<Object> get props => [listId, itemToEdit, state];
}
