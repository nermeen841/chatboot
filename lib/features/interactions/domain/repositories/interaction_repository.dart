import '../entities/interaction.dart';

abstract interface class InteractionRepository {
  Future<Interaction> create({
    required String input,
    String model = 'gemini-3.8-flash',
    String? previousInteractionId,
  });
}
