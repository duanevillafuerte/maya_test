import 'package:http/http.dart';

extension ResponseParser on Response {
  static const _statusCode = "statusCode";
  static const _body = "body";
  static const _reasonPhrase = "reasonPhrase";
  static const _contentLength = "contentLength";
  static const _headers = "headers";
  static const _isRedirect = "isRedirect";
  static const _persistentConnection = "persistentConnection";

  Map<String, dynamic> toMap() {
    return {
      _statusCode: statusCode,
      _body: body,
      _reasonPhrase: reasonPhrase,
      _contentLength: contentLength,
      _headers: headers,
      _isRedirect: isRedirect,
      _persistentConnection: persistentConnection,
    };
  }
}
