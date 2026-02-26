import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LedgerlyEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String illustrationPath;

  const LedgerlyEmptyState({
    super.key, 
    required this.title, 
    required this.subtitle, 
    required this.illustrationPath
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(illustrationPath, height: 200),
            const SizedBox(height: 30),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}