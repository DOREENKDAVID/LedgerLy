import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';
import 'package:ledgerly_v3/core/widgets/cards/metric_card.dart';

import 'package:pdf/widgets.dart' as pw; // ✅ widgets
import 'package:pdf/pdf.dart'; // ✅ PdfColor
import 'package:printing/printing.dart';

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
  String _selectedTimeframe = 'day';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final insightsData = await ApiService.get('v3/insights', auth: true);
      final businessData = await ApiService.get('v1/business', auth: true);

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

  double get netProfit => (insights?['netProfit'] ?? 0).toDouble();
  double get totalRevenue => (insights?['totalRevenue'] ?? 0).toDouble();
  double get totalExpenses => (insights?['totalExpenses'] ?? 0).toDouble();

  List<Map<String, dynamic>> get topProducts =>
      List<Map<String, dynamic>>.from(insights?['topProducts'] ?? []);

  String get businessName => business?['name'] ?? "Your Business";

  /// ================= PDF EXPORT =================
  Future<void> exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "${getGreeting()}, $businessName 👋",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),

            /// NET PROFIT CARD
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [
                    PdfColor.fromHex("042E25"),
                    PdfColor.fromHex("064134"),
                  ],
                ),
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Net Profit",
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("FFFFFF"),
                      fontSize: 16,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    formatCurrency(netProfit),
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("FFFFFF"),
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            /// METRICS
            pw.Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildMetricCard("Revenue", formatCurrency(totalRevenue),
                    "Total sales"),
                _buildMetricCard("Expenses", formatCurrency(totalExpenses),
                    "Total spending"),
                _buildMetricCard("Profit",
                    formatCurrency(netProfit), "Net earnings"),
              ],
            ),

            pw.SizedBox(height: 16),

            /// TOP PRODUCTS
            pw.Text(
              "Top Products",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),

            ...topProducts.map(
              (product) => pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(product['name'] ?? ''),
                  pw.Text("₦${product['revenue'] ?? 0}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// ================= PDF CARD =================
  pw.Widget _buildMetricCard(
      String title, String value, String subtitle) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex("F7FAF9"),
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(
          color: PdfColor.fromHex("E0E0E0"),
          width: 1,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text(value),
          pw.SizedBox(height: 2),
          pw.Text(
            subtitle,
            style: pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// ================= UI =================
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

    return Scaffold(
      appBar: AppBar(title: Text(businessName)),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "${getGreeting()} 👋",
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// NET PROFIT
            Card(
              child: ListTile(
                title: const Text("Net Profit"),
                subtitle: Text(formatCurrency(netProfit)),
              ),
            ),

            const SizedBox(height: 16),

            /// METRICS
            MetricCard(
              title: "Revenue",
              value: formatCurrency(totalRevenue),
              subtitle: "Total sales",
              icon: Icons.attach_money,
              color: Colors.blue.shade100,
              iconColor: Colors.blue,
            ),

            const SizedBox(height: 16),

            /// EXPORT BUTTON
            ElevatedButton(
              onPressed: exportPdf,
              child: const Text("Export PDF"),
            ),
          ],
        ),
      ),
    );
  }
}