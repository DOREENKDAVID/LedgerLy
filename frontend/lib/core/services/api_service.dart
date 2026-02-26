import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  // Base URL selection depending on platform.
  // - Android emulator (AVD) uses 10.0.2.2 to reach host machine
  // - Web / iOS simulator / desktop can use localhost
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:5000/api';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return 'http://localhost:5000/api';
    }
  }

  // secure storage for token
  static const _secureStorage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  // Save token
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  static Future<String?> readToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  static Future<Map<String, String>> _defaultHeaders({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await readToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // Generic GET helper
  static Future<Map<String, dynamic>> get(String path, {bool auth = false}) async {
    final uri = Uri.parse('${ApiService.baseUrl}$path');
    if (kDebugMode) debugPrint('ApiService GET: $uri');
    final headers = await _defaultHeaders(auth: auth);
    final resp = await http.get(uri, headers: headers);
    return _parseResponse(resp);
  }

  // Generic POST helper
  static Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body, bool auth = false}) async {
    final uri = Uri.parse('${ApiService.baseUrl}$path');
    if (kDebugMode) debugPrint('ApiService POST: $uri  body=${jsonEncode(body)}');
    final headers = await _defaultHeaders(auth: auth);
    final resp = await http.post(uri, headers: headers, body: jsonEncode(body ?? {}));
    return _parseResponse(resp);
  }

  static Map<String, dynamic> _parseResponse(http.Response resp) {
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      if (resp.body.isEmpty) return {};
      try {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      } catch (e) {
        return {'raw': resp.body};
      }
    }

    String message = 'Request failed with status: ${resp.statusCode}';
    try {
      final decoded = jsonDecode(resp.body);
      if (decoded is Map && decoded['message'] != null) {
        message = decoded['message'].toString();
      }
    } catch (_) {}

    throw ApiException(message, resp.statusCode);
  }

  // Authentication helpers
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await post('/auth/login', body: {'email': email, 'password': password}, auth: false);
    if (res.containsKey('token')) {
      await saveToken(res['token'] as String);
    }
    return res;
  }

  static Future<Map<String, dynamic>> register(String email, String password) async {
    final res = await post('/auth/register', body: {'email': email, 'password': password}, auth: false);
    if (res.containsKey('token')) {
      await saveToken(res['token'] as String);
    }
    return res;
  }

  static Future<void> logout() async {
    await deleteToken();
  }

  // Example specialized endpoints
  static Future<Map<String, dynamic>> fetchProfitSummary() async {
    try {
      return await get('/dashboard/summary', auth: true);
    } catch (e) {
      if (kDebugMode) print('fetchProfitSummary error: $e');
      // safe fallback
      return {
        'net_profit': 0.0,
        'revenue': 0.0,
        'expenses': 0.0,
      };
    }
  }
}
