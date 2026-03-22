import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';

class AddProductFormScreen extends StatefulWidget {
  const AddProductFormScreen({super.key});

  @override
  State<AddProductFormScreen> createState() => _AddProductFormScreenState();
}

class _AddProductFormScreenState extends State<AddProductFormScreen> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _quantityController = TextEditingController();

  double _profit = 0;
  double _profitMargin = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  /// Rounded Input Decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: AppColors.primaryTeal,
          width: 2,
        ),
      ),
    );
  }

  /// Calculate Profit & Margin
  void _updateProfit() {
    final cost = double.tryParse(_costPriceController.text) ?? 0.0;
    final sell = double.tryParse(_sellingPriceController.text) ?? 0.0;

    final profit = sell - cost;
    final margin = cost == 0.0 ? 0.0 : (profit / cost) * 100.0;

    setState(() {
      _profit = profit;
      _profitMargin = margin;
    });
  }

  /// Show Confirmation Dialog
  void _showConfirmation() {
    if (_productNameController.text.isEmpty ||
        _costPriceController.text.isEmpty ||
        _sellingPriceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Confirm Product Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${_productNameController.text}"),
              Text("Description: ${_descriptionController.text}"),
              Text("Cost Price: ₦${_costPriceController.text}"),
              Text("Selling Price: ₦${_sellingPriceController.text}"),
              Text("Quantity: ${_quantityController.text}"),
              const SizedBox(height: 12),
              Text("Profit: ₦${_profit.toStringAsFixed(2)}"),
              Text("Margin: ${_profitMargin.toStringAsFixed(2)}%"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Edit"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _submitProduct();
            },
            child: const Text("Confirm & Add"),
          ),
        ],
      ),
    );
  }

  /// Submit Product to API
  Future<void> _submitProduct() async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post(
        '/v1/products',
        body: {
          'productName': _productNameController.text,
          'description': _descriptionController.text,
          'costPrice': double.parse(_costPriceController.text),
          'sellingPrice': double.parse(_sellingPriceController.text),
          'quantity': int.parse(_quantityController.text),
        },
        auth: true,
      );

      print('API Response: $response'); // Debug log to verify response
      if (!mounted) return;

      if (response['product'] != null) {
        Navigator.pushReplacementNamed(context, '/products/success');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? 'Failed to add product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _productNameController,
              decoration: _inputDecoration('Product Name'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              decoration: _inputDecoration('Description'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _costPriceController,
              decoration: _inputDecoration('Cost Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _updateProfit(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _sellingPriceController,
              decoration: _inputDecoration('Selling Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _updateProfit(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _quantityController,
              decoration: _inputDecoration('Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            /// Profit Display
            if (_costPriceController.text.isNotEmpty &&
                _sellingPriceController.text.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _profit >= 0
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profit >= 0 ? "Profit 📈" : "Loss 📉",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _profit >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Profit per unit: ₦${_profit.toStringAsFixed(2)}"),
                    Text("Profit margin: ${_profitMargin.toStringAsFixed(2)}%"),
                    const SizedBox(height: 8),
                    Text(
                      _profit >= 0
                          ? "You make ₦${_profit.toStringAsFixed(2)} per unit. Great margin! 🥳"
                          : "You'll run at a loss. Consider raising your selling price.",
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: _isLoading ? null : _showConfirmation,
                child: Text(
                  _isLoading ? 'Saving...' : 'Save Product',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
