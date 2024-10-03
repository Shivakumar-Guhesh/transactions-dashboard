import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/transaction_filters_in.dart';
import 'package:frontend/providers/selected_date_range_provider.dart';
import 'package:frontend/providers/transaction_data_provider.dart';
import 'package:frontend/widgets/monthly_balance_line_chart.dart';
import 'package:frontend/widgets/summarized_donut_chart.dart';

final DateTime oldestDate = DateTime.utc(1900, 01, 01);
final DateTime currentDate = DateTime.now();

class ChartsSection extends ConsumerWidget {
  const ChartsSection({
    super.key,
  });

  @override
  build(BuildContext context, ref) {
    final selectedCategoriesState = ref.watch(selectedCategoriesStateNotifier);
    final selectedDateState = ref.watch(selectedDateStateNotifier);
    final DateTime startDate =
        selectedDateState.selectedDateRange[0] ?? DateTime.utc(-271821, 04, 20);

    final DateTime endDate = selectedDateState.selectedDateRange[
            selectedDateState.selectedDateRange.length - 1] ??
        DateTime.now();
    final expense = selectedCategoriesState.deSelectedExpenses;
    final income = selectedCategoriesState.deSelectedIncomes;

    var transactionsFiltersIn = TransactionsFiltersIn(
        excludeExpenses: expense,
        excludeIncomes: income,
        startDate: startDate,
        endDate: endDate);

    final transactionsFiltersInWithoutDates = TransactionsFiltersIn(
        excludeExpenses: expense,
        excludeIncomes: income,
        startDate: oldestDate,
        endDate: currentDate);

    final catExpenseSumData =
        ref.watch(catExpenseSumProvider(transactionsFiltersIn));
    final catIncomeSumData =
        ref.watch(catIncomeSumProvider(transactionsFiltersIn));
    final modeExpenseSumData =
        ref.watch(modeExpenseSumProvider(transactionsFiltersIn));
    final modeIncomeSumData =
        ref.watch(modeIncomeSumProvider(transactionsFiltersIn));
    final monthlyBalanceData = ref.watch(
      monthlyBalanceProvider(transactionsFiltersInWithoutDates),
    );

    var categoryDonutChart = catExpenseSumData.when(
      data: (data) {
        data.sort((a, b) => b["sum"].compareTo(a["sum"]));
        List<String> categories = [];
        List<double> amounts = [];
        for (var expense in data) {
          categories.add(expense['category'] as String);
        }
        for (var expense in data) {
          amounts.add(expense['sum'] as double);
        }

        return SummarizedDonutChart(
          sliceData: data,
          title: "Expense by category",
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const RefreshProgressIndicator();
      },
    );

    var monthlyBalanceLineChart = monthlyBalanceData.when(
      data: (data) {
        // data.sort((a, b) => b["sum"].compareTo(a["sum"]));
        List<String> months = [];
        List<double> amounts = [];
        for (var expense in data) {
          months.add(expense['Month'] as String);
        }
        for (var expense in data) {
          amounts.add(expense['Balance'] as double);
        }
        return MonthlyBalanceLineChart(months: months, amounts: amounts);
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const RefreshProgressIndicator();
      },
    );

    return SizedBox(
      height: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: monthlyBalanceLineChart),
          Expanded(child: categoryDonutChart),
        ],
      ),
    );
  }
}
