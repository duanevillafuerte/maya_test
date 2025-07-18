import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:myapp/extensions/http_response.dart';
import 'package:myapp/extensions/map.dart';
import 'package:myapp/objects/custom_exception.dart';

class BaseService {
  late http.Client? _client;

  /// Use [client] for replacing default [http.Client]. Just make sure to handle it's disposal.
  BaseService({http.Client? client}) {
    _client = client;
  }

  static _getDefaultHeaders() {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    return headers;
  }

  /// Executes an HTTP GET request using [package:http/http.dart].
  ///
  /// Runs on [Isolate].
  ///
  /// Throws an [CustomException] on handled exceptions.
  ///
  /// Use [headers] for replacing default [Map<String, String> headers].
  Future<http.Response> httpGet({
    required String url,
    Map<String, String>? headers,
  }) async {
    Map<String, String> h = _getDefaultHeaders();

    if (headers != null && headers.isNotEmpty) {
      for (String key in headers.keys) {
        h[key] = headers[key] ?? "";
      }
    }

    http.Client c = _client ?? http.Client();

    try {
      final uri = Uri.parse(url);

      Map<String, dynamic> result = await Isolate.run(() async {
        http.Response res = await c.get(uri, headers: h);
        return res.toMap();
      });

      http.Response response = result.toHttpResponse();
      return response;
    } on http.ClientException catch (e) {
      throw CustomException(
        message: e.message,
        cause: e,
        stackTrace: StackTrace.current,
      );
    } catch (e) {
      throw CustomException(
        message: e.toString(),
        stackTrace: StackTrace.current,
      );
    } finally {
      c.close();
    }
  }

  /// Executes an HTTP POST request using [package:http/http.dart].
  ///
  /// Runs on [Isolate]
  ///
  /// Throws an [CustomException] on handled exceptions.
  ///
  /// Use [client] for replacing default [http.Client].
  /// Use [headers] for replacing default [Map<String, String> headers].
  Future<http.Response> httpPost({
    required String url,
    required dynamic body,
    Map<String, String>? headers,
  }) async {
    Map<String, String> h = _getDefaultHeaders();

    if (headers != null && headers.isNotEmpty) {
      for (String key in headers.keys) {
        h[key] = headers[key] ?? "";
      }
    }

    http.Client c = _client ?? http.Client();

    try {
      final uri = Uri.parse(url);

      Map<String, dynamic> result = await Isolate.run(() async {
        http.Response res = await c.post(
          uri,
          body: jsonEncode(body),
          headers: h,
        );
        return res.toMap();
      });

      http.Response response = result.toHttpResponse();
      return response;
    } on http.ClientException catch (e) {
      throw CustomException(
        message: e.message,
        cause: e,
        stackTrace: StackTrace.current,
      );
    } catch (e) {
      throw CustomException(
        message: e.toString(),
        stackTrace: StackTrace.current,
      );
    } finally {
      c.close();
    }
  }
}
