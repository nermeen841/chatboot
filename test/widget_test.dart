import 'package:chatboot/features/chat/domain/services/chat_service.dart';
import 'package:chatboot/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chatboot/features/chat/presentation/screens/chat_screen.dart';
import 'package:chatboot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows setup guidance when no API key is configured', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Gemini is not configured'), findsOneWidget);
    expect(find.textContaining('--dart-define'), findsOneWidget);
  });

  testWidgets('sends a message and displays the assistant response', (
    tester,
  ) async {
    final service = _FakeChatService();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => ChatCubit(service),
          child: const ChatScreen(),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('chatInput')), 'Hello Gemini');
    await tester.tap(find.byKey(const Key('sendMessage')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(service.sentMessages, ['Hello Gemini']);
    expect(find.text('Hello Gemini'), findsOneWidget);
    expect(find.text('Hello from Gemini'), findsOneWidget);
  });

  testWidgets('new chat clears messages and starts a fresh conversation', (
    tester,
  ) async {
    final service = _FakeChatService();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => ChatCubit(service),
          child: const ChatScreen(),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('chatInput')), 'Hello');
    await tester.tap(find.byKey(const Key('sendMessage')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('New chat'));
    await tester.pumpAndSettle();

    expect(service.newChatCount, 1);
    expect(find.text('Hello'), findsNothing);
    expect(find.text('Hello from Gemini'), findsNothing);
    expect(find.text('What can I help with?'), findsOneWidget);
  });
}

class _FakeChatService implements ChatService {
  final List<String> sentMessages = [];
  int newChatCount = 0;

  @override
  Future<String> sendMessage(String input) async {
    sentMessages.add(input);
    return 'Hello from Gemini';
  }

  @override
  void startNewChat() {
    newChatCount++;
  }
}
