import 'package:chatboot/features/chat/domain/entities/chat_message.dart';
import 'package:chatboot/features/chat/domain/services/chat_service.dart';
import 'package:chatboot/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chatboot/features/chat/presentation/cubit/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emits sending then success when a message is answered', () async {
    final service = _FakeChatService();
    final cubit = ChatCubit(service);
    final states = <ChatState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.sendMessage(' Hello Gemini ');
    await Future<void>.delayed(Duration.zero);

    expect(service.sentMessages, ['Hello Gemini']);
    expect(states, hasLength(2));
    expect(states.first.status, ChatStatus.sending);
    expect(states.first.messages.single.role, ChatMessageRole.user);
    expect(states.last.status, ChatStatus.success);
    expect(states.last.messages.last.text, 'Hello from Gemini');

    await subscription.cancel();
    await cubit.close();
  });

  test(
    'shows an error and preserves the user message when request fails',
    () async {
      final cubit = ChatCubit(_FakeChatService(error: Exception('offline')));

      await cubit.sendMessage('Hello Gemini');

      expect(cubit.state.status, ChatStatus.failure);
      expect(cubit.state.messages.single.text, 'Hello Gemini');
      expect(cubit.state.errorMessage, contains('offline'));

      await cubit.close();
    },
  );

  test('ignores blank messages', () async {
    final service = _FakeChatService();
    final cubit = ChatCubit(service);

    await cubit.sendMessage('  ');

    expect(service.sentMessages, isEmpty);
    expect(cubit.state.messages, isEmpty);

    await cubit.close();
  });
}

class _FakeChatService implements ChatService {
  _FakeChatService({this.error});

  final Object? error;
  final List<String> sentMessages = [];

  @override
  Future<String> sendMessage(String input) async {
    sentMessages.add(input);
    if (error != null) throw error!;
    return 'Hello from Gemini';
  }

  @override
  void startNewChat() {}
}
