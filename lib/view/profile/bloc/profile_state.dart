part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileLoggedOutState extends ProfileState {
  @override
  List<Object> get props => [];
}

final class ProfileLoggedInState extends ProfileState {
  final String sessionToken;
  final AccountModel? account;
  final bool loadingAccountFailed;

  const ProfileLoggedInState({
    required this.sessionToken,
    required this.account,
    required this.loadingAccountFailed,
  });

  @override
  List<Object?> get props => [sessionToken, account, loadingAccountFailed];

  ProfileLoggedInState copyWith({
    String? sessionToken,
    AccountModel? account,
    bool? loadingAccountFailed,
  }) {
    return ProfileLoggedInState(
      sessionToken: sessionToken ?? this.sessionToken,
      account: account ?? this.account,
      loadingAccountFailed: loadingAccountFailed ?? this.loadingAccountFailed,
    );
  }
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}
