part of 'list_edit_bloc.dart';

sealed class ListEditEvent extends Equatable {
  const ListEditEvent();

  @override
  List<Object?> get props => [];
}

class ListEditPreserveStateEvent extends ListEditEvent {
  final TextEditingController nameTEC;
  final TextEditingController descTEC;

  const ListEditPreserveStateEvent(this.nameTEC, this.descTEC);

  @override
  List<Object?> get props => [nameTEC, descTEC];
}

class LoadListEditEvent extends ListEditEvent {
  final int id;

  const LoadListEditEvent({required this.id});

  @override
  List<Object> get props => [id];
}

final class OpenListEditEvent extends ListEditEvent {
  final bool public;
  final String name;
  final String desc;
  final ListModel listData;

  const OpenListEditEvent(
      {required this.public, required this.name, required this.desc, required this.listData});

  @override
  List<Object> get props => [public, name, desc, listData];
}

final class ListEditChangePublicEvent extends ListEditEvent {
  final bool value;
  final ListEditLoaded state;

  const ListEditChangePublicEvent({required this.value, required this.state});

  @override
  List<Object> get props => [state, value];
}

final class ListEditSubmitEvent extends ListEditEvent {
  final ListEditLoaded state;

  const ListEditSubmitEvent({required this.state});

  @override
  List<Object> get props => [state];
}

final class ListDeleteSubmitEvent extends ListEditEvent {
  final ListEditLoaded state;

  const ListDeleteSubmitEvent({required this.state});

  @override
  List<Object> get props => [state];
}
