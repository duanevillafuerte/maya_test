import 'dart:convert';

import 'package:http/http.dart';
import 'package:myapp/objects/custom_exception.dart';
import 'package:myapp/objects/transaction.dart';
import 'package:myapp/services/base_service.dart';

class TransactionService extends BaseService {
  final String _url = "https://jsonplaceholder.typicode.com";

  TransactionService({super.client});

  /// Fetches [Transaction] list from backend.
  ///
  /// Throws an [CustomException] on handled exceptions.
  Future<List<Transaction>> getAll() async {
    Response response = await httpGet(url: "$_url/posts");

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        List data = jsonDecode(response.body);
        List<Transaction> transactions =
            data.map<Transaction>((json) {
              return Transaction.fromJson(json);
            }).toList();

        return transactions;
      } on FormatException catch (e) {
        throw CustomException(message: "Failed to format ${response.body}", stackTrace: StackTrace.current, cause: e);
      }
    } else {
      throw CustomException(code: response.statusCode.toString(), message: "getAll() failed : ${response.body}", stackTrace: StackTrace.current);
    }
  }

  /// Posts [transaction] into backend. Backend returns the newly posted [Transaction].
  ///
  /// Throws an [CustomException] on handled exceptions.
  Future<Transaction> post({required Transaction transaction}) async {
    Response response = await httpPost(url: "$_url/posts", body: transaction.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);
        return Transaction.fromJson(data);
      } on FormatException catch (e) {
        throw CustomException(message: "Failed to format ${response.body}", stackTrace: StackTrace.current, cause: e);
      }
    } else {
      throw CustomException(code: response.statusCode.toString(), message: "post() failed : ${response.body}", stackTrace: StackTrace.current);
    }
  }
}
