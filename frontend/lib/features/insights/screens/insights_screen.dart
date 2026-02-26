import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';
import 'package:ledgerly_v3/core/widgets/cards/metric_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Map<String, dynamic>? insights;
  Map<String, dynamic>? business;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final insightsData = await ApiService.get('v3/insights');
      final businessData = await ApiService.get('v1/business');

      setState(() {
        insights = insightsData;
        business = businessData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String formatCurrency(dynamic value) {
    final number = (value ?? 0).toDouble();
    return "₦${number.toStringAsFixed(0)}";
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!)),
      );
    }

    final netProfit = insights?['netProfit'] ?? 0;
    final totalRevenue = insights?['totalRevenue'] ?? 0;
    final totalExpenses = insights?['totalExpenses'] ?? 0;
    final grossProfit = insights?['grossProfit'] ?? 0;
    final profitMargin = insights?['profitMargin'] ?? 0;
    final topProducts = insights?['topProducts'] ?? [];
    final weeklyGrowth = business?['weeklyGrowth'] ?? 0;
    final businessName = business?['name'] ?? "Your Business";

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getGreeting()},",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          businessName,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Text("This week",
                              style: TextStyle(fontSize: 12)),
                          Icon(Icons.keyboard_arrow_down, size: 16),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24),

                /// NET PROFIT CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF042E25), Color(0xFF064134)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Net Profit",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            formatCurrency(netProfit),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.trending_up,
                              color: Colors.orange, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "+$weeklyGrowth% from last week",
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// CLICKABLE METRIC GRID
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [

                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/sales_catalogue'),
                      child: MetricCard(
                        title: "Total Revenue",
                        value: formatCurrency(totalRevenue),
                        subtitle: "Total money from sales",
                        icon: Icons.savings_outlined,
                        color: const Color(0xFFE3F2FD),
                        iconColor: Colors.blue,
                      ),
                    ),

                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/products_catalogue'),
                      child: MetricCard(
                        title: "Product Gross Profit",
                        value: formatCurrency(grossProfit),
                        subtitle: "Profit after cost",
                        icon: Icons.bar_chart,
                        color: const Color(0xFFE8F5E9),
                        iconColor: Colors.green,
                      ),
                    ),

                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/expenses_catalogue'),
                      child: MetricCard(
                        title: "Total Expenses",
                        value: formatCurrency(totalExpenses),
                        subtitle: "Spent on business",
                        icon: Icons.receipt_long,
                        color: const Color(0xFFFFEBEE),
                        iconColor: Colors.red,
                      ),
                    ),

                    MetricCard(
                      title: "Business Margin",
                      value: "${profitMargin.toStringAsFixed(1)}%",
                      subtitle: "Percentage profit",
                      icon: Icons.balance,
                      color: const Color(0xFFFFF3E0),
                      iconColor: Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// AI INSIGHTS
                const Text("AI Insights For You",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You earned ${formatCurrency(totalRevenue)} and kept ${formatCurrency(netProfit)} as profit.",
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your expenses are ${formatCurrency(totalExpenses)} this week.",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// TOP PRODUCTS
                const Text("Top Performing Products",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topProducts.length,
                  itemBuilder: (context, index) {
                    final product = topProducts[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                              "Revenue: ${formatCurrency(product['revenue'])}"),
                          Text(
                              "Gross Profit: ${formatCurrency(product['grossProfit'])}"),
                          Text(
                              "Margin: ${product['margin'].toStringAsFixed(1)}%"),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                /// EXPORT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/export_report');
                    },
                    icon: const Icon(Icons.file_download_outlined,
                        color: Colors.white),
                    label: const Text("Export Report",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE76F51),
                      padding:
                          const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}