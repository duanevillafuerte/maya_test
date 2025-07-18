class CustomException implements Exception {
  String? code;
  String? message;
  Exception? cause;
  StackTrace? stackTrace;

  CustomException({this.code, this.message, this.cause, this.stackTrace});
}
