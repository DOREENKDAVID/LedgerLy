import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';

class AddProductsScreen extends StatelessWidget {
  const AddProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    Future<void> addProduct() async {
      final String name = nameController.text;
      final String price = priceController.text;

      if (name.isEmpty || price.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields.')),
        );
        return;
      }

      try {
        final response = await ApiService.addProduct({
          'name': name,
          'price': double.parse(price),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added: ${response['message']}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: addProduct,
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}