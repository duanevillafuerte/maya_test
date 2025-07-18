import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/objects/custom_exception.dart';
import 'package:myapp/objects/transaction.dart';
import 'package:myapp/services/transaction_service.dart';

import '../mocks/package_test.mocks.dart';

void main() {
  group("Test TransactionService", () {
    late TransactionService transactionService;
    late Client mockClient;
    late String url;
    late Map<String, String> mockHeaders;
    setUpAll(() {
      mockClient = MockClient();
      transactionService = TransactionService(client: mockClient);

      url = "https://jsonplaceholder.typicode.com";
      mockHeaders = {HttpHeaders.contentTypeHeader: "application/json"};
    });

    tearDownAll(() {
      mockClient.close();
    });

    group("post()", () {
      test("should return newly posted [Transaction] object", () async {
        Transaction mockTransaction = Transaction(title: "Grocery", body: "Weekly needs for the month of July.", amount: 15000.00);

        // mock [mockClient.post()]
        when(mockClient.post(Uri.parse("$url/posts"), body: json.encode(mockTransaction.toJson()), headers: mockHeaders)).thenAnswer((_) async {
          return Response(json.encode({"userId": 1000, "id": 999, "title": "Grocery_", "body": "Weekly needs for the month of July._", "amount": 15000}), 200, headers: mockHeaders);
        });

        Transaction postedTransaction = await transactionService.post(transaction: mockTransaction);

        expect(postedTransaction.userId, 1000);
        expect(postedTransaction.id, 999);
        expect(postedTransaction.title, "Grocery_");
        expect(postedTransaction.body, "Weekly needs for the month of July._");
        expect(postedTransaction.amount, 15000);
      });

      test("should throw [CustomException] on handled exceptions", () async {
        Transaction mockTransaction = Transaction(title: "Grocery", body: "Weekly needs for the month of July.", amount: 15000.00);

        // mock [mockClient.post()]
        when(mockClient.post(Uri.parse("$url/posts"), body: json.encode(mockTransaction.toJson()), headers: mockHeaders)).thenAnswer((_) async {
          throw Exception;
        });

        try {
          await transactionService.post(transaction: mockTransaction);
        } catch (e) {
          expect(e, isA<CustomException>());
        }
      });
    });

    group("getAll()", () {
      test("should return [Transaction] list", () async {
        var mockResult = [
          {"userId": 1, "id": 1, "title": "Grocery_", "body": "Weekly needs for the month of July._", "amount": 15000},
          {"userId": 1, "id": 2, "title": "qui est esse", "body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"},
          {"userId": 1, "id": 3, "title": "ea molestias quasi exercitationem repellat qui ipsa sit aut", "body": "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut"},
          {"userId": 1, "id": 4, "title": "Tuition", "body": "First sem", "amount": 40000},
        ];

        // mock [mockClient.get()]
        when(mockClient.get(Uri.parse("$url/posts"), headers: mockHeaders)).thenAnswer((_) async {
          return Response(json.encode(mockResult), 200, headers: mockHeaders);
        });

        List<Transaction> transactions = await transactionService.getAll();

        expect(transactions.length, 4);
        expect(transactions.first.id, 1);
        expect(transactions.first.title, "Grocery_");
        expect(transactions.first.body, "Weekly needs for the month of July._");
        expect(transactions.first.amount, 15000);
        expect(transactions.last.id, 4);
        expect(transactions.last.title, "Tuition");
        expect(transactions.last.body, "First sem");
        expect(transactions.last.amount, 40000);
      });

      test("should throw [CustomException] on handled exceptions", () async {
        // mock [mockClient.get()]
        when(mockClient.get(Uri.parse("$url/posts"), headers: mockHeaders)).thenAnswer((_) async {
          throw Exception;
        });

        try {
          await transactionService.getAll();
        } catch (e) {
          expect(e, isA<CustomException>());
        }
      });
    });
  });
}
