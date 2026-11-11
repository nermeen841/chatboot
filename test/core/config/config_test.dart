import 'package:chatboot/core/config/config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Config.fromEnvironment', () {
    test('uses the selected flavor and configured values', () {
      final config = Config.fromEnvironment(
        flavor: 'staging',
        apiKey: 'test-key',
        baseUrl: 'https://staging.example.com/v1/',
      );

      expect(config.environment, 'staging');
      expect(config.apiKey, 'test-key');
      expect(config.baseUrl, 'https://staging.example.com/v1/');
      expect(config.isConfigured, isTrue);
    });

    test('defaults to development and the Gemini API URL', () {
      final config = Config.fromEnvironment(apiKey: '');

      expect(config.environment, 'development');
      expect(
        config.baseUrl,
        'https://generativelanguage.googleapis.com/v1beta/',
      );
      expect(config.isConfigured, isFalse);
    });

    test('rejects unknown flavors', () {
      expect(() => Config.fromEnvironment(flavor: 'qa'), throwsArgumentError);
    });
  });
}
