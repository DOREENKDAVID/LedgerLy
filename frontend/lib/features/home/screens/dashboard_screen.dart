import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/theme/app_colors.dart';
import 'package:ledgerly_v3/core/services/storage_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String day;
  final double value;

  ChartData(this.day, this.value);
}

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Good morning, Mama T! 👩",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.textDark,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_box, color: AppColors.primaryTeal),
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-products');
                  },
                ),
                DropdownButton<String>(
                  value: "This week",
                  items: const [
                    DropdownMenuItem(value: "Today", child: Text("Today")),
                    DropdownMenuItem(value: "This week", child: Text("This Week")),
                    DropdownMenuItem(value: "This month", child: Text("This Month")),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNetProfitCard(),
            const SizedBox(height: 20),
            _buildSummaryCards(),
            const SizedBox(height: 20),
            _buildAIInsights(),
            const SizedBox(height: 20),
            _buildTopPerformingProducts(),
            const SizedBox(height: 20),
            _buildGraphSection(),
            const SizedBox(height: 20),
            _buildExportReportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNetProfitCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Net Profit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "₦18,500",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "+12% from last week",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "You made ₦18,500 profit this week.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          "Total Revenue",
          "₦450,000",
          "Total money from sales",
          AppColors.primaryBlue,
        ),
        _buildSummaryCard(
          "Product Gross Profit",
          "₦180,000",
          "Profit after cost",
          AppColors.primaryGreen,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, String subtitle, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "AI Insights For You",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          "You earned ₦120,000 in revenue and kept ₦40,000 as profit.",
        ),
        const SizedBox(height: 12),
        _buildInsightCard(
          "Shoes generated the highest profit this week (₦22,000).",
        ),
        const SizedBox(height: 12),
        _buildInsightCard(
          "Your expenses consumed 72% of your profit. Consider reviewing operational costs.",
        ),
      ],
    );
  }

  Widget _buildInsightCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
        ),
      ),
    );
  }

  Widget _buildTopPerformingProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Performing Products",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        _buildProductCard("Shoes", 56, 180000, 60000),
        const SizedBox(height: 12),
        _buildProductCard("Sundresses", 29, 75000, 22000),
        const SizedBox(height: 12),
        _buildProductCard("Casio Watch", 25, 60000, 18000),
      ],
    );
  }

  Widget _buildProductCard(String name, int margin, int revenue, int profit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                "$margin%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Revenue",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                "₦$revenue",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gross Profit",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                "₦$profit",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraphSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "7 Days",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: [
                    ChartData('Mon', 10),
                    ChartData('Tue', 20),
                    ChartData('Wed', 15),
                    ChartData('Thu', 25),
                    ChartData('Fri', 10),
                    ChartData('Sat', 30),
                    ChartData('Sun', 40),
                  ],
                  xValueMapper: (ChartData data, _) => data.day,
                  yValueMapper: (ChartData data, _) => data.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportReportButton() {
    return ElevatedButton(
      onPressed: () {
        // Add export report functionality here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      child: const Text(
        'Export Report',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
