import 'package:flutter/material.dart';

import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/features/auth/screens/otp_verification_screen.dart';

class SignupProductsScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String businessType;

  const SignupProductsScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.businessType,
  });

  @override
  State<SignupProductsScreen> createState() => _SignupProductsScreenState();
}

class _SignupProductsScreenState extends State<SignupProductsScreen> {
  final List<Map<String, dynamic>> _products = [];
  bool _showForm = false;
  final _productNameController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  void _addProduct() {
    if (_productNameController.text.isNotEmpty &&
        _costPriceController.text.isNotEmpty &&
        _sellingPriceController.text.isNotEmpty) {
      setState(() {
        _products.add({
          "name": _productNameController.text,
          "costPrice": double.parse(_costPriceController.text),
          "sellingPrice": double.parse(_sellingPriceController.text),
        });
        _productNameController.clear();
        _costPriceController.clear();
        _sellingPriceController.clear();
        _showForm = false;
      });
    }
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  double _calculateMargin(double costPrice, double sellingPrice) {
    if (costPrice == 0) return 0;
    return ((sellingPrice - costPrice) / costPrice) * 100;
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Add your products",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Add the products you sell. You can edit these anytime.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Products List
              if (_products.isNotEmpty)
                Column(
                  children: List.generate(_products.length, (index) {
                    final product = _products[index];
                    final margin = _calculateMargin(
                        product['costPrice'], product['sellingPrice']);
                    return _buildProductCard(product, margin, index);
                  }),
                ),

              if (_products.isNotEmpty) const SizedBox(height: 20),

              // Add Product Form
              if (_showForm)
                _buildAddProductForm()
              else
                GestureDetector(
                  onTap: () => setState(() => _showForm = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryTeal,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primaryTeal.withOpacity(0.05),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryTeal,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Add Product",
                          style: TextStyle(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Continue Button (enabled after at least 1 product added)
              LedgerlyButton(
                label: _products.isEmpty
                    ? "Add at least one product to continue"
                    : "Verify Account",
                onPressed: _products.isNotEmpty
                    ? () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OtpVerificationScreen(),
                          ),
                        )
                    : null,
              ),

              const SizedBox(height: 20),

              // Skip Link (optional)
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OtpVerificationScreen(),
                    ),
                  ),
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
      Map<String, dynamic> product, double margin, int index) {
    final costPrice = product['costPrice'] as double;
    final sellingPrice = product['sellingPrice'] as double;
    final profit = sellingPrice - costPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _removeProduct(index),
                child: Icon(
                  Icons.close,
                  color: Colors.red.shade400,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cost Price",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₦${costPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selling Price",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₦${sellingPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profit/Unit",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₦${profit.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: margin < 10 ? Colors.orange : Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                "Margin: ",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "${margin.toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: margin < 10 ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add New Product",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _productNameController,
            decoration: InputDecoration(
              labelText: "Product Name",
              hintText: "e.g., Rice (50kg bag)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _costPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Cost Price",
              hintText: "₦0.00",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixText: "₦",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _sellingPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Selling Price",
              hintText: "₦0.00",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixText: "₦",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _showForm = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
