import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utils/web/http_client.dart';
import '../model/account_model.dart';
import '../src/auth_src.dart';

final authRepo = AuthRepository(
  remoteSrc: AuthRemoteSrc(httpClient: httpClient),
  localSrc: AuthLocalSrc(storage: FlutterSecureStorage()),
);

abstract class IAuthRepository {
  Future<String> getRequestToken();

  Future<AccountAuthModel> getAccountAuthData({required String requestToken});
  Future<String?> getSessionToken({required String accessToken, bool remoteForce = false});
  Future<bool> logOut();
}

class AuthRepository implements IAuthRepository {
  final AuthRemoteSrc _remoteSrc;
  final AuthLocalSrc _localSrc;

  AuthRepository({required AuthRemoteSrc remoteSrc, required AuthLocalSrc localSrc})
      : _remoteSrc = remoteSrc,
        _localSrc = localSrc;

  @override
  Future<String> getRequestToken({bool remoteForce = false}) async {
    String? localToken = await _localSrc.getRequestToken();
    if (localToken == null || remoteForce) {
      final String requestToken = await _remoteSrc.getRequestToken();
      await _localSrc.storeRequestToken(requestToken);
      return requestToken;
    } else {
      return localToken;
    }
  }

  @override
  Future<AccountAuthModel> getAccountAuthData(
      {String? requestToken, bool remoteForce = false}) async {
    String? localAccessToken = await _localSrc.getAccessToken();
    if (localAccessToken == null && remoteForce) {
      final AccountAuthModel authData =
          await _remoteSrc.getAccessToken(requestToken: requestToken!);
      await _localSrc.storeAccessToken(authData.accessToken);
      await _localSrc.storeAccountId(authData.accountId);
      return authData;
    } else {
      String? token = await _localSrc.getAccessToken();
      String? id = await _localSrc.getAccountId();
      if (token != null && id != null) {
        return AccountAuthModel(accessToken: token, accountId: id);
      } else {
        throw Exception();
      }
    }
  }

  @override
  Future<String?> getSessionToken({String? accessToken, bool remoteForce = false}) async {
    String? localSessionToken = await _localSrc.getSessionToken();
    if (localSessionToken != null && !remoteForce) {
      return localSessionToken;
    } else if (accessToken != null) {
      String remoteSessionToken = await _remoteSrc.createNewSession(accessToken: accessToken);
      await _localSrc.storeSessionToken(remoteSessionToken);
      return remoteSessionToken;
    } else {
      return null;
    }
  }

  @override
  Future<bool> logOut() async {
    String? sessionToken = await _localSrc.getSessionToken();
    String? accessToken = await _localSrc.getAccessToken();
    if (sessionToken != null && accessToken != null) {
      bool sessionSuccess = await _remoteSrc.deleteSession(sessionToken: sessionToken);
      sessionSuccess ? _localSrc.deleteSessionToken() : null;
      bool accessSuccess = await _remoteSrc.deleteAccessToken(accessToken: accessToken);
      accessSuccess ? _localSrc.deleteAccessToken() : null;
      accessSuccess ? _localSrc.deleteAccountId() : null;
      return sessionSuccess && accessSuccess;
    } else {
      return false;
    }
  }
}
