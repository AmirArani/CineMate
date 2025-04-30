import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utils/web/urls.dart';
import '../model/account_model.dart';

abstract class IAuthSrc {
  Future<String> getRequestToken();

  Future<AccountAuthModel> getAccessToken({required String requestToken});

  Future<String> createNewSession({required String accessToken});
  Future<bool> deleteSession({required String sessionToken});

  Future<bool> deleteAccessToken({required String accessToken});
}

class AuthRemoteSrc implements IAuthSrc {
  final Dio _httpClient;

  AuthRemoteSrc({required Dio httpClient}) : _httpClient = httpClient;

  @override
  Future<String> getRequestToken() async {
    try {
      final response = await _httpClient
          .post(getRequestTokenURL, data: {"redirect_to": "cinemate://login-callback"});

      return response.data['success']
          ? response.data['request_token'].toString()
          : throw Exception('Getting Request Token Failed');
    } catch (e) {
      throw Exception('Getting Request Token Failed');
    }
  }

  @override
  Future<AccountAuthModel> getAccessToken({required String requestToken}) async {
    try {
      final response =
          await _httpClient.post(getAccessTokenURL, data: {"request_token": requestToken});

      return response.data['success']
          ? AccountAuthModel(
              accessToken: response.data['access_token'].toString(),
              accountId: response.data['account_id'].toString())
          : throw Exception('Getting Access Token Failed');
    } catch (e) {
      throw Exception('Getting Access Token Failed');
    }
  }

  @override
  Future<String> createNewSession({required String accessToken}) async {
    try {
      final response =
          await _httpClient.post(getNewSessionURL, data: {'access_token': accessToken});
      return response.data['success']
          ? response.data['session_id'].toString()
          : throw Exception('getting session failed!');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception();
    }
  }

  @override
  Future<bool> deleteSession({required String sessionToken}) async {
    try {
      final response = await _httpClient.delete(
        deleteSessionURL,
        data: {'session_id': sessionToken},
      );

      return response.data['success'].toString() == 'true';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteAccessToken({required String accessToken}) async {
    try {
      final response = await _httpClient.delete(
        getAccessTokenURL,
        data: {'access_token': accessToken},
      );

      return response.data['success'].toString() == 'true';
    } catch (e) {
      return false;
    }
  }
}

class AuthLocalSrc {
  final FlutterSecureStorage _storage;

  AuthLocalSrc({required FlutterSecureStorage storage}) : _storage = storage;

  Future<void> storeRequestToken(String token) async =>
      await _storage.write(key: 'requestToken', value: token);

  Future<String?> getRequestToken() async {
    String? token = await _storage.read(key: 'requestToken');
    // request token is one-time. so after reading it, it should be deleted!
    _storage.delete(key: 'requestToken');
    return token;
  }

  Future<void> deleteRequestToken() async => await _storage.delete(key: 'requestToken');

  Future<void> storeAccessToken(String token) async =>
      await _storage.write(key: 'accessToken', value: token);

  Future<String?> getAccessToken() async => await _storage.read(key: 'accessToken');

  Future<void> deleteAccessToken() async => await _storage.delete(key: 'accessToken');

  Future<void> storeAccountId(String id) async => await _storage.write(key: 'AccountId', value: id);

  Future<String?> getAccountId() async => await _storage.read(key: 'AccountId');

  Future<void> deleteAccountId() async => await _storage.delete(key: 'AccountId');

  Future<void> storeSessionToken(String token) async =>
      await _storage.write(key: 'sessionToken', value: token);

  Future<String?> getSessionToken() async => await _storage.read(key: 'sessionToken');

  Future<void> deleteSessionToken() async => await _storage.delete(key: 'sessionToken');
}
