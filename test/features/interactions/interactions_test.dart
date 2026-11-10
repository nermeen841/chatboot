import 'dart:convert';

import 'package:chatboot/features/interactions/data/datasources/interactions_remote_data_source.dart';
import 'package:chatboot/features/interactions/data/repositories/interaction_repository_impl.dart';
import 'package:chatboot/features/interactions/domain/entities/interaction.dart';
import 'package:chatboot/features/interactions/domain/repositories/interaction_repository.dart';
import 'package:chatboot/features/interactions/domain/usecases/create_interaction.dart';
import 'package:chatboot/services/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CreateInteraction', () {
    test('posts the request and parses a text response', () async {
      late http.Request capturedRequest;
      final apiClient = ApiClient(
        baseUri: Uri.parse('https://generativelanguage.googleapis.com/v1beta/'),
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'id': 'interaction-1',
              'model': 'gemini-3.8-flash',
              'status': 'completed',
              'outputs': [
                {'type': 'text', 'text': 'AI learns patterns.'},
              ],
            }),
            200,
          );
        }),
      );
      final dataSource = InteractionsRemoteDataSource(
        apiClient: apiClient,
        apiKey: 'test-key',
      );
      final repository = InteractionRepositoryImpl(dataSource);
      final createInteraction = CreateInteraction(repository);

      final result = await createInteraction(input: 'How does AI work?');

      expect(capturedRequest.method, 'POST');
      expect(
        capturedRequest.url,
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/interactions',
        ),
      );
      expect(capturedRequest.headers['x-goog-api-key'], 'test-key');
      expect(capturedRequest.headers['api-revision'], '2026-05-20');
      expect(jsonDecode(capturedRequest.body), {
        'model': 'gemini-3.8-flash',
        'input': 'How does AI work?',
      });
      expect(result.id, 'interaction-1');
      expect(result.text, 'AI learns patterns.');

      apiClient.close();
    });

    test('rejects empty input before calling the repository', () {
      final useCase = CreateInteraction(_UnusedRepository());

      expect(() => useCase(input: '  '), throwsArgumentError);
    });
  });
}

class _UnusedRepository implements InteractionRepository {
  @override
  Future<Interaction> create({
    required String input,
    String model = 'gemini-3.8-flash',
    String? previousInteractionId,
  }) {
    throw StateError('Repository should not be called for empty input.');
  }
}
