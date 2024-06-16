import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KpiMetricCard extends StatelessWidget {
  KpiMetricCard({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final double value;
  final indianRupeesFormat = NumberFormat.compactCurrency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 2, // change it to get decimal places
    symbol: '₹ ',
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.center,
      height: 100,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10)),
          const SizedBox(height: 10),
          Text(indianRupeesFormat.format(value),
              style: const TextStyle(fontSize: 36)),
        ],
      ),
    );
  }
}
