import '../../domain/entities/chat_message.dart';

enum ChatStatus { initial, sending, success, failure }

class ChatState {
  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final ChatStatus status;
  final String? errorMessage;

  bool get isSending => status == ChatStatus.sending;

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
