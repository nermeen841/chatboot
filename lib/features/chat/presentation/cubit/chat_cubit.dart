import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/services/chat_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._chatService) : super(const ChatState());

  final ChatService _chatService;

  Future<void> sendMessage(String input) async {
    final message = input.trim();
    if (message.isEmpty || state.isSending) return;

    emit(
      state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(text: message, role: ChatMessageRole.user),
        ],
        status: ChatStatus.sending,
        clearError: true,
      ),
    );

    try {
      final response = await _chatService.sendMessage(message);
      if (isClosed) return;
      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            ChatMessage(text: response, role: ChatMessageRole.assistant),
          ],
          status: ChatStatus.success,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ChatStatus.failure,
          errorMessage: 'Could not get a response. $error',
        ),
      );
    }
  }

  void startNewChat() {
    if (state.isSending) return;
    _chatService.startNewChat();
    emit(const ChatState());
  }
}
