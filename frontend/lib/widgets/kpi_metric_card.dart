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

  final indianRupeesCompactFormat = NumberFormat.compactCurrency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 2, // change it to get decimal places
    symbol: '₹ ',
  );
  final indianRupeesFormat = NumberFormat.currency(
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
    return SizedBox(
      // alignment: Alignment.center,
      width: 250,
      height: 150,
      // padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                // fontFamily: 'Courier Prime',
              ),
            ),
            Tooltip(
              message: indianRupeesFormat.format(totalValue),
              child: Text(
                indianRupeesCompactFormat.format(totalValue),
                style: const TextStyle(
                  fontSize: 42,
                  fontFamily: 'Calculator Script MT',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: indianRupeesFormat.format(uptoLastYearValue),
                    child: Column(
                      children: [
                        const Text(
                          "Since last year",
                          style: TextStyle(fontSize: 8),
                        ),
                        Text(
                          percentChangeSinceLastYearText,
                          style: TextStyle(
                            fontSize: 12,
                            color: percentChangeSinceLastYear > 0
                                ? const Color.fromARGB(255, 2, 180, 8)
                                : Colors.red,
                            fontFamily: 'Calculator Script MT',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Tooltip(
                    message: indianRupeesFormat.format(uptoLastMonthValue),
                    child: Column(
                      children: [
                        const Text(
                          "Since last month",
                          style: TextStyle(fontSize: 8),
                        ),
                        Text(
                          percentChangeSinceLastMonthText,
                          style: TextStyle(
                            fontSize: 12,
                            color: percentChangeSinceLastMonth > 0
                                ? const Color.fromARGB(255, 2, 180, 8)
                                : Colors.red,
                            fontFamily: 'Calculator Script MT',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
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
