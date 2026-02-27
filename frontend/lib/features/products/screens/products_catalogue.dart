import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/ledgerly_empty_state.dart';

class ProductsCatalogueScreen extends StatefulWidget {
  const ProductsCatalogueScreen({super.key});

  @override
  State<ProductsCatalogueScreen> createState() => _ProductsCatalogueScreenState();
}

class _ProductsCatalogueScreenState extends State<ProductsCatalogueScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.get('/v1/products');
      if (!mounted) return;

      setState(() {
        _products = response['products'] ?? [];
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _showNavigateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Done'),
        content: const Text('Would you like to go to your dashboard?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Add More Products'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Catalog'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _products.isEmpty
                  ? const LedgerlyEmptyState(
                      title: 'Your Catalog is Empty',
                      subtitle:
                          'Add products to calculate your profit automatically.',
                      illustrationPath: 'assets/icons/empty_products.svg',
                    )
                  : ListView(
                      children: _products.map((product) {
                        return Card(
                          margin: const EdgeInsets.all(12),
                          child: ListTile(
                            title: Text(product['productName'] ?? 'N/A'),
                            subtitle:
                                Text(product['description'] ?? 'No description'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/products', // navigate to product details/edit page
                                arguments: product, // pass the product info
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        onPressed: () => Navigator.pushReplacementNamed(context, '/products/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _products.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _showNavigateDialog,
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }
}