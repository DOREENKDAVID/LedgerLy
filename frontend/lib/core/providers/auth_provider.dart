import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;
  String? _token;

  bool get loading => _loading;
  String? get token => _token;

  Future<void> loadToken() async {
    _token = await ApiService.readToken();
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final res = await ApiService.login(email, password);
      _token = await ApiService.readToken();
      return res;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final res = await ApiService.register(email, password);
      _token = await ApiService.readToken();
      return res;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    _token = null;
    notifyListeners();
  }
}
