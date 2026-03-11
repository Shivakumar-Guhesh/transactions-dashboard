import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/dashboard/widgets/charts/group_average_comparison/group_average_comparison_controller.dart';
import 'package:frontend/screens/dashboard/widgets/charts/group_distribution/group_distribution_controller.dart';
import 'package:frontend/shared/responsive.dart';

import '../../../providers/repository_provider.dart';
import '../../../schemas/transaction_schemas.dart';
import '../../../theme/app_sizes.dart';
import 'charts/expense_comparison/expense_comparison_controller.dart';
import 'filter_panel.dart';
import 'header.dart';
import 'kpi_card.dart';

class MainContentArea extends ConsumerWidget {
  const MainContentArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(transactionRepositoryProvider);

    final currentFilters = TransactionsFiltersRequest();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXXSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(),
          const FilterPanel(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spaceXSmall),
              child: SizedBox(
                child: Column(
                  children: [
                    Flex(
                      direction: context.isMobile
                          ? Axis.vertical
                          : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KpiCard(
                          title: "Liquid Asset Worth",
                          fetcher: repo.getLiquidAssetWorth,
                          filters: currentFilters,
                        ),
                        KpiCard(
                          title: "Total Asset Worth",
                          fetcher: repo.getTotalAssetWorth,
                          filters: currentFilters,
                        ),
                        KpiCard(
                          title: "Total Expense",
                          fetcher: repo.getTotalExpense,
                          filters: currentFilters,
                        ),
                        KpiCard(
                          title: "Total Income",
                          fetcher: repo.getTotalIncome,
                          filters: currentFilters,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceXXSmall),
                    ExpenseComparisonController(filters: currentFilters),
                    const SizedBox(height: AppSizes.spaceXXSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GroupDistributionController(filters: currentFilters),
                        GroupAverageComparisonController(
                          filters: currentFilters,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
