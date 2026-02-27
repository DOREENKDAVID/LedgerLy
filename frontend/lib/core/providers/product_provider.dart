import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  bool _loading = false;

  List<ProductModel> get items => List.unmodifiable(_items);
  bool get loading => _loading;

  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await ApiService.get('/v1/products', auth: true);
      if (res.containsKey('products')) {
        final list = res['products'] as List<dynamic>;
        _items.clear();
        _items.addAll(list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)));
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<ProductModel?> createProduct(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final res = await ApiService.post('/v1/products', body: data, auth: true);
      if (res.containsKey('id')) {
        final p = ProductModel.fromJson(res);
        _items.add(p);
        return p;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
    return null;
  }
}
