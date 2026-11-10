class CreateInteractionRequest {
  const CreateInteractionRequest({
    required this.model,
    required this.input,
    this.previousInteractionId,
  });

  final String model;
  final String input;
  final String? previousInteractionId;

  Map<String, Object?> toJson() => {
    'model': model,
    'input': input,
    if (previousInteractionId != null)
      'previous_interaction_id': previousInteractionId,
  };
}
