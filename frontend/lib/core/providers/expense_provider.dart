import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<ExpenseModel> _items = [];
  bool _loading = false;

  List<ExpenseModel> get items => List.unmodifiable(_items);
  bool get loading => _loading;

  Future<void> fetchExpenses() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await ApiService.get('/v2/expenses', auth: true);
      if (res.containsKey('expenses')) {
        final list = res['expenses'] as List<dynamic>;
        _items.clear();
        _items.addAll(list.map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>)));
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<ExpenseModel?> createExpense(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final res = await ApiService.post('/v2/expenses', body: data, auth: true);
      if (res.containsKey('id')) {
        final e = ExpenseModel.fromJson(res);
        _items.add(e);
        return e;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
    return null;
  }
}
