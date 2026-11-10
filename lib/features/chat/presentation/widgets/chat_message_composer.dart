import 'package:flutter/material.dart';

class ChatMessageComposer extends StatelessWidget {
  const ChatMessageComposer({
    required this.controller,
    required this.isSending,
    required this.onSend,
    super.key,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F8FC),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 4, 6, 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE1E4EC)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C172033),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('chatInput'),
                      controller: controller,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText: 'Message Gemini',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: IconButton.filled(
                      key: const Key('sendMessage'),
                      tooltip: 'Send message',
                      onPressed: isSending ? null : onSend,
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
