import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/group_average_comparison_provider.dart';
import '../../../../../schemas/transaction_schemas.dart';
import '../../../../../shared/widgets/chart_card.dart';
import '../../../../../shared/widgets/expanded_chart_view.dart';
import '../../../../../shared/widgets/shimmer_skeleton.dart';
import '../../../../../theme/app_sizes.dart';
import 'group_dual_bar_chart.dart';

class GroupAverageComparisonController extends ConsumerWidget
    with FullScreenChartMixin {
  final TransactionsFiltersRequest filters;

  const GroupAverageComparisonController({super.key, required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final responsiveWidth = (screenWidth * AppSizes.groupChartWidthFactor)
        .clamp(AppSizes.minGroupChartWidth, AppSizes.maxGroupChartWidth);
    final responsiveHeight = (screenHeight * AppSizes.groupChartHeightFactor)
        .clamp(AppSizes.minGroupChartHeight, AppSizes.maxGroupChartHeight);

    final comparisonData = ref.watch(groupAvgComparisonProvider(filters));

    return comparisonData.when(
      data: (data) {
        final chartWidget = GroupDualBarChart(data: data);
        return SizedBox(
          width: responsiveWidth,
          height: responsiveHeight,
          child: ChartCard(
            title: "Spending vs Average",
            chart: chartWidget,
            onExpand: () => toggleFullScreen(context, chartWidget),
          ),
        );
      },
      loading: () => SizedBox(
        width: responsiveWidth,
        height: responsiveHeight,
        child: const ShimmerSkeleton(),
      ),
      error: (err, _) => SizedBox(
        width: responsiveWidth,
        height: responsiveHeight,
        child: Card(child: Center(child: Text("Error: $err"))),
      ),
    );
  }
}
