import 'package:flutter/foundation.dart';

/// Lightweight analytics abstraction.
/// Default implementation logs to console; swap in a real SDK if needed.
abstract class AnalyticsService {
  void logEvent(String name, [Map<String, dynamic>? params]);
  void setUserId(String? id);
}

class _ConsoleAnalytics implements AnalyticsService {
  @override
  void logEvent(String name, [Map<String, dynamic>? params]) {
    debugPrint('Analytics event: $name ${params ?? {}}');
  }

  @override
  void setUserId(String? id) {
    debugPrint('Analytics setUserId: $id');
  }
}

class Analytics {
  Analytics._();
  static final Analytics _instance = Analytics._();
  static Analytics get instance => _instance;

  AnalyticsService _service = _ConsoleAnalytics();

  /// Replace the underlying implementation (e.g. FirebaseAnalytics)
  void setService(AnalyticsService service) => _service = service;

  void logEvent(String name, [Map<String, dynamic>? params]) => _service.logEvent(name, params);

  void setUserId(String? id) => _service.setUserId(id);
}
