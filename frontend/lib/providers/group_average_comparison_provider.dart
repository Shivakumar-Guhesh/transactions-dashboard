import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_provider.dart';
import '../models/group_average_comparison.dart';
import '../schemas/transaction_schemas.dart';

final groupAvgComparisonProvider = FutureProvider.autoDispose
    .family<List<GroupAverageComparison>, TransactionsFiltersRequest>((
      ref,
      filters,
    ) async {
      final repo = ref.watch(transactionRepositoryProvider);

      final currentMonthFilters = filters.fromCurrentMonthStart();

      final Map<String, double> currentCategorySum = await repo
          .getCategoryExpenseSum(filters: currentMonthFilters);

      final top5Entries = currentCategorySum.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final limitedEntries = top5Entries.take(5).toList();

      final historicalFilters = filters.tillLastMonthEnd();

      final List<Future<double>> averageFutures = limitedEntries.map((entry) {
        return repo.getCategoryExpenseAvg(
          filters: AverageAmountRequest(
            group: entry.key,
            excludeExpenses: historicalFilters.excludeExpenses,
            excludeIncomes: historicalFilters.excludeIncomes,
            startDate: historicalFilters.startDate,
            endDate: historicalFilters.endDate,
          ),
        );
      }).toList();

      final List<double> historicalAverages = await Future.wait(averageFutures);

      return List.generate(limitedEntries.length, (index) {
        final entry = limitedEntries[index];
        return GroupAverageComparison(
          group: entry.key,
          currentAmount: entry.value,
          averageAmount: historicalAverages[index],
        );
      });
    });
