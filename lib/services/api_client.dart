import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({
    required Uri baseUri,
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
    Map<String, String> defaultHeaders = const {},
  }) : _client = client ?? http.Client(),
       _defaultHeaders = {
         'Accept': 'application/json',
         'Content-Type': 'application/json',
         ...defaultHeaders,
       },
       baseUri = _normalizeBaseUri(baseUri);

  final Uri baseUri;
  final Duration timeout;
  final http.Client _client;
  final Map<String, String> _defaultHeaders;

  Future<Object?> get(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _request(
      'GET',
      path,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<Object?> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _request(
      'POST',
      path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  void close() {
    _client.close();
  }

  Future<Object?> _request(
    String method,
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final request = http.Request(method, _buildUri(path, queryParameters))
      ..headers.addAll({..._defaultHeaders, ...?headers});

    if (body != null) {
      request.body = jsonEncode(body);
    }

    final response = await _send(request).timeout(timeout);
    final responseBody = _decodeResponseBody(response.bodyBytes);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        responseBody: responseBody,
      );
    }

    return responseBody;
  }

  Future<http.Response> _send(http.Request request) async {
    final streamedResponse = await _client.send(request);
    return http.Response.fromStream(streamedResponse);
  }

  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    final relativePath = path.startsWith('/') ? path.substring(1) : path;
    final uri = baseUri.resolve(relativePath);
    if (queryParameters == null) {
      return uri;
    }

    return uri.replace(
      queryParameters: {...uri.queryParameters, ...queryParameters},
    );
  }

  static Uri _normalizeBaseUri(Uri uri) {
    if (!uri.isAbsolute ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw ArgumentError.value(
        uri,
        'baseUri',
        'Must be an absolute HTTP or HTTPS URI.',
      );
    }

    final path = uri.path.endsWith('/') ? uri.path : '${uri.path}/';
    return uri.replace(path: path, query: null, fragment: null);
  }

  Object? _decodeResponseBody(List<int> bodyBytes) {
    if (bodyBytes.isEmpty) {
      return null;
    }

    final body = utf8.decode(bodyBytes);
    return jsonDecode(body);
  }
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, this.responseBody});

  final int statusCode;
  final Object? responseBody;

  @override
  String toString() => 'ApiException: HTTP $statusCode ($responseBody)';
}
