import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';

class SalesCatalogueScreen extends StatefulWidget {
  const SalesCatalogueScreen({super.key});

  @override
  State<SalesCatalogueScreen> createState() => _SalesCatalogueScreenState();
}

class _SalesCatalogueScreenState extends State<SalesCatalogueScreen> {
  List<dynamic> sales = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSales();
  }

  Future<void> fetchSales() async {
    try {
      final response = await ApiService.get('v2/sales', auth: true);
      setState(() {
        sales = response['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      debugPrint('Error fetching sales: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sales.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No sales added yet.',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/sales');
                        },
                        child: const Text('Add a Sale'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Today',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          onSelected: (bool value) {},
                        ),
                        FilterChip(
                          label: const Text('Sales'),
                          onSelected: (bool value) {},
                        ),
                        FilterChip(
                          label: const Text('Expenses'),
                          onSelected: (bool value) {},
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: sales.length,
                        itemBuilder: (context, index) {
                          final sale = sales[index];
                          return ListTile(
                            title: Text(sale['itemName']),
                            subtitle: Text(sale['date']),
                            trailing: Text(
                              sale['type'] == 'profit'
                                  ? '+₦${sale['amount']}'
                                  : '-₦${sale['amount']}',
                              style: TextStyle(
                                color: sale['type'] == 'profit'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
