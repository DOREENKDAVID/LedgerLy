import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  /// Simulated products (replace with API data)
  final List<Map<String, dynamic>> products = [
    {"id": 1, "name": "Casio Watch"},
    {"id": 2, "name": "Perfume"},
    {"id": 3, "name": "Sundress"},
  ];

  int? selectedProductId;
  final TextEditingController quantityController =
      TextEditingController(text: "1");
  final TextEditingController costPriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();

  bool _isLoading = false;

  double get profit {
    final qty = double.tryParse(quantityController.text) ?? 0;
    final cost = double.tryParse(costPriceController.text) ?? 0;
    final sell = double.tryParse(sellingPriceController.text) ?? 0;

    return (sell - cost) * qty;
  }

  void _saveSale() {
    if (selectedProductId == null ||
        costPriceController.text.isEmpty ||
        sellingPriceController.text.isEmpty ||
        quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all required fields")),
      );
      return;
    }

    _submitSale();
  }

  Future<void> _submitSale() async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post(
        '/v2/sales', // adjust if your backend route is different
        body: {
          'productId': selectedProductId,
          'quantitySold': int.parse(quantityController.text),
          'costPriceAtSale': double.parse(costPriceController.text),
          'sellingPriceAtSale': double.parse(sellingPriceController.text),
          'profitAtSale': profit,
        },
        auth: true,
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sale saved successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // go back to previous screen
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Sale")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// PRODUCT DROPDOWN
                    const Text("Select Product",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<int>(
                      initialValue: selectedProductId,
                      items: products.map((product) {
                        return DropdownMenuItem<int>(
                          value: product["id"],
                          child: Text(product["name"]),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProductId = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// QUANTITY
                    const Text("Quantity Sold",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// COST PRICE
                    const Text("Cost Price (per unit)",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    TextField(
                      controller: costPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixText: "₦ ",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// SELLING PRICE
                    const Text("Selling Price (per unit)",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    TextField(
                      controller: sellingPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixText: "₦ ",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// PROFIT PREVIEW
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Profit",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            "₦ ${profit.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// SAVE BUTTON
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveSale,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Save Sale", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}