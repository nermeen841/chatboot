import '../../domain/entities/interaction.dart';

class InteractionResponseModel extends Interaction {
  const InteractionResponseModel({
    super.id,
    super.model,
    super.status,
    super.outputs,
  });

  factory InteractionResponseModel.fromJson(Map<String, Object?> json) {
    final rawOutputs = json['outputs'];
    if (rawOutputs != null && rawOutputs is! List) {
      throw const FormatException('Interaction outputs must be a list.');
    }

    final outputs = (rawOutputs as List<Object?>? ?? const [])
        .map((output) {
          if (output is! Map<String, Object?>) {
            throw const FormatException(
              'Each interaction output must be an object.',
            );
          }

          final type = output['type'];
          final text = output['text'];
          if (type is! String || (text != null && text is! String)) {
            throw const FormatException(
              'Interaction output must have a string type and optional text.',
            );
          }

          return InteractionOutput(type: type, text: text as String?);
        })
        .toList(growable: false);

    return InteractionResponseModel(
      id: _optionalString(json, 'id'),
      model: _optionalString(json, 'model'),
      status: _optionalString(json, 'status'),
      outputs: outputs,
    );
  }

  static String? _optionalString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value != null && value is! String) {
      throw FormatException('Interaction $key must be a string.');
    }
    return value as String?;
  }
}
