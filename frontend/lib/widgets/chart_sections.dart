import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_filters_in.dart';
import '../providers/selected_categories_provider.dart';
import '../providers/selected_date_range_provider.dart';
import '../providers/transaction_data_provider.dart';
import '../utils/responsive.dart';
import './monthly_balance_line_chart.dart';
import './summarized_donut_chart.dart';

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
          amounts.add(expense['sum'].toDouble());
        }

        return SummarizedDonutChart(
          sliceData: data,
          title: "Expense by category",
          baseRadius: (Responsive.isSmallScreen(context) ? 30.0 : 40.0),
          selectedRadius: (Responsive.isSmallScreen(context) ? 50.0 : 70.0),
          selectedLabelFontSize:
              (Responsive.isSmallScreen(context) ? 12.0 : 20.0),
          baseLabelFontSize: (Responsive.isSmallScreen(context) ? 10.0 : 12.0),
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
          amounts.add(expense['Balance'].toDouble());
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
      height: (Responsive.isLargeScreen(context)) ? 400 : 800,
      child: Flex(
        direction:
            Responsive.isLargeScreen(context) ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: monthlyBalanceLineChart,
          ),
          if (!Responsive.isLargeScreen(context))
            const SizedBox(
              height: 100,
            ),
          Expanded(
            child: categoryDonutChart,
          ),
        ],
      ),
    );
  }
}
