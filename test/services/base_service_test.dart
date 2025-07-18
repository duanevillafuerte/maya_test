import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/objects/custom_exception.dart';
import 'package:myapp/services/base_service.dart';

import '../mocks/package_test.mocks.dart';

void main() {
  group("Test BaseService", () {
    late BaseService baseService;
    late Client mockClient;
    late String mockUrl;
    late Map<String, String> mockHeaders;
    late Map<String, dynamic> mockBody;
    late Map<String, dynamic> mockResult;
    setUpAll(() {
      mockClient = MockClient();
      baseService = BaseService(client: mockClient);
      mockUrl = "https://mock.url";

      mockHeaders = {HttpHeaders.contentTypeHeader: "application/json"};

      mockBody = {
        "test": "value 1",
        "testMap": {"item1": 1, "item2": "2", "item3": 3.00},
      };

      mockResult = {
        "test": "value 2",
        "testMap": {"item1": 3, "item2": "3", "item3": 4.00},
      };
    });

    tearDownAll(() {
      mockClient.close();
    });

    group("httpPost()", () {
      test("should return [Response] object", () async {
        // mock [mockClient.post()]
        when(
          mockClient.post(
            Uri.parse(mockUrl),
            body: json.encode(mockBody),
            headers: mockHeaders,
          ),
        ).thenAnswer((_) async {
          return Response(json.encode(mockResult), 200, headers: mockHeaders);
        });

        final response = await baseService.httpPost(
          url: mockUrl,
          body: mockBody,
          headers: mockHeaders,
        );

        expect(response, isA<Response>());

        expect(response.statusCode, 200);
        expect(json.decode(response.body), mockResult);
      });

      test("should throw [CustomException] on handled exceptions", () async {
        // mock [mockClient.post()]
        when(
          mockClient.post(
            Uri.parse(mockUrl),
            body: json.encode(mockBody),
            headers: mockHeaders,
          ),
        ).thenAnswer((_) async {
          throw Exception;
        });

        try {
          await baseService.httpPost(
            url: mockUrl,
            body: mockBody,
            headers: mockHeaders,
          );
        } catch (e) {
          expect(e, isA<CustomException>());
        }
      });
    });

    group("httpGet()", () {
      test("should return [Response] object", () async {
        // mock [mockClient.get()]
        when(
          mockClient.get(Uri.parse(mockUrl), headers: mockHeaders),
        ).thenAnswer((_) async {
          return Response(json.encode(mockResult), 200, headers: mockHeaders);
        });

        final response = await baseService.httpGet(
          url: mockUrl,
          headers: mockHeaders,
        );

        expect(response, isA<Response>());

        expect(response.statusCode, 200);
        expect(json.decode(response.body), mockResult);
      });

      test("should throw [CustomException] on handled exceptions", () async {
        // mock [mockClient.get()]
        when(
          mockClient.get(Uri.parse(mockUrl), headers: mockHeaders),
        ).thenAnswer((_) async {
          throw Exception;
        });

        try {
          await baseService.httpGet(url: mockUrl, headers: mockHeaders);
        } catch (e) {
          expect(e, isA<CustomException>());
        }
      });
    });
  });
}
