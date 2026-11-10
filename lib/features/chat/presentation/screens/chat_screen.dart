import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_error_message.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_message_composer.dart';
import '../widgets/chat_typing_indicator.dart';
import '../widgets/chat_welcome_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final input = _messageController.text.trim();
    if (input.isEmpty) return;
    _messageController.clear();
    context.read<ChatCubit>().sendMessage(input);
  }

  void _sendPrompt(String prompt) {
    _messageController.text = prompt;
    _sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<ChatCubit, ChatState>(
      listener: (_, _) => _scrollToBottom(),
      builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F8FC),
          titleSpacing: 20,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primaryContainer,
                child: Icon(Icons.auto_awesome, color: colors.primary),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gemini',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'AI assistant',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'New chat',
              onPressed: state.isSending
                  ? null
                  : context.read<ChatCubit>().startNewChat,
              icon: const Icon(Icons.add_comment_outlined),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: state.messages.isEmpty && state.errorMessage == null
                    ? ChatWelcomeView(onPromptSelected: _sendPrompt)
                    : ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                        children: [
                          for (final message in state.messages)
                            ChatMessageBubble(message: message),
                          if (state.isSending) const ChatTypingIndicator(),
                          if (state.errorMessage case final error?)
                            ChatErrorMessage(message: error),
                        ],
                      ),
              ),
              ChatMessageComposer(
                controller: _messageController,
                isSending: state.isSending,
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
