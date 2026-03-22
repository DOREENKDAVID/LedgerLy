import 'package:flutter/material.dart';


class ExpensesCatalogueScreen extends StatefulWidget {
  const ExpensesCatalogueScreen({super.key});

  @override
  State<ExpensesCatalogueScreen> createState() =>
      _ExpensesCatalogueScreenState();
}

class _ExpensesCatalogueScreenState
    extends State<ExpensesCatalogueScreen> {
  int selectedFilterIndex = 0;

  final List<String> filters = ['All', 'Sales', 'Expenses'];

  final List<Map<String, dynamic>> transactions = [
    {
      'title': 'Casio watch',
      'subtitle': '1 x 15,000',
      'amount': '+₦2,000',
      'isPositive': true,
      'date': 'Today',
      'type': 'Sales'
    },
    {
      'title': 'Perfume',
      'subtitle': '2 x 7,000',
      'amount': '-₦1,000',
      'isPositive': false,
      'date': 'Today',
      'type': 'Expenses'
    },
    {
      'title': 'Sundress',
      'subtitle': '1 x 35,000',
      'amount': '+₦2,500',
      'isPositive': true,
      'date': 'Today',
      'type': 'Sales'
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilterIndex == 0) return transactions;

    final selectedType = filters[selectedFilterIndex];
    return transactions
        .where((item) => item['type'] == selectedType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        elevation: 0,
      ),
      body: Column(
        children: [

          /// SUCCESS BANNER
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Expense saved. Your totals are updated.",
              style: TextStyle(color: Colors.green),
            ),
          ),

          /// FILTER TABS
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final isSelected = selectedFilterIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilterIndex = index;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.teal
                          : Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Text(
                      filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          /// TRANSACTION CARDS
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final item = filteredTransactions[index];

                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              item['title'],
                              style:
                                  const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                                height: 4),
                            Text(
                              item['subtitle'],
                              style:
                                  const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                                height: 4),
                            Text(
                              item['date'],
                              style:
                                  const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item['amount'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                            color: item[
                                    'isPositive']
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/products');
              break;
            case 2:
              Navigator.pushNamed(context, '/log');
              break;
            case 3:
              Navigator.pushNamed(context, '/expenses');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: "Products"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: "Log"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Activity"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile"),
        ],
      ),
    );
  }
}