part of 'list_bloc.dart';

sealed class ListEvent extends Equatable {}

class ListPageRequested extends ListEvent {
  final int page;

  ListPageRequested(this.page);

  @override
  List<Object> get props => [page];
}

class ListRefreshRequested extends ListEvent {
  @override
  List<Object> get props => [];
}
