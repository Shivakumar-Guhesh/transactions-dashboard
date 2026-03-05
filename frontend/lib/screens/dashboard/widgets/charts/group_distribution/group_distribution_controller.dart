import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../providers/group_distribution_provider.dart';
import '../../../../../schemas/transaction_schemas.dart';
import '../../../../../shared/widgets/chart_card.dart';
import '../../../../../shared/widgets/expanded_chart_view.dart';
import '../../../../../shared/widgets/shimmer_skeleton.dart';
import '../../../../../theme/app_sizes.dart';
import 'group_donut_chart.dart';

class GroupDistributionController extends ConsumerWidget
    with FullScreenChartMixin {
  final TransactionsFiltersRequest filters;

  const GroupDistributionController({super.key, required this.filters});

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

    final distributionData = ref.watch(groupDistributionProvider(filters));

    return distributionData.when(
      data: (data) {
        final chartWidget = GroupDonutChart(data: data);
        return SizedBox(
          width: responsiveWidth,
          height: responsiveHeight,
          child: ChartCard(
            title: "Category Distribution",
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
