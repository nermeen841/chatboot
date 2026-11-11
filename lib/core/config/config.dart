import 'package:flutter/services.dart';

class Config {
  const Config({
    required this.environment,
    required this.baseUrl,
    required this.apiKey,
  });

  factory Config.fromEnvironment({
    String? flavor,
    String? apiKey,
    String? baseUrl,
  }) {
    final environment = flavor ?? appFlavor ?? 'development';
    if (!const {'development', 'staging', 'production'}.contains(environment)) {
      throw ArgumentError.value(
        environment,
        'flavor',
        'Must be development, staging, or production.',
      );
    }

    return Config(
      environment: environment,
      baseUrl:
          baseUrl ??
          const String.fromEnvironment(
            'GEMINI_BASE_URL',
            defaultValue: 'https://generativelanguage.googleapis.com/v1beta/',
          ),
      apiKey: apiKey ?? const String.fromEnvironment('GEMINI_API_KEY'),
    );
  }

  final String environment;
  final String baseUrl;
  final String apiKey;

  bool get isConfigured => apiKey.trim().isNotEmpty;
}
