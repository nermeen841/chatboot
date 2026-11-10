abstract interface class ChatService {
  Future<String> sendMessage(String input);

  void startNewChat();
}
