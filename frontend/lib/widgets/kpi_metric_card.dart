import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KpiMetricCard extends StatelessWidget {
  KpiMetricCard({
    required this.title,
    required this.totalValue,
    required this.uptoLastMonthValue,
    required this.uptoLastYearValue,
    super.key,
  });

  final String title;
  final double totalValue;
  final double uptoLastMonthValue;
  final double uptoLastYearValue;

  double getPercentChangeSinceLastMonth(double value_1, double value_2) {
    double result = ((value_2 - value_1) / value_1) * 100;
    return double.parse(result.toStringAsFixed(2));
  }

  final indianRupeesFormat = NumberFormat.compactCurrency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 2, // change it to get decimal places
    symbol: '₹ ',
  );
  @override
  Widget build(BuildContext context) {
    final percentChangeSinceLastMonth =
        getPercentChangeSinceLastMonth(uptoLastMonthValue, totalValue);
    final percentChangeSinceLastYear =
        getPercentChangeSinceLastMonth(uptoLastYearValue, totalValue);
    String percentChangeSinceLastMonthText = "";
    String percentChangeSinceLastYearText = "";
    if (percentChangeSinceLastMonth < 0) {
      percentChangeSinceLastMonthText = " - $percentChangeSinceLastMonth %";
    } else {
      percentChangeSinceLastMonthText = " + $percentChangeSinceLastMonth %";
    }
    if (percentChangeSinceLastYear < 0) {
      percentChangeSinceLastYearText = " - $percentChangeSinceLastYear %";
    } else {
      percentChangeSinceLastYearText = " + $percentChangeSinceLastYear %";
    }
    return Container(
      // alignment: Alignment.center,
      width: 250,
      height: 120,
      // padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 10)),
            Text(indianRupeesFormat.format(totalValue),
                style: const TextStyle(fontSize: 36)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Since last year", style: TextStyle(fontSize: 8)),
                      Text(
                        percentChangeSinceLastYearText,
                        style: TextStyle(
                            color: percentChangeSinceLastYear > 0
                                ? Color.fromARGB(255, 2, 180, 8)
                                : Colors.red),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Since last month", style: TextStyle(fontSize: 8)),
                      Text(
                        percentChangeSinceLastMonthText,
                        style: TextStyle(
                            color: percentChangeSinceLastMonth > 0
                                ? Color.fromARGB(255, 2, 180, 8)
                                : Colors.red),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
