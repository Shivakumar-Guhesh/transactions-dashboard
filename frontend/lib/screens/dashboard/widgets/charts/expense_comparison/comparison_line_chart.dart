import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/chart_constants.dart';
import '../../../../../constants/intl_constants.dart';
import '../../../../../shared/utils/chart_utils.dart';
import '../../../../../theme/app_sizes.dart';

class ComparisonLineChart extends StatelessWidget {
  final Map<String, dynamic> data;

  const ComparisonLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final List<double> current = List<double>.from(data['current']);
    final List<double> previous = List<double>.from(data['previous']);

    final double maxCurrent = current.isNotEmpty
        ? current.reduce((a, b) => a > b ? a : b)
        : 0;
    final double maxPrevious = previous.isNotEmpty
        ? previous.reduce((a, b) => a > b ? a : b)
        : 0;
    final double absoluteMax = maxCurrent > maxPrevious
        ? maxCurrent
        : maxPrevious;

    final double rawMax = absoluteMax == 0 ? 100 : absoluteMax * 1.1;
    final double niceInterval = ChartUtils.calculateInterval(rawMax);
    final double roundedMaxY = (rawMax / niceInterval).ceil() * niceInterval;

    final List<FlSpot> currentSpots = current
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble() + 1, e.value))
        .toList();

    final List<FlSpot> previousSpots = previous
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble() + 1, e.value))
        .toList();

    return LineChart(
      LineChartData(
        lineTouchData: _buildTouchData(context),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            dashArray: [20, 10],
            color: Theme.of(context).colorScheme.outline,
            strokeWidth: AppSizes.borderSmall,
          ),
        ),
        titlesData: _buildTitlesData(context),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: previousSpots,
            isCurved: false,
            color: Theme.of(context).colorScheme.secondary,
            barWidth: AppSizes.borderSmall,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            dashArray: [5, 5],
          ),

          LineChartBarData(
            spots: currentSpots,
            isCurved: false,
            color: Theme.of(context).colorScheme.primary,
            barWidth: AppSizes.borderLarge,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            shadow: Shadow(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.1),
              blurRadius: AppSizes.radiusSmall,
              offset: const Offset(0, 2),
            ),
          ),
        ],
        minX: 1,
        maxX: 31,
        minY: 0,
        maxY: roundedMaxY,
      ),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 45,
          getTitlesWidget: (value, meta) => Text(
            compactSimpleCurrencyFormatWithoutDecimal.format(value),
            style: textStyle,
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: lineChartBottomInterval,
          getTitlesWidget: (value, meta) => Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceXSmall),
            child: Text("${value.toInt()}", style: textStyle),
          ),
        ),
      ),
    );
  }

  LineTouchData _buildTouchData(BuildContext context) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipColor: (spot) => Theme.of(context).colorScheme.surface,
        tooltipBorder: BorderSide(color: Theme.of(context).colorScheme.outline),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            final isCurrent = spot.barIndex == 1;
            final textColor = Theme.of(context).colorScheme.onSurface;

            return LineTooltipItem(
              '● ',
              TextStyle(
                color: isCurrent
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
              children: [
                TextSpan(
                  text: currencyFormat.format(spot.y),
                  style: TextStyle(color: textColor),
                ),
              ],
            );
          }).toList();
        },
      ),
    );
  }
}
