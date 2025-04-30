part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class ProfileLoadEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

final class LoginBtnPressedEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

final class LogoutBtnPressedEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

final class GetAccessTokenEvent extends ProfileEvent {
  final BuildContext ctx;

  const GetAccessTokenEvent({required this.ctx});

  @override
  List<Object> get props => [ctx];
}
