import '../../../interactions/domain/usecases/create_interaction.dart';
import '../../domain/services/chat_service.dart';

class GeminiChatService implements ChatService {
  GeminiChatService(this._createInteraction);

  final CreateInteraction _createInteraction;
  String? _previousInteractionId;

  @override
  Future<String> sendMessage(String input) async {
    final interaction = await _createInteraction(
      input: input,
      previousInteractionId: _previousInteractionId,
    );

    _previousInteractionId = interaction.id;
    final response = interaction.text.trim();
    if (response.isEmpty) {
      throw StateError('Gemini returned an interaction with no text output.');
    }

    return response;
  }

  @override
  void startNewChat() {
    _previousInteractionId = null;
  }
}
