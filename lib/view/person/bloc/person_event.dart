part of 'person_bloc.dart';

sealed class PersonEvent extends Equatable {
  const PersonEvent();
}

final class PersonLoadEvent extends PersonEvent {
  final BuildContext context;
  final int id;

  const PersonLoadEvent({required this.context, required this.id});

  @override
  List<Object> get props => [context, id];
}
