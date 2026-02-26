import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/buttons/buttons.dart';

class EndOfDayScreen extends StatefulWidget {
  const EndOfDayScreen({super.key});

  @override
  State<EndOfDayScreen> createState() => _EndOfDayScreenState();
}

class _EndOfDayScreenState extends State<EndOfDayScreen> {
  // Mock data representing the user's catalog
  final List<Map<String, dynamic>> _dailySales = [
    {"name": "Rice (50kg bag)", "count": 0},
    {"name": "Peak Milk (tin)", "count": 0},
    {"name": "Vegetable Oil (1L)", "count": 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text("Bulk Sale Entry",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _dailySales.length,
              itemBuilder: (context, index) {
                return _buildCounterTile(index);
              },
            ),
          ),
          _buildSummaryFooter(),
        ],
      ),
    );
  }

  Widget _buildCounterTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(_dailySales[index]['name'],
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          IconButton(
            onPressed: () => setState(() {
              if (_dailySales[index]['count'] > 0) {
                _dailySales[index]['count']--;
              }
            }),
            icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
          ),
          SizedBox(
            width: 30,
            child: Center(
              child: Text("${_dailySales[index]['count']}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _dailySales[index]['count']++),
            icon: const Icon(Icons.add_circle, color: AppColors.primaryTeal),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryFooter() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Items to Log",
                    style: TextStyle(color: Colors.grey)),
                Text("Fast Entry Mode",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),
            LedgerlyButton(
              label: "Save All Sales",
              onPressed: () {
                // Future: This will trigger the ApiService bulk upload
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Sales recorded! Dashboard updated.")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
