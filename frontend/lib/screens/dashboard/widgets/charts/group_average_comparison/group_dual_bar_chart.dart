import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/intl_constants.dart';
import '../../../../../models/group_average_comparison.dart';
import '../../../../../shared/utils/chart_palette.dart';
import '../../../../../theme/app_animations.dart';
import '../../../../../theme/app_sizes.dart';
import '../../../../../theme/app_theme.dart';

class GroupDualBarChart extends StatelessWidget {
  final List<GroupAverageComparison> data;

  const GroupDualBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        rotationQuarterTurns: 1,
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(),
        barTouchData: _buildTouchData(context),
        titlesData: _buildTitlesData(context),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            dashArray: [20, 10],
            color: Theme.of(context).colorScheme.outline,
            strokeWidth: AppSizes.borderSmall,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(context),
      ),
      duration: AppAnimations.durationMedium,
      curve: AppAnimations.curveMain,
    );
  }

  double _calculateMaxY() {
    if (data.isEmpty) return 100;
    final maxVal = data
        .map(
          (e) => e.currentAmount > e.averageAmount
              ? e.currentAmount
              : e.averageAmount,
        )
        .reduce((a, b) => a > b ? a : b);
    return maxVal * 1.2;
  }

  BarTouchData _buildTouchData(BuildContext context) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) =>
            Theme.of(context).colorScheme.surfaceContainerHigh,
        tooltipPadding: const EdgeInsets.all(AppSizes.spaceSmall),
        tooltipMargin: AppSizes.spaceXSmall,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final item = data[groupIndex];
          final isCurrent = rodIndex == 0;
          final delta = item.currentAmount - item.averageAmount;
          final deltaText = delta >= 0
              ? "+${currencyFormat.format(delta)}"
              : "-${currencyFormat.format(delta.abs())}";

          return BarTooltipItem(
            "${item.group}\n",
            Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: isCurrent ? "Current: " : "Average: ",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              TextSpan(
                text: "${currencyFormat.format(rod.toY)}\n",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: isCurrent ? rod.color : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "$deltaText vs avg",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: delta > 0
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).extension<SemanticColors>()?.success,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    return FlTitlesData(
      show: true,
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 80,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= data.length || value < 0) {
              return const SizedBox.shrink();
            }
            return SideTitleWidget(
              meta: meta,
              space: AppSizes.spaceXSmall,
              child: Text(
                data[value.toInt()].group,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            );
          },
        ),
      ),

      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              meta: meta,
              child: Text(
                value >= 1000
                    ? '${(value / 1000).toStringAsFixed(1)}k'
                    : value.toInt().toString(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(BuildContext context) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: item.currentAmount,
            color: ChartPalette.getColorForLabel(item.group),
            width: AppSizes.spaceMedium,

            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: item.averageAmount,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            width: AppSizes.spaceSmall,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(AppSizes.radiusXSmall),
            ),
          ),
        ],
      );
    }).toList();
  }
}
