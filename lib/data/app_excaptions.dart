class AppException implements Exception {
  final String _message;
  AppException(this._message,);

  @override
  String toString() {
    return _message;
  }
}

class FetchDataException extends AppException {
  FetchDataException(message) : super(message);
}

class BadRequestException extends AppException {
  BadRequestException(message) : super(message);
}

class UnAuthorisedException extends AppException {
  UnAuthorisedException(message) : super(message);
}

class InvalidInputException extends AppException {
  InvalidInputException(message) : super(message);
}