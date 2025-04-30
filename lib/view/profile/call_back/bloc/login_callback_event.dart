part of 'login_callback_bloc.dart';

sealed class LoginCallbackEvent extends Equatable {}

final class LoginCallBackChangeEvent extends LoginCallbackEvent {
  final bool? success;

  LoginCallBackChangeEvent({required this.success});

  @override
  List<Object> get props => [];
}
