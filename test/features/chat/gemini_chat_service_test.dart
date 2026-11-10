import 'dart:convert';

import 'package:chatboot/core/di/app_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'dependency injection wires Gemini chat and continues conversations',
    () async {
      final requestBodies = <Map<String, dynamic>>[];
      var interactionNumber = 0;
      final dependencies = AppDependencies.create(
        apiKey: 'test-key',
        httpClient: MockClient((request) async {
          requestBodies.add(jsonDecode(request.body) as Map<String, dynamic>);
          interactionNumber++;
          return http.Response(
            jsonEncode({
              'id': 'interaction-$interactionNumber',
              'outputs': [
                {'type': 'text', 'text': 'reply $interactionNumber'},
              ],
            }),
            200,
          );
        }),
      );

      expect(await dependencies.chatService.sendMessage('first'), 'reply 1');
      expect(await dependencies.chatService.sendMessage('second'), 'reply 2');

      expect(requestBodies[0]['input'], 'first');
      expect(requestBodies[0].containsKey('previous_interaction_id'), isFalse);
      expect(requestBodies[1]['input'], 'second');
      expect(requestBodies[1]['previous_interaction_id'], 'interaction-1');

      dependencies.chatService.startNewChat();
      expect(
        await dependencies.chatService.sendMessage('new conversation'),
        'reply 3',
      );
      expect(requestBodies[2].containsKey('previous_interaction_id'), isFalse);

      dependencies.dispose();
    },
  );

  test('dependency injection rejects a missing API key', () {
    expect(() => AppDependencies.create(apiKey: ' '), throwsArgumentError);
  });
}
