import 'package:flutter/material.dart';

class MarginRiskAlert extends StatelessWidget {
  final double margin;
  const MarginRiskAlert({super.key, required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
      child: Text("Margin Alert: ${margin.toStringAsFixed(1)}%", style: const TextStyle(color: Colors.orange)),
    );
  }
}