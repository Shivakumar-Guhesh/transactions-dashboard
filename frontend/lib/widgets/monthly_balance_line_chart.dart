import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

  bool showAvg = false;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 2, // change it to get decimal places
    symbol: '₹ ',
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 650,
      height: 350,
      // aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          // showAvg ? avgData() : mainData(),
          mainData(),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    String text;

    switch (value.toInt()) {
      case 50000:
        text = '50K';
        break;
      case 100000:
        text = '100K';
        break;
      case 150000:
        text = '150K';
        break;
      case 200000:
        text = '200K';
        break;
      case 250000:
        text = '250K';
        break;
      case 300000:
        text = '300K';
        break;
      case 350000:
        text = '350K';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
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
          return touchedSpots.map((barSpot) {
            return LineTooltipItem(
              // indianRupeesFormat.format(barSpot),
              // barSpot.bar.lineChartStepData.toString(),

              indianRupeesFormat.format(widget.amounts[barSpot.x.toInt()]),
              TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            );
          }).toList();
        },
      )),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // reservedSize: 30,
            // interval: 10,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 50000,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        // show: true,
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.amounts.length as double,
      minY: 0,
      maxY: (((widget.amounts.reduce(max) + 50000) ~/ 50000) * 50000),
      // amounts.reduce(max) + (amounts.reduce(max) / 10),
      lineBarsData: [
        LineChartBarData(
          spots: widget.amounts.map((e) {
            return FlSpot(widget.amounts.indexOf(e) as double, e);
          }).toList(),
          // isCurved: true,
          isCurved: true,
          // gradient: LinearGradient(
          //   colors: gradientColors,
          //   // begin: Alignment.topCenter,
          //   // end: Alignment.bottomCenter,
          // ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
