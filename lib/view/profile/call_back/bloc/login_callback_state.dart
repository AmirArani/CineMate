part of 'login_callback_bloc.dart';

sealed class LoginCallbackState extends Equatable {
  const LoginCallbackState();
}

final class LoginCallbackInitial extends LoginCallbackState {
  @override
  List<Object> get props => [];
}

final class LoginCallbackSuccess extends LoginCallbackState {
  @override
  List<Object> get props => [];
}

final class LoginCallbackFailed extends LoginCallbackState {
  @override
  List<Object> get props => [];
}
