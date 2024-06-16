import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/transaction_filters_in.dart';
import 'package:frontend/providers/transaction_data_provider.dart';

import 'kpi_metric_card.dart';

class KpiMetricsSection extends ConsumerWidget {
  const KpiMetricsSection({
    super.key,
  });

  @override
  build(BuildContext context, ref) {
    final selectedCategoriesState = ref.watch(selectedCategoriesStateNotifier);
    final expense = selectedCategoriesState.deSelectedExpenses;
    final income = selectedCategoriesState.deSelectedIncomes;
    var transactionsFiltersIn =
        TransactionsFiltersIn(excludeExpenses: expense, excludeIncomes: income);
    final netWorthData = ref.watch(netWorthProvider(transactionsFiltersIn));
    final totalExpense = ref.watch(totalExpenseProvider(transactionsFiltersIn));
    final totalIncome = ref.watch(totalIncomeProvider(transactionsFiltersIn));
    var netWorthCard = netWorthData.when(
      data: (data) {
        double totalWorth = 0.0;
        for (var key in data.keys) {
          totalWorth += data[key];
        }
        return SizedBox(
          width: 150,
          height: 150,
          child: Card(
              child:
                  KpiMetricCard(title: "Current Net Worth", value: totalWorth)),
          // Text(getUser().toString())
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const RefreshProgressIndicator();
      },
    );
    var totalExpenseCard = totalExpense.when(
      data: (data) {
        return SizedBox(
          width: 150,
          height: 150,
          child: Card(
              child: KpiMetricCard(title: "Total Spent Amount", value: data)),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const RefreshProgressIndicator();
      },
    );
    var totalIncomeCard = totalIncome.when(
      data: (data) {
        return SizedBox(
          width: 150,
          height: 150,
          child: Card(
              child: KpiMetricCard(title: "Total Spent Earned", value: data)),
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
