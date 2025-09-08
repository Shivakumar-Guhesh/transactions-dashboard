import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/transaction_filters_in.dart';
import '../providers/selected_categories_provider.dart';
import '../providers/selected_date_range_provider.dart';
import '../providers/transaction_data_provider.dart';
import '../utils/responsive.dart';
// import './radial_gauge_chart.dart';
import './kpi_metric_card.dart';

final DateTime oldestDate = DateTime.utc(1900, 01, 01);
final DateTime currentDate = DateTime.now();

final indianRupeesFormat = NumberFormat.currency(
  name: "INR",
  locale: 'en_IN',
  decimalDigits: 2, // change it to get decimal places
  symbol: '₹ ',
);

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
      endDate: DateTime(
        endDate.year,
        endDate.month - 1,
        endDate.day,
      ),
    );
    var uptoLastYearFilter = TransactionsFiltersIn(
      excludeExpenses: expense,
      excludeIncomes: income,
      startDate: startDate,
      endDate: DateTime(
        endDate.year - 1,
        endDate.month,
        endDate.day,
      ),
    );
    var transactionsFiltersIn = TransactionsFiltersIn(
      excludeExpenses: expense,
      excludeIncomes: income,
      startDate: startDate,
      endDate: endDate,
    );

    final transactionsFiltersInWithoutDates = TransactionsFiltersIn(
      excludeExpenses: expense,
      excludeIncomes: income,
      startDate: oldestDate,
      endDate: currentDate,
    );

    Map<String, dynamic> netWorthUptoLastMonth = {};
    Map<String, dynamic> liquidWorthUptoLastMonth = {};
    double totalExpenseUptoLastMonth = 0.0;
    double totalIncomeUptoLastMonth = 0.0;

    Map<String, dynamic> netWorthUptoLastYear = {};
    Map<String, dynamic> liquidWorthUptoLastYear = {};
    double totalExpenseUptoLastYear = 0.0;
    double totalIncomeUptoLastYear = 0.0;

    double currentMonthBalance = 0.0;
    double uptoLastMonthBalance = 0.0;
    double uptoLastYearBalance = 0.0;

    // double totalIncomeValue = 0.0;
    // double totalExpenseValue = 0.0;
    // double netWorthValue = 0.0;
    // double liquidWorthValue = 0.0;
    Map<String, dynamic> netWorthMap = {};
    Map<String, dynamic> liquidWorthMap = {};

    final monthlyBalanceData = ref.watch(
      monthlyBalanceProvider(transactionsFiltersInWithoutDates),
    );
    final netAssetsData = ref.watch(netAssetsProvider(transactionsFiltersIn));
    final liquidAssetsData =
        ref.watch(liquidAssetsProvider(transactionsFiltersIn));
    final totalExpenseData =
        ref.watch(totalExpenseProvider(transactionsFiltersIn));
    final totalIncomeData =
        ref.watch(totalIncomeProvider(transactionsFiltersIn));

    final monthlyBalanceUptoLastMonthData = ref.watch(
      monthlyBalanceProvider(uptoLastMonthFilter),
    );
    final netWorthUptoLastMonthData =
        ref.watch(netAssetsProvider(uptoLastMonthFilter));
    final liquidWorthUptoLastMonthData =
        ref.watch(liquidAssetsProvider(uptoLastMonthFilter));
    final totalExpenseUptoLastMonthData =
        ref.watch(totalExpenseProvider(uptoLastMonthFilter));
    final totalIncomeUptoLastMonthData =
        ref.watch(totalIncomeProvider(uptoLastMonthFilter));

    final monthlyBalanceUptoLastYearData = ref.watch(
      monthlyBalanceProvider(uptoLastYearFilter),
    );
    final netWorthUptoLastYearData =
        ref.watch(netAssetsProvider(uptoLastYearFilter));
    final liquidWorthUptoLastYearData =
        ref.watch(liquidAssetsProvider(uptoLastYearFilter));
    final totalExpenseUptoLastYearData =
        ref.watch(totalExpenseProvider(uptoLastYearFilter));
    final totalIncomeUptoLastYearData =
        ref.watch(totalIncomeProvider(uptoLastYearFilter));
    /* ========================================================================== */
    /*                  Initialize all dependent providers first                  */
    /* ========================================================================== */
    var monthlyBalanceCard = monthlyBalanceData.when(data: (data) {
      currentMonthBalance = data[data.length - 1]['Balance'];
      return;
    }, error: (error, stackTrace) {
      return Text(error.toString());
    }, loading: () {
      currentMonthBalance = 0;
      return;
    });

    var monthlyBalanceUptoLastMonthCard =
        monthlyBalanceUptoLastMonthData.when(data: (data) {
      uptoLastMonthBalance = data[data.length - 1]['Balance'];
      return;
    }, error: (error, stackTrace) {
      return Text(error.toString());
    }, loading: () {
      return;
    });

    var monthlyBalanceUptoLastYearCard =
        monthlyBalanceUptoLastYearData.when(data: (data) {
      uptoLastYearBalance = data[data.length - 1]['Balance'];
      return;
    }, error: (error, stackTrace) {
      return Text(error.toString());
    }, loading: () {
      return;
    });

    var netWorthUptoLastMonthCard = netWorthUptoLastMonthData.when(
      data: (data) {
        netWorthUptoLastMonth = data;
        netWorthUptoLastMonth['Cash'] = uptoLastMonthBalance;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );
    var liquidWorthUptoLastMonthCard = liquidWorthUptoLastMonthData.when(
      data: (data) {
        liquidWorthUptoLastMonth = data;
        liquidWorthUptoLastMonth['Cash'] = uptoLastMonthBalance;
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
        // double totalWorth = currentMonthBalance;
        netWorthUptoLastYear = data;
        netWorthUptoLastYear['Cash'] = uptoLastYearBalance;
        return;
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return;
      },
    );
    var liquidWorthUptoLastYearCard = liquidWorthUptoLastYearData.when(
      data: (data) {
        // double liquidWorth = currentMonthBalance;

        // double totalWorth = currentMonthBalance;
        liquidWorthUptoLastYear = data;
        liquidWorthUptoLastYear['Cash'] = uptoLastYearBalance;
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

    monthlyBalanceCard;
    monthlyBalanceUptoLastMonthCard;
    monthlyBalanceUptoLastYearCard;
    netWorthUptoLastMonthCard;
    liquidWorthUptoLastMonthCard;
    totalExpenseUptoLastMonthCard;
    totalIncomeUptoLastMonthCard;

    netWorthUptoLastYearCard;
    liquidWorthUptoLastYearCard;
    totalExpenseUptoLastYearCard;
    totalIncomeUptoLastYearCard;

    /* ========================================================================== */
    /*                               Actual UI start                              */
    /* ========================================================================== */
    var netWorthCard = netAssetsData.when(
      data: (data) {
        // double totalWorth = currentMonthBalance;
        double totalWorth = 0.0;
        netWorthMap = data;
        netWorthMap['Cash'] = currentMonthBalance;
        for (var key in netWorthMap.keys) {
          totalWorth += netWorthMap[key];
        }
        // netWorthValue = totalWorth;
        // double worthUptoLastMonth = uptoLastMonthBalance;
        double worthUptoLastMonth = 0.0;
        for (var key in netWorthUptoLastMonth.keys) {
          worthUptoLastMonth += netWorthUptoLastMonth[key];
        }
        // double worthUptoLastYear = uptoLastYearBalance;
        double worthUptoLastYear = 0.0;
        for (var key in netWorthUptoLastYear.keys) {
          worthUptoLastYear += netWorthUptoLastYear[key];
        }
        return SizedBox(
          // width: 200,
          // height: 100,
          child: KpiMetricCard(
            title: "Current Net Worth",
            totalValue: totalWorth,
            uptoLastMonthValue: worthUptoLastMonth,
            uptoLastYearValue: worthUptoLastYear,
            hoverChild: Column(
                children: netWorthMap.entries.map(
              (entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.key.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const Text(" : "),
                    Text(indianRupeesFormat.format(entry.value)),
                  ],
                );
              },
            ).toList()
                // ],
                ),
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

    var liquidWorthCard = liquidAssetsData.when(
      data: (data) {
        // double liquidWorth = currentMonthBalance;
        double liquidWorth = 0.0;
        liquidWorthMap = data;
        liquidWorthMap['Cash'] = currentMonthBalance;
        for (var key in liquidWorthMap.keys) {
          liquidWorth += liquidWorthMap[key];
        }
        // liquidWorthValue = liquidWorth;
        // double worthUptoLastMonth = uptoLastMonthBalance;
        double worthUptoLastMonth = 0.0;
        for (var key in liquidWorthUptoLastMonth.keys) {
          worthUptoLastMonth += liquidWorthUptoLastMonth[key];
        }
        // double worthUptoLastYear = uptoLastYearBalance;
        double worthUptoLastYear = 0.0;
        for (var key in liquidWorthUptoLastYear.keys) {
          worthUptoLastYear += liquidWorthUptoLastYear[key];
        }
        return SizedBox(
          // width: 200,
          // height: 100,
          child: KpiMetricCard(
            title: "Current Liquid Worth",
            totalValue: liquidWorth,
            uptoLastMonthValue: worthUptoLastMonth,
            uptoLastYearValue: worthUptoLastYear,
            hoverChild: Column(
                children: liquidWorthMap.entries.map(
              (entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(entry.key.toString()),
                    const Text(" : "),
                    // Text(entry.value.toString()),
                    Text(indianRupeesFormat.format(entry.value)),
                  ],
                );
              },
            ).toList()
                // ],
                ),
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
        // totalExpenseValue = data;
        return SizedBox(
          // width: 200,
          // height: 100,
          child: KpiMetricCard(
            title: "Total Spent Amount",
            totalValue: data,
            uptoLastMonthValue: totalExpenseUptoLastMonth,
            uptoLastYearValue: totalExpenseUptoLastYear,
            // hoverChild: Text(
            //   data.toString(),
            // ),
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
        // totalIncomeValue = data;
        return SizedBox(
          // width: 200,
          // height: 150,
          // height: 100,
          child: KpiMetricCard(
            title: "Total Earned Amount",
            totalValue: data,
            uptoLastMonthValue: totalIncomeUptoLastMonth,
            uptoLastYearValue: totalIncomeUptoLastYear,
            // hoverChild: Text(
            //   data.toString(),
            // ),
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

    if (Responsive.isMediumScreen(context)) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              liquidWorthCard,
              netWorthCard,
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              totalExpenseCard,
              totalIncomeCard
              // RadialGaugeChart(
              //   value: (netWorthValue == 0 || totalIncomeValue == 0)
              //       ? 0
              //       : (netWorthValue / totalIncomeValue) * 100,
              // ),
            ],
          ),
        ],
      );
    } else {
      return Flex(
        direction:
            Responsive.isSmallScreen(context) ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          liquidWorthCard,
          netWorthCard,
          totalExpenseCard,
          totalIncomeCard,
          // RadialGaugeChart(
          //   value: (netWorthValue == 0 || totalIncomeValue == 0)
          //       ? 0
          //       : (netWorthValue / totalIncomeValue) * 100,
          // ),
        ],
      );
    }
  }
}
