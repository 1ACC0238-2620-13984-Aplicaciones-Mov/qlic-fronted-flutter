import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../session/session_notifier.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(this._session, {http.Client? client})
      : _http = client ?? http.Client();

  final SessionNotifier _session;
  final http.Client _http;

  static const _timeout = Duration(seconds: 60);

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<dynamic> patch(String path, {Object? body}) =>
      _send('PATCH', path, body: body);

  Future<dynamic> _send(
      String method,
      String path, {
        Map<String, String>? query,
        Object? body,
      }) async {
    final uri =
    Uri.parse('${AppConfig.apiBaseUrl}$path').replace(queryParameters: query);
    final isPublic = path.contains('/authentication/');
    final token = isPublic ? null : _session.session?.token;
    final language =
    PlatformDispatcher.instance.locale.languageCode == 'es' ? 'es-419' : 'en';

    final request = http.Request(method, uri)
      ..headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': language,
        if (token != null) 'Authorization': 'Bearer $token',
      });
    if (body != null) request.body = jsonEncode(body);

    try {
      final streamed = await _http.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 401 && token != null) {
        await _session.signOut();
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return null;
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      throw ApiException(_detail(response), response.statusCode);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }
  }

  String _detail(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map && body['detail'] is String) return body['detail'] as String;
    } catch (_) {}
    return response.reasonPhrase ?? 'HTTP ${response.statusCode}';
  }
}