import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_html/html.dart' as html;

String _detectBase() {
  if (kIsWeb) return 'http://127.0.0.1:8000';
  if (Platform.isAndroid) return 'http://10.0.2.2:8000';
  return 'http://127.0.0.1:8000';
}

class _TokenStore {
  final _sec = const FlutterSecureStorage();

  Future<void> save(String access, String refresh) async {
    if (kIsWeb) {
      html.window.localStorage['access'] = access;
      html.window.localStorage['refresh'] = refresh;
    } else {
      await _sec.write(key: 'access', value: access);
      await _sec.write(key: 'refresh', value: refresh);
    }
  }

  Future<(String?, String?)> read() async {
    if (kIsWeb) {
      return (
        html.window.localStorage['access'],
        html.window.localStorage['refresh'],
      );
    } else {
      return (await _sec.read(key: 'access'), await _sec.read(key: 'refresh'));
    }
  }

  Future<void> clear() async {
    if (kIsWeb) {
      html.window.localStorage.remove('access');
      html.window.localStorage.remove('refresh');
    } else {
      await _sec.delete(key: 'access');
      await _sec.delete(key: 'refresh');
    }
  }
}

class Api {
  static final Api I = Api._();
  Api._();

  final _client = http.Client();
  final _store = _TokenStore();
  final String base = _detectBase();

  // ===== auth =====
  Future<void> login(String username, String password) async {
    final r = await _client.post(
      Uri.parse('$base/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (r.statusCode != 200) {
      throw Exception('login failed: ${r.statusCode} ${r.body}');
    }
    final json = jsonDecode(r.body) as Map<String, dynamic>;
    await _store.save(json['access'] as String, json['refresh'] as String);
  }

  Future<Map<String, dynamic>> me() async {
    final resp = await authedGet('/api/me/');
    if (resp.statusCode != 200)
      throw Exception('me failed: ${resp.statusCode}');
    return Map<String, dynamic>.from(jsonDecode(resp.body));
  }

  Future<void> logout() async {
    final (_, refresh) = await _store.read();
    try {
      await authedPost('/api/logout/', body: {'refresh': refresh});
    } catch (_) {}
    await _store.clear();
  }

  // ===== request helpers =====
  Future<http.Response> authedGet(
    String path, {
    Map<String, String>? query,
  }) async {
    return _sendWithAuth('GET', path, query: query);
  }

  Future<http.Response> authedPost(String path, {Object? body}) async {
    return _sendWithAuth('POST', path, body: body);
  }

  Future<http.Response> _sendWithAuth(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final (access, refresh) = await _store.read();
    final uri = Uri.parse('$base$path').replace(queryParameters: query);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (access != null && access.isNotEmpty)
        'Authorization': 'Bearer $access',
    };

    http.Response r;
    if (method == 'GET') {
      r = await _client.get(uri, headers: headers);
    } else {
      r = await _client.post(
        uri,
        headers: headers,
        body: jsonEncode(body ?? {}),
      );
    }

    if (r.statusCode != 401) return r;

    if (refresh == null || refresh.isEmpty) return r;
    final ok = await _tryRefresh(refresh);
    if (!ok) return r;

    final (newAccess, _) = await _store.read();
    final retryHeaders = Map<String, String>.from(headers);
    if (newAccess != null) retryHeaders['Authorization'] = 'Bearer $newAccess';

    if (method == 'GET') {
      return _client.get(uri, headers: retryHeaders);
    } else {
      return _client.post(
        uri,
        headers: retryHeaders,
        body: jsonEncode(body ?? {}),
      );
    }
  }

  Future<bool> _tryRefresh(String refresh) async {
    final r = await _client.post(
      Uri.parse('$base/api/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );
    if (r.statusCode != 200) {
      await _store.clear();
      return false;
    }
    final json = jsonDecode(r.body) as Map<String, dynamic>;
    final access = json['access'] as String?;
    final newRefresh = (json['refresh'] as String?) ?? refresh;
    if (access == null) return false;
    await _store.save(access, newRefresh);
    return true;
  }

  Future<Map<String, dynamic>> getCost(
  List<List<String>> matrix,
  String start,
  String end
  ) async {
    final resp = await authedPost('/api/get_cost/', body: {
      'data': matrix,
      'start': start,
      'end': end
    });
    print("request sent to /api/get_cost/");

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('getCost failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }
}