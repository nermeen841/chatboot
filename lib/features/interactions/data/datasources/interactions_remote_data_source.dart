import '../../../../services/api_client.dart';
import '../models/create_interaction_request.dart';
import '../models/interaction_response_model.dart';

class InteractionsRemoteDataSource {
  InteractionsRemoteDataSource({
    required this._apiClient,
    required String apiKey,
  }) : _apiKey = _validateApiKey(apiKey);

  final ApiClient _apiClient;
  final String _apiKey;

  Future<InteractionResponseModel> createInteraction(
    CreateInteractionRequest request,
  ) async {
    final response = await _apiClient.post(
      'interactions',
      body: request.toJson(),
      headers: {'x-goog-api-key': _apiKey, 'Api-Revision': '2026-05-20'},
    );

    if (response is! Map<String, Object?>) {
      throw const FormatException(
        'Expected the Interactions API to return a JSON object.',
      );
    }

    return InteractionResponseModel.fromJson(response);
  }

  static String _validateApiKey(String apiKey) {
    if (apiKey.trim().isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'API key must not be empty.');
    }
    return apiKey;
  }
}
