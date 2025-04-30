import 'package:dio/dio.dart';

final Dio httpClient = Dio(
  BaseOptions(baseUrl: const String.fromEnvironment('API_BASE_URL')),
)..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers.keys.contains('Authorization')
          ? null
          : options.headers['Authorization'] =
              'Bearer ${const String.fromEnvironment('ACCESS_KEY')}';
      handler.next(options);
    },
  ));

Dio httpClientV4({required String accessToken}) {
  return Dio(
    BaseOptions(baseUrl: const String.fromEnvironment('API_BASE_URL')),
  )..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers.keys.contains('Authorization')
            ? null
            : options.headers['Authorization'] = 'Bearer $accessToken';
        handler.next(options);
      },
    ));
}
