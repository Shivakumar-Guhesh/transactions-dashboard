import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class MonthlyBalanceLineChart extends StatefulWidget {
  const MonthlyBalanceLineChart(
      {required this.months, required this.amounts, super.key});
  final List<double> amounts;
  final List<String> months;
  @override
  State<MonthlyBalanceLineChart> createState() =>
      _MonthlyBalanceLineChartState();
}

class _MonthlyBalanceLineChartState extends State<MonthlyBalanceLineChart> {
  List<Color> gradientColors = [
    Colors.blue,
    Colors.cyan[100] as Color,
  ];

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 2, // change it to get decimal places
    symbol: '₹ ',
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: 18,
        left: 12,
        top: 24,
        bottom: 12,
      ),
      child: LineChart(mainData()),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    var startDate = DateTime(int.parse(widget.months[0].split('-')[0]),
        int.parse(widget.months[0].split('-')[1]));
    var lastDate = DateTime(
        int.parse(widget.months[widget.months.length - 1].split('-')[0]),
        int.parse(widget.months[0].split('-')[1]));
    // var endDate = DateTime(lastDate.year + 2);
    List<DateTime> dates = [];
    for (int i = 0;
        i <=
            // 1 +
            5 + //FIXME: 1 doesnt work
                Jiffy.parseFromDateTime(lastDate)
                    .diff(Jiffy.parseFromDateTime(startDate), unit: Unit.month);
        i++) {
      dates.add(DateTime(startDate.year, startDate.month + i));
    }

    switch (dates[value.toInt()].month % 3) {
      case 0:
        text =
            Text(DateFormat('yMMM').format(dates[value.toInt()]), style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // maxContentWidth: 100,
          // fitInsideHorizontally: true,
          // tooltipBgColor: Colors.white,
          tooltipBgColor: Theme.of(context).colorScheme.primary,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (barSpot) {
                return LineTooltipItem(
                  indianRupeesFormat.format(widget.amounts[barSpot.x.toInt()]),
                  TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ).toList();
          },
        ),
      ),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
          axisNameWidget: Text(
            "Monthly Available Balance",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "Merriweather"),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          // sideTitles: SideTitles(
          //   showTitles: true,
          //   interval: 50000,
          //   reservedSize: 60,
          // ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: (value, meta) {
              return Text(
                NumberFormat.compactCurrency(
                  name: "INR",
                  locale: 'en_IN',
                  symbol: '₹ ',
                ).format(value),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        // show: false,
        border: const Border(
          bottom: BorderSide(color: Color(0xff37434d)),
          left: BorderSide(color: Color(0xff37434d)),
        ),
      ),
      minX: 0,
      maxX: widget.amounts.length.toDouble(),
      minY: 0,
      maxY: (((widget.amounts.reduce(max) + 50000) ~/ 50000) * 50000),
      // amounts.reduce(max) + (amounts.reduce(max) / 10),
      lineBarsData: [
        LineChartBarData(
          spots: widget.amounts.map(
            (e) {
              return FlSpot(widget.amounts.indexOf(e).toDouble(), e);
            },
          ).toList(),
          // isCurved: true,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            // show: false,
            show: true,
            checkToShowDot: (spot, barData) {
              return (spot.x % 3 == 1);
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
