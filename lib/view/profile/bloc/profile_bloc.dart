import 'package:cinemate/view/profile/call_back/bloc/login_callback_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/account_model.dart';
import '../../../data/repo/account_repo.dart';
import '../../../data/repo/auth_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileLoadEvent) {
        await _handleProfileLoadEvent(emit, event);
      } else if (event is LoginBtnPressedEvent) {
        await _handleLoginEvent(emit, event);
      } else if (event is GetAccessTokenEvent) {
        await _handleGetAccessTokenEvent(emit, event);
      } else if (event is LogoutBtnPressedEvent) {
        bool success = await authRepo.logOut();
        success ? emit(ProfileLoggedOutState()) : null;
      }
    });
  }
}

Future<void> _handleProfileLoadEvent(Emitter emit, ProfileLoadEvent event) async {
  String? sessionToken = await authRepo.getSessionToken();

  if (sessionToken == null) {
    emit(ProfileLoggedOutState());
  } else {
    ProfileLoggedInState state = ProfileLoggedInState(
        sessionToken: sessionToken, account: null, loadingAccountFailed: false);
    emit(state);
    try {
      AccountModel account = await accountRepo.getAccountData(session: sessionToken);
      emit(state.copyWith(account: account, loadingAccountFailed: false));
    } catch (e) {
      emit(state.copyWith(loadingAccountFailed: true));
    }
  }
}

Future<void> _handleLoginEvent(Emitter emit, LoginBtnPressedEvent event) async {
  // STEP 1: getting request Token
  String requestToken = await authRepo.getRequestToken();

  // STEP 2: getting user approval on request token
  await launchUrl(
    Uri.parse("https://www.themoviedb.org/auth/access?request_token=$requestToken"),
    mode: LaunchMode.inAppBrowserView,
  );
}

Future<void> _handleGetAccessTokenEvent(Emitter emit, GetAccessTokenEvent event) async {
  BlocProvider.of<LoginCallbackBloc>(event.ctx).add(LoginCallBackChangeEvent(success: null));

  final String requestToken = await authRepo.getRequestToken();
  try {
    // STEP 3: getting access token with approved request token
    AccountAuthModel? authData =
        await authRepo.getAccountAuthData(requestToken: requestToken, remoteForce: true);

    // STEP 4: getting session token with access token
    String? sessionToken =
        await authRepo.getSessionToken(accessToken: authData.accessToken, remoteForce: true);

    debugPrint('access: ${authData.accessToken}');
    debugPrint('session: $sessionToken');
    ProfileLoggedInState state = ProfileLoggedInState(
        sessionToken: authData.accessToken, account: null, loadingAccountFailed: false);
    emit(state);

    // Step 5: Getting account info with session token
    AccountModel account = await accountRepo.getAccountData(session: sessionToken!);

    emit(state.copyWith(account: account, loadingAccountFailed: false));

    // add success state to callback screen
    BlocProvider.of<LoginCallbackBloc>(event.ctx).add(LoginCallBackChangeEvent(success: true));
  } catch (e) {
    emit(ProfileLoggedOutState());

    // add failed state to callback screen
    BlocProvider.of<LoginCallbackBloc>(event.ctx).add(LoginCallBackChangeEvent(success: false));
  }
}
