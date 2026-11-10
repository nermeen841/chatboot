import 'package:http/http.dart' as http;

import '../../features/chat/data/services/gemini_chat_service.dart';
import '../../features/chat/domain/services/chat_service.dart';
import '../../features/interactions/data/datasources/interactions_remote_data_source.dart';
import '../../features/interactions/data/repositories/interaction_repository_impl.dart';
import '../../features/interactions/domain/usecases/create_interaction.dart';
import '../../services/api_client.dart';

class AppDependencies {
  AppDependencies._({required this._apiClient, required this.chatService});

  factory AppDependencies.create({
    required String apiKey,
    http.Client? httpClient,
  }) {
    if (apiKey.trim().isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'API key must not be empty.');
    }

    final apiClient = ApiClient(
      baseUri: Uri.parse('https://generativelanguage.googleapis.com/v1beta/'),
      client: httpClient,
    );
    final remoteDataSource = InteractionsRemoteDataSource(
      apiClient: apiClient,
      apiKey: apiKey,
    );
    final repository = InteractionRepositoryImpl(remoteDataSource);
    final createInteraction = CreateInteraction(repository);

    return AppDependencies._(
      apiClient: apiClient,
      chatService: GeminiChatService(createInteraction),
    );
  }

  final ApiClient _apiClient;
  final ChatService chatService;

  void dispose() {
    _apiClient.close();
  }
}
