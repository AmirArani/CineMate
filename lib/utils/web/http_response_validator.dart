import 'package:dio/dio.dart';

import '../helpers/exception.dart';

mixin HttpResponseValidator {
  validateResponse(Response response) {
    if (response.statusCode == 401) {
      throw InvalidLoginException();
    } else if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204 &&
        response.statusCode != 202) {
      throw NetworkException();
    }
  }
}
