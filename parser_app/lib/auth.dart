import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

String _detectBase() {
  //release
  if (kIsWeb) return '';
  //dev
  //if (kIsWeb) return 'http://127.0.0.1:8000';
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

  Future<Uint8List> authedPostBytes(String path, {Object? body}) async {
    final resp = await _sendWithAuth('POST', path, body: body);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('request failed: ${resp.statusCode} ${resp.body}');
    }
    return resp.bodyBytes;
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
  String end,
  [String promocode = '']
  ) async {
    final resp = await authedPost('/api/get_cost/', body: {
      'data': matrix,
      'start': start,
      'end': end,
      'promo': promocode
    });
    print("request sent to /api/get_cost/");

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('getCost failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<Map<String, dynamic>> getPromos() async {
    final resp = await authedPost('/api/get_promos/');
    print("request sent to /api/get_promos/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('getPromos failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<Map<String, dynamic>> getAccounts() async {
    final resp = await authedPost('/api/get_accounts/');
    print("request sent to /api/get_accounts/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('getAccounts failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<Map<String, dynamic>> updatePromo(
    String promo,
    String newPromo,
    String percent
  ) async {
    final resp = await authedPost('/api/upd_promos/', body: {
      "promo": promo,
      "new_promo": newPromo,
      "percent": percent
    });
    print("request sent to /api/upd_promos/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('getPromos failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<Map<String, dynamic>> updateAccount(
    String oldEmail,
    String newEmail,
    String newPassword,
    bool isAdmin,
  ) async {
    final resp = await authedPost('/api/upd_accounts/', body: {
      "old_email": oldEmail,
      "new_email": newEmail,
      "new_password": newPassword,
      "is_admin": isAdmin,
    });
    print("request sent to /api/upd_accounts/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('updateAccount failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<Map<String, dynamic>> deletePromo(
    String promo,
  ) async {
    final resp = await authedPost('/api/del_promos/', body: {
      "promo": promo,
    });
    print("request sent to /api/del_promos/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('getPromos failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<Map<String, dynamic>> createAccount(
    String email,
    String password,
    bool isAdmin,
  ) async {
    final resp = await authedPost('/api/create_accounts/', body: {
      "email": email,
      "password": password,
      "is_admin": isAdmin,
    });
    print("request sent to /api/create_accounts/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('createAccount failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<Map<String, dynamic>> deleteAccount(
    String email,
  ) async {
    final resp = await authedPost('/api/del_accounts/', body: {
      "email": email,
    });
    print("request sent to /api/del_accounts/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('deleteAccount failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }

  Future<void> getEstimate(
    List<List<String>> matrix,
    String start,
    String end,
    [String promocode = '']
  ) async {
    final bytes = await authedPostBytes('/api/get_estimate_pdf/', body: {
      'data': matrix,
      'start': start,
      'end': end,
      'promo': promocode,
    });
    print("request sent to /api/get_estimate_pdf/");

    const fileName = 'smeta.pdf';

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement()
        ..href = url
        ..download = fileName
        ..target = '_blank'
        ..style.display = 'none';

      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();

      Future.delayed(const Duration(seconds: 1), () {
        html.Url.revokeObjectUrl(url);
      });
      return;
    }

    await Share.shareXFiles(
      [
        XFile.fromData(
          bytes,
          mimeType: 'application/pdf',
          name: fileName,
        ),
      ],
    );
  }

  Future<({Uint8List bytes, String name})?> _pickXlsxWeb() async {
    final input = html.FileUploadInputElement();
    input.accept = '.xlsx';
    input.multiple = false;
    input.click();

    await input.onChange.first;

    if (input.files == null || input.files!.isEmpty) {
      return null;
    }

    final file = input.files!.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;

    final result = reader.result;
    late final Uint8List bytes;

    if (result is ByteBuffer) {
      bytes = Uint8List.view(result);
    } else if (result is Uint8List) {
      bytes = result;
    } else if (result is List<int>) {
      bytes = Uint8List.fromList(result);
    } else {
      throw Exception('Не удалось прочитать файл');
    }

    return (bytes: bytes, name: file.name);
  }

  Future<Map<String, dynamic>> uploadCatalogExcel() async {
    late final Uint8List bytes;
    String fileName = 'catalog.xlsx';

    if (kIsWeb) {
      final picked = await _pickXlsxWeb();
      if (picked == null) {
        return {'status': 'cancelled'};
      }
      bytes = picked.bytes;
      fileName = picked.name;
    } else {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (picked == null || picked.files.isEmpty) {
        return {'status': 'cancelled'};
      }

      final file = picked.files.first;
      final pickedBytes = file.bytes;

      if (pickedBytes == null) {
        throw Exception('Не удалось прочитать файл');
      }

      bytes = pickedBytes;
      fileName = file.name.isNotEmpty ? file.name : 'catalog.xlsx';
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$base/api/upload_catalog_excel/'),
    );

    final (access, _) = await _store.read();
    if (access != null && access.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $access';
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('uploadCatalogExcel failed: ${response.statusCode} ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : {'status': 'error'};
  }

  Future<Map<String, dynamic>> clearCatalog() async {
    final resp = await authedPost('/api/clear_catalog/', body: {});
    print("request sent to /api/clear_catalog/");
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('clearCatalog failed: ${resp.statusCode} ${resp.body}');
    }
    final decoded = jsonDecode(resp.body);
    return decoded is Map<String, dynamic> ? decoded : {'result': decoded};
  }
}