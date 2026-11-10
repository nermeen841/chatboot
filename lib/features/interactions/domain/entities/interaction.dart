class Interaction {
  const Interaction({
    this.id,
    this.model,
    this.status,
    this.outputs = const [],
  });

  final String? id;
  final String? model;
  final String? status;
  final List<InteractionOutput> outputs;

  String get text => outputs
      .where((output) => output.type == 'text')
      .map((output) => output.text ?? '')
      .join();
}

class InteractionOutput {
  const InteractionOutput({required this.type, this.text});

  final String type;
  final String? text;
}
