import 'package:flutter/material.dart';

import '../../domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser ? colors.primary : Colors.white,
            borderRadius: BorderRadius.circular(18).copyWith(
              bottomRight: message.isUser
                  ? const Radius.circular(5)
                  : const Radius.circular(18),
              bottomLeft: message.isUser
                  ? const Radius.circular(18)
                  : const Radius.circular(5),
            ),
            border: message.isUser
                ? null
                : Border.all(color: const Color(0xFFE7E9F0)),
          ),
          child: SelectableText(
            message.text,
            style: TextStyle(
              height: 1.4,
              color: message.isUser ? colors.onPrimary : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
