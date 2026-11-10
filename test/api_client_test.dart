import 'dart:convert';

import 'package:chatboot/services/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiClient', () {
    test(
      'sends JSON requests with base path, query, and merged headers',
      () async {
        late http.Request capturedRequest;
        final client = ApiClient(
          baseUri: Uri.parse('https://example.com/api'),
          client: MockClient((request) async {
            capturedRequest = request;
            return http.Response('{"id":7}', 200);
          }),
          defaultHeaders: const {'Authorization': 'Bearer token'},
        );

        final result = await client.post(
          '/messages',
          queryParameters: const {'page': '2'},
          headers: const {'X-Request-ID': 'abc'},
          body: const {'text': 'hello'},
        );

        expect(capturedRequest.method, 'POST');
        expect(
          capturedRequest.url,
          Uri.parse('https://example.com/api/messages?page=2'),
        );
        expect(capturedRequest.headers['authorization'], 'Bearer token');
        expect(capturedRequest.headers['x-request-id'], 'abc');
        expect(jsonDecode(capturedRequest.body), {'text': 'hello'});
        expect(result, {'id': 7});

        client.close();
      },
    );

    test('GET returns null for an empty success response', () async {
      final client = ApiClient(
        baseUri: Uri.parse('https://example.com'),
        client: MockClient((_) async => http.Response('', 204)),
      );

      expect(await client.get('/messages/1'), isNull);
      client.close();
    });

    test('throws ApiException with the response status and body', () async {
      final client = ApiClient(
        baseUri: Uri.parse('https://example.com'),
        client: MockClient(
          (_) async => http.Response('{"error":"unauthorized"}', 401),
        ),
      );

      await expectLater(
        client.get('/profile'),
        throwsA(
          isA<ApiException>()
              .having((error) => error.statusCode, 'statusCode', 401)
              .having((error) => error.responseBody, 'responseBody', {
                'error': 'unauthorized',
              }),
        ),
      );
      client.close();
    });

    test('rejects a non-HTTP base URI', () {
      expect(() => ApiClient(baseUri: Uri.parse('/api')), throwsArgumentError);
    });
  });
}
