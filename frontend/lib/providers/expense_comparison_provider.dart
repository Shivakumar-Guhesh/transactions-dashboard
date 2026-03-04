import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../schemas/transaction_schemas.dart';
import 'repository_provider.dart';

final expenseComparisonProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, TransactionsFiltersRequest>((
      ref,
      filters,
    ) async {
      final repo = ref.watch(transactionRepositoryProvider);

      final results = await Future.wait([
        repo.getDailyExpenseSum(filters: filters),
        repo.getDailyExpenseSum(filters: filters.tillLastMonthEnd()),
      ]);

      List<double> getCumulativeValues(
        Map<String, double> data,
        DateTime referenceDate, {
        bool isCurrentMonth = false,
      }) {
        List<double> cumulativeValues = [];
        double runningTotal = 0.0;

        final lastDayOfMonth = DateTime(
          referenceDate.year,
          referenceDate.month + 1,
          0,
        );
        final totalDaysInMonth = lastDayOfMonth.day;

        int stopDay = isCurrentMonth ? referenceDate.day : totalDaysInMonth;

        for (int i = 1; i <= stopDay; i++) {
          final dateToMatch = DateTime(
            referenceDate.year,
            referenceDate.month,
            i,
          );
          final String dayKey =
              "${dateToMatch.year}-${dateToMatch.month.toString().padLeft(2, '0')}-${dateToMatch.day.toString().padLeft(2, '0')}";

          double dayAmount = data[dayKey] ?? 0.0;
          runningTotal += dayAmount;

          cumulativeValues.add(runningTotal);
        }
        return cumulativeValues;
      }

      final today = filters.endDate ?? DateTime.now();

      final lastMonthDate = DateTime(today.year, today.month - 1, 1);

      return {
        'current': getCumulativeValues(results[0], today, isCurrentMonth: true),
        'previous': getCumulativeValues(
          results[1],
          lastMonthDate,
          isCurrentMonth: false,
        ),
        // Add dynamic names
        'currentMonthName': DateFormat('MMMM').format(today),
        'prevMonthName': DateFormat('MMMM').format(lastMonthDate),
      };
    });
