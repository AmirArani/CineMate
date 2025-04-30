part of 'list_bloc.dart';

sealed class ListState extends Equatable {
  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {
  ListInitial();

  @override
  List<Object> get props => [];
}

class ListLoadInProgress extends ListState {}

class ListLoadSuccess extends ListState {}

class ListLoadFailure extends ListState {
  final String error;

  ListLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
