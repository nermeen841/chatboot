import '../entities/interaction.dart';
import '../repositories/interaction_repository.dart';

class CreateInteraction {
  const CreateInteraction(this._repository);

  final InteractionRepository _repository;

  Future<Interaction> call({
    required String input,
    String model = 'gemini-3.8-flash',
    String? previousInteractionId,
  }) {
    if (input.trim().isEmpty) {
      throw ArgumentError.value(input, 'input', 'Input must not be empty.');
    }

    return _repository.create(
      input: input,
      model: model,
      previousInteractionId: previousInteractionId,
    );
  }
}
