class AppException implements Exception {
  final dynamic message;
  AppException(this.message);

  @override
  String toString() {
    if (message is Map) {
      if (message.containsKey("message_en") && message["message_en"] != null) {
        return message["message_en"].toString();
      }
      if (message.containsKey("message") && message["message"] != null) {
        return message["message"].toString();
      }
    }
    return message.toString();
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