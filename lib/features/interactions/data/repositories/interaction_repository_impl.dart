import '../../domain/entities/interaction.dart';
import '../../domain/repositories/interaction_repository.dart';
import '../datasources/interactions_remote_data_source.dart';
import '../models/create_interaction_request.dart';

class InteractionRepositoryImpl implements InteractionRepository {
  const InteractionRepositoryImpl(this._remoteDataSource);

  final InteractionsRemoteDataSource _remoteDataSource;

  @override
  Future<Interaction> create({
    required String input,
    String model = 'gemini-3.8-flash',
    String? previousInteractionId,
  }) {
    return _remoteDataSource.createInteraction(
      CreateInteractionRequest(
        model: model,
        input: input,
        previousInteractionId: previousInteractionId,
      ),
    );
  }
}
