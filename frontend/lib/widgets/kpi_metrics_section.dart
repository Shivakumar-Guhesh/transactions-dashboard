import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/transaction_filters_in.dart';
import 'package:frontend/providers/selected_date_range_provider.dart';
import 'package:frontend/providers/transaction_data_provider.dart';

import 'kpi_metric_card.dart';

class KpiMetricsSection extends ConsumerWidget {
  const KpiMetricsSection({
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
    var uptoLastMonthFilter = TransactionsFiltersIn(
      excludeExpenses: expense,
      excludeIncomes: income,
      startDate: startDate,
      endDate: DateTime(endDate.year, endDate.month - 1, endDate.day),
    );
    var uptoLastYearFilter = TransactionsFiltersIn(
      excludeExpenses: expense,
      excludeIncomes: income,
      startDate: startDate,
      endDate: DateTime(endDate.year - 1, endDate.month, endDate.day),
    );
    var transactionsFiltersIn = TransactionsFiltersIn(
        excludeExpenses: expense,
        excludeIncomes: income,
        startDate: startDate,
        endDate: endDate);
    Map<String, dynamic> netWorthUptoLastMonth = {};
    double totalExpenseUptoLastMonth = 0.0;
    double totalIncomeUptoLastMonth = 0.0;

    Map<String, dynamic> netWorthUptoLastYear = {};
    double totalExpenseUptoLastYear = 0.0;
    double totalIncomeUptoLastYear = 0.0;
    final netWorthData = ref.watch(netWorthProvider(transactionsFiltersIn));
    final totalExpenseData =
        ref.watch(totalExpenseProvider(transactionsFiltersIn));
    final totalIncomeData =
        ref.watch(totalIncomeProvider(transactionsFiltersIn));

    final netWorthUptoLastMonthData =
        ref.watch(netWorthProvider(uptoLastMonthFilter));
    final totalExpenseUptoLastMonthData =
        ref.watch(totalExpenseProvider(uptoLastMonthFilter));
    final totalIncomeUptoLastMonthData =
        ref.watch(totalIncomeProvider(uptoLastMonthFilter));

    final netWorthUptoLastYearData =
        ref.watch(netWorthProvider(uptoLastYearFilter));
    final totalExpenseUptoLastYearData =
        ref.watch(totalExpenseProvider(uptoLastYearFilter));
    final totalIncomeUptoLastYearData =
        ref.watch(totalIncomeProvider(uptoLastYearFilter));
    /* ========================================================================== */
    /*                  Initialize all dependent providers first                  */
    /* ========================================================================== */
    var netWorthUptoLastMonthCard = netWorthUptoLastMonthData.when(
      data: (data) {
        netWorthUptoLastMonth = data;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );
    var totalExpenseUptoLastMonthCard = totalExpenseUptoLastMonthData.when(
      data: (data) {
        totalExpenseUptoLastMonth = data;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );
    var totalIncomeUptoLastMonthCard = totalIncomeUptoLastMonthData.when(
      data: (data) {
        totalIncomeUptoLastMonth = data;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );

    var netWorthUptoLastYearCard = netWorthUptoLastYearData.when(
      data: (data) {
        netWorthUptoLastYear = data;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );
    var totalExpenseUptoLastYearCard = totalExpenseUptoLastYearData.when(
      data: (data) {
        totalExpenseUptoLastYear = data;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );
    var totalIncomeUptoLastYearCard = totalIncomeUptoLastYearData.when(
      data: (data) {
        totalIncomeUptoLastYear = data;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );

    netWorthUptoLastMonthCard;
    totalExpenseUptoLastMonthCard;
    totalIncomeUptoLastMonthCard;

    netWorthUptoLastYearCard;
    totalExpenseUptoLastYearCard;
    totalIncomeUptoLastYearCard;
    /* ========================================================================== */
    /*                               Actual UI start                              */
    /* ========================================================================== */
    var netWorthCard = netWorthData.when(
      data: (data) {
        double totalWorth = 0.0;
        for (var key in data.keys) {
          totalWorth += data[key];
        }
        double totalWorthUptoLastMonth = 0.0;
        for (var key in netWorthUptoLastMonth.keys) {
          totalWorthUptoLastMonth += data[key];
        }
        double totalWorthUptoLastYear = 0.0;
        for (var key in netWorthUptoLastYear.keys) {
          totalWorthUptoLastYear += data[key];
        }
        return SizedBox(
          // width: 200,
          // height: 100,
          child: KpiMetricCard(
            title: "Current Net Worth",
            totalValue: totalWorth,
            uptoLastMonthValue: totalWorthUptoLastMonth,
            uptoLastYearValue: totalWorthUptoLastYear,
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const RefreshProgressIndicator();
      },
    );

    var totalExpenseCard = totalExpenseData.when(
      data: (data) {
        // totalExpenseUptoLastMonth = data;
        return SizedBox(
          // width: 200,
          // height: 100,
          child: KpiMetricCard(
            title: "Total Spent Amount",
            totalValue: data,
            uptoLastMonthValue: totalExpenseUptoLastMonth,
            uptoLastYearValue: totalExpenseUptoLastYear,
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const RefreshProgressIndicator();
      },
    );

    var totalIncomeCard = totalIncomeData.when(
      data: (data) {
        return SizedBox(
          // width: 200,
          // height: 150,
          // height: 100,
          child: KpiMetricCard(
            title: "Total Amount Earned",
            totalValue: data,
            uptoLastMonthValue: totalIncomeUptoLastMonth,
            uptoLastYearValue: totalIncomeUptoLastYear,
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const RefreshProgressIndicator();
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        netWorthCard,
        totalExpenseCard,
        // totalExpenseUptoLastMonthCard,
        totalIncomeCard,
      ],
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     border: Border.all(color: Colors.blue),
    //     //  Colors.blue
    //   ),
    //   child: const Row(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Card(
    //             child: KpiMetricCard(
    //                 title: "Current Net Worth", value: "₹ 1000000")),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Card(
    //             child: KpiMetricCard(
    //                 title: "Change % since last month", value: "₹ 1000000")),
    //       ),
    //       // Text(getUser().toString())
    //     ],
    //   ),
    // );
  }
}
