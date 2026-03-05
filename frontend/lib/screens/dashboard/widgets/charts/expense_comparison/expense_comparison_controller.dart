import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/dashboard/widgets/charts/expense_comparison/comparison_line_chart.dart';
import 'package:frontend/shared/widgets/chart_card.dart';

import '../../../../../providers/expense_comparison_provider.dart';
import '../../../../../schemas/transaction_schemas.dart';
import '../../../../../shared/widgets/expanded_chart_view.dart';
import '../../../../../shared/widgets/shimmer_skeleton.dart';
import '../../../../../theme/app_sizes.dart';

class ExpenseComparisonController extends ConsumerWidget
    with FullScreenChartMixin {
  final TransactionsFiltersRequest filters;

  const ExpenseComparisonController({super.key, required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final responsiveWidth = (screenWidth * AppSizes.chartWidthFactor).clamp(
      AppSizes.minChartWidth,
      AppSizes.maxChartWidth,
    );
    final responsiveHeight = (screenHeight * AppSizes.chartHeightFactor).clamp(
      AppSizes.minChartHeight,
      AppSizes.maxChartHeight,
    );

    final comparisonData = ref.watch(expenseComparisonProvider(filters));

    return comparisonData.when(
      data: (data) => SizedBox(
        width: responsiveWidth,
        height: responsiveHeight,
        child: ChartCard(
          title: "MTD Expense Comparison",
          chart: ComparisonLineChart(data: data),
          onExpand: () =>
              toggleFullScreen(context, ComparisonLineChart(data: data)),
          legend: _buildLegend(context, data),
        ),
      ),
      loading: () => SizedBox(
        width: responsiveWidth,
        height: responsiveHeight,
        child: const ShimmerSkeleton(),
      ),
      error: (err, stack) => SizedBox(
        width: responsiveWidth,
        height: responsiveHeight,
        child: _buildErrorState(context, err.toString()),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: Theme.of(context).colorScheme.primary,
          label: data['currentMonthName'],
          isDashed: false,
        ),
        const SizedBox(width: AppSizes.spaceMedium),
        _LegendItem(
          color: Theme.of(context).colorScheme.secondary,
          label: data['prevMonthName'],
          isDashed: true,
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Card(child: Center(child: Text("Error loading chart: $error")));
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.isDashed,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceSmall,
        vertical: AppSizes.spaceXXSmall,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: textColor),
      ),
    );
  }
}
