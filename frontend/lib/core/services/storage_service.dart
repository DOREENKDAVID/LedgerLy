import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _profitKey = 'total_profit';
  static const String _goalKey = 'monthly_goal';

  // This is what the Dashboard is looking for
  static Future<double> getProfit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_profitKey) ?? 0.0;
  }

  // This is what the Dashboard is looking for
  static Future<double> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_goalKey) ?? 500000.0;
  }

  static Future<void> saveProfit(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_profitKey, amount);
  }
}