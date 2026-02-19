import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/repository_provider.dart';
import '../../../schemas/transaction_schemas.dart';
import '../../../theme/app_sizes.dart';
import 'filter_panel.dart';
import 'header.dart';
import 'kpi_card.dart';

class MainContentArea extends ConsumerWidget {
  const MainContentArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(transactionRepositoryProvider);

    final currentFilters = TransactionsFiltersRequest();

    return Column(
      children: [
        const Header(),
        const FilterPanel(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// KPI Section
                Wrap(
                  spacing: AppSizes.spaceMedium, // Horizontal gap between cards
                  runSpacing:
                      AppSizes.spaceMedium, // Vertical gap if cards wrap
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

                const SizedBox(height: AppSizes.spaceLarge),

                // Placeholder for future charts/tables
                Text(
                  'Detailed Analytics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
