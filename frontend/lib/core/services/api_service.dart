import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    return 'https://ledgerly-r5gk.onrender.com/api';
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

  // Normalize path to ensure it starts with a '/'
  static String _normalizePath(String path) {
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    if (kDebugMode) debugPrint('Normalized path: $path');
    return path;
  }

  // Generic GET helper
  static Future<Map<String, dynamic>> get(String path, {bool auth = false}) async {
    path = _normalizePath(path);
    final uri = Uri.parse('${ApiService.baseUrl}$path');
    if (kDebugMode) debugPrint('ApiService GET: $uri');
    final headers = await _defaultHeaders(auth: auth);
    final resp = await http.get(uri, headers: headers);
    return _parseResponse(resp);
  }

  // Generic POST helper
  static Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body, bool auth = false}) async {
    path = _normalizePath(path);
    final uri = Uri.parse('${ApiService.baseUrl}$path');
    if (kDebugMode) debugPrint('ApiService POST: $uri  body=${jsonEncode(body)}');
    final headers = await _defaultHeaders(auth: auth);
    final resp = await http.post(uri, headers: headers, body: jsonEncode(body ?? {}));
    return _parseResponse(resp);
  }

  // Generic PUT helper
  static Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body, bool auth = false}) async {
    path = _normalizePath(path);
    final uri = Uri.parse('${ApiService.baseUrl}$path');
    if (kDebugMode) debugPrint('ApiService PUT: $uri  body=${jsonEncode(body)}');
    final headers = await _defaultHeaders(auth: auth);
    final resp = await http.put(uri, headers: headers, body: jsonEncode(body ?? {}));
    return _parseResponse(resp);
  }

  // Generic DELETE helper
  static Future<Map<String, dynamic>> delete(String path, {bool auth = false}) async {
    path = _normalizePath(path);
    final uri = Uri.parse('${ApiService.baseUrl}$path');
    if (kDebugMode) debugPrint('ApiService DELETE: $uri');
    final headers = await _defaultHeaders(auth: auth);
    final resp = await http.delete(uri, headers: headers);
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
    try {
      final res = await post('/auth/login', body: {'email': email, 'password': password}, auth: false);

      if (res.containsKey('token')) {
        await saveToken(res['token'] as String);
      } else {
        debugPrint('Login failed: Token not found in response');
        res['token'] = null; // Fallback
      }

      if (!res.containsKey('firstTime')) {
        debugPrint('Login failed: Missing firstTime field in response');
        res['firstTime'] = false; // Default to false
      }

      return res;
    } catch (e) {
      debugPrint('Login failed: ${e.toString()}');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Register a new user
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
      return await get('/v3/insights', auth: true);
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

  // ================= BUSINESS ROUTES =================

// Fetch all businesses
static Future<List<dynamic>> fetchAllBusinesses() async {
  final res = await get('/v1/business', auth: true);
  return res['userbusiness'] ?? [];
}

// Add a new business ✅ FIXED
static Future<Map<String, dynamic>> addBusiness(
    Map<String, dynamic> businessData) async {
  final res = await post('/v1/business',
      body: businessData, auth: true);

  return res;
}

// Update business
static Future<Map<String, dynamic>> updateBusiness(
    String id, Map<String, dynamic> businessData) async {
  return await put('/v1/business/$id',
      body: businessData, auth: true);
}

// Delete business
static Future<void> deleteBusiness(String id) async {
  await delete('/v1/business/$id', auth: true);
}

// Get business by ID
static Future<Map<String, dynamic>> fetchBusinessById(String id) async {
  final uri = Uri.parse('${ApiService.baseUrl}/v1/business/$id');
  final headers = await _defaultHeaders(auth: true);
  final resp = await http.get(uri, headers: headers);

  if (resp.statusCode == 200) {
    return jsonDecode(resp.body);
  } else {
    throw ApiException('Failed to fetch business details', resp.statusCode);
  }
}

// Add a new product
  static Future<Map<String, dynamic>> addProduct(Map<String, dynamic> productData) async {
    return await post('/v1/products', body: productData, auth: true);
  }

  // ================= AUTHENTICATION ROUTES =================

  // Forgot Password
  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw ApiException('Failed to send forgot password email', response.statusCode);
    }
  }

  // Resend OTP
  static Future<void> resendOtp(String email) async {
    final response = await http.post(
      Uri.parse('/auth/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw ApiException('Failed to resend OTP', response.statusCode);
    }
  }

  // Validate OTP
  static Future<void> validateOtp(Map<String, dynamic> otpData) async {
    final response = await http.post(
      Uri.parse('/auth/validate-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(otpData),
    );

    if (response.statusCode != 200) {
      throw ApiException('Failed to validate OTP', response.statusCode);
    }
  }

  // Reset Password
  static Future<void> resetPassword(Map<String, dynamic> resetData) async {
    final response = await http.post(
      Uri.parse('/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(resetData),
    );

    if (response.statusCode != 200) {
      throw ApiException('Failed to reset password', response.statusCode);
    }
  }

  // Verify Email OTP
  static Future<void> verifyEmailOtp(Map<String, dynamic> otpData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-email-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(otpData),
    );

    if (response.statusCode != 200) {
      throw ApiException('Failed to verify email OTP', response.statusCode);
    }
  }

  static Future<bool> validateToken(String token) async {
    final uri = Uri.parse('${ApiService.baseUrl}/auth/validate-token');
    final headers = {'Authorization': 'Bearer $token'};
    final resp = await http.get(uri, headers: headers);
    return resp.statusCode == 200;
  }
}
