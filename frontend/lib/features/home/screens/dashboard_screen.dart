import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/widgets/widgets.dart';
import 'package:ledgerly_v3/core/services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _currentProfit = 0.0;
  double _monthlyGoal = 500000.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fixed the Member Not Found errors by calling the correct StorageService methods
  Future<void> _loadData() async {
    final profit = await StorageService.getProfit();
    final goal = await StorageService.getGoal();
    setState(() {
      _currentProfit = profit;
      _monthlyGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "LEDGERLY",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Changed from .black to .bold
            fontSize: 22,
            color: AppColors.primaryTeal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfitCard(),
            const SizedBox(height: 20),
            _buildGoalTracker(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitCard() {
    return LedgerlyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Net Profit", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            "₦${_currentProfit.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTracker() {
    double progress = (_currentProfit / _monthlyGoal).clamp(0.0, 1.0);
    return LedgerlyCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Monthly Goal"),
              Text("${(progress * 100).toInt()}%"),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.teal.shade50,
            color: AppColors.primaryTeal,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
