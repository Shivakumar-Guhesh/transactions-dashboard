import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class KpiMetricCard extends StatelessWidget {
  KpiMetricCard({
    required this.title,
    required this.totalValue,
    required this.uptoLastMonthValue,
    required this.uptoLastYearValue,
    this.hoverChild,
    super.key,
  });

  final String title;
  final double totalValue;
  final double uptoLastMonthValue;
  final double uptoLastYearValue;
  final Widget? hoverChild;

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
      height: 160,
      // padding: const EdgeInsets.all(8.0),
      child: Card(
        // color: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 10,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hoverChild != null)
              Tooltip(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                richMessage: WidgetSpan(
                  child: hoverChild!,
                ),
                child: Text(
                  title,
                  // style: Theme.of(context).textTheme.copyWith().bodySmall,
                  style: TextStyle(
                    fontSize: 10,
                    // fontFamily: 'Courier Prime',
                  ),
                ),
              )
            else
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  // fontFamily: 'Courier Prime',
                ),
              ),
            FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.fill,
              child: Tooltip(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).dialogTheme.shadowColor,
                ),
                richMessage: WidgetSpan(
                  child: SelectionArea(
                    child: Text(
                      indianRupeesFormat.format(totalValue),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  indianRupeesCompactFormat.format(totalValue),
                  style: const TextStyle(
                    fontSize: 60,
                    fontFamily: 'Calculator Script MT',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).dialogTheme.shadowColor,
                    ),
                    richMessage: WidgetSpan(
                      child: Column(
                        children: [
                          SelectionArea(
                            child: Text(
                              indianRupeesFormat.format(uptoLastYearValue),
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    richMessage: WidgetSpan(
                      child: Column(
                        children: [
                          SelectionArea(
                            child: Text(
                              indianRupeesFormat.format(uptoLastMonthValue),
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //  indianRupeesFormat.format(uptoLastMonthValue),
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
