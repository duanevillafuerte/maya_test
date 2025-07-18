import 'package:http/http.dart';

extension MapParser on Map {
  static const _statusCode = "statusCode";
  static const _body = "body";
  static const _reasonPhrase = "reasonPhrase";
  static const _headers = "headers";
  static const _isRedirect = "isRedirect";
  static const _persistentConnection = "persistentConnection";

  Response toHttpResponse() {
    return Response(
      this[_body] ?? "",
      this[_statusCode] ?? 0,
      headers: Map<String, String>.from(this[_headers] ?? const {}),
      reasonPhrase: this[_reasonPhrase],
      isRedirect: this[_isRedirect] ?? false,
      persistentConnection: this[_persistentConnection] ?? true,
    );
  }
}
