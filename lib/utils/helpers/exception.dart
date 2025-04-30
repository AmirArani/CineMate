class AppException {
  final String message;

  AppException({this.message = 'Error!'});
}

class NetworkException {
  final String message;

  NetworkException({this.message = 'Network Error!'});
}

class InvalidLoginException {
  final String message;

  InvalidLoginException({this.message = 'Invalid Credentials! Please try again'});
}
