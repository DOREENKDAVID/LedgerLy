import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';
import 'package:ledgerly_v3/core/widgets/ledgerly_empty_state.dart';
import 'package:ledgerly_v3/core/widgets/margin_risk_alert.dart';

class ProductSetupScreen extends StatefulWidget {
  const ProductSetupScreen({super.key});

  @override
  State<ProductSetupScreen> createState() => _ProductSetupScreenState();
}

class _ProductSetupScreenState extends State<ProductSetupScreen> {
  final List<Map<String, dynamic>> _myProducts =
      []; // Set to empty to see illustration

  void _openAddProductSheet(BuildContext context) {
    final TextEditingController costCtrl = TextEditingController();
    final TextEditingController sellCtrl = TextEditingController();
    double currentMargin = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Product",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const TextField(
                  decoration: InputDecoration(
                      labelText: "Product Name", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(
                controller: costCtrl,
                decoration: const InputDecoration(
                    labelText: "Cost Price (₦)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final cost = double.tryParse(costCtrl.text) ?? 0;
                  final sell = double.tryParse(sellCtrl.text) ?? 0;
                  if (sell > 0) {
                    setSheetState(
                        () => currentMargin = ((sell - cost) / sell) * 100);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: sellCtrl,
                decoration: const InputDecoration(
                    labelText: "Selling Price (₦)",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final cost = double.tryParse(costCtrl.text) ?? 0;
                  final sell = double.tryParse(sellCtrl.text) ?? 0;
                  if (sell > 0) {
                    setSheetState(
                        () => currentMargin = ((sell - cost) / sell) * 100);
                  }
                },
              ),
              const SizedBox(height: 20),
              if (currentMargin > 0 && currentMargin < 10)
                MarginRiskAlert(margin: currentMargin),
              const SizedBox(height: 20),
              LedgerlyButton(
                  label: "Save Product",
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Your Catalog"),
          backgroundColor: Colors.white,
          elevation: 0),
      body: _myProducts.isEmpty
          ? const LedgerlyEmptyState(
              title: "Your Catalog is Empty",
              subtitle: "Add products to calculate your profit automatically.",
              illustrationPath: 'assets/icons/empty_products.svg',
            )
          : ListView(children: const [/* List products here */]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        onPressed: () => _openAddProductSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
