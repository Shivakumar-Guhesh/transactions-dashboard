import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_filters_in.dart';
import '../providers/selected_categories_provider.dart';
import '../providers/selected_date_range_provider.dart';
import '../providers/transaction_data_provider.dart';
import '../utils/responsive.dart';
import './radial_gauge_chart.dart';
import './kpi_metric_card.dart';

final DateTime oldestDate = DateTime.utc(1900, 01, 01);
final DateTime currentDate = DateTime.now();

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

    final transactionsFiltersInWithoutDates = TransactionsFiltersIn(
        excludeExpenses: expense,
        excludeIncomes: income,
        startDate: oldestDate,
        endDate: currentDate);

    Map<String, dynamic> netWorthUptoLastMonth = {};
    double totalExpenseUptoLastMonth = 0.0;
    double totalIncomeUptoLastMonth = 0.0;

    Map<String, dynamic> netWorthUptoLastYear = {};
    double totalExpenseUptoLastYear = 0.0;
    double totalIncomeUptoLastYear = 0.0;

    double currentMonthBalance = 0.0;
    double uptoLastMonthBalance = 0.0;
    double uptoLastYearBalance = 0.0;

    double totalIncomeValue = 0.0;
    double totalExpenseValue = 0.0;
    double netWorthValue = 0.0;
    Map<String, dynamic> netWorthMap = {};

    final monthlyBalanceData = ref.watch(
      monthlyBalanceProvider(transactionsFiltersInWithoutDates),
    );
    final netWorthData = ref.watch(netWorthProvider(transactionsFiltersIn));
    final totalExpenseData =
        ref.watch(totalExpenseProvider(transactionsFiltersIn));
    final totalIncomeData =
        ref.watch(totalIncomeProvider(transactionsFiltersIn));

    final monthlyBalanceUptoLastMonthData = ref.watch(
      monthlyBalanceProvider(uptoLastMonthFilter),
    );
    final netWorthUptoLastMonthData =
        ref.watch(netWorthProvider(uptoLastMonthFilter));
    final totalExpenseUptoLastMonthData =
        ref.watch(totalExpenseProvider(uptoLastMonthFilter));
    final totalIncomeUptoLastMonthData =
        ref.watch(totalIncomeProvider(uptoLastMonthFilter));

    final monthlyBalanceUptoLastYearData = ref.watch(
      monthlyBalanceProvider(uptoLastYearFilter),
    );
    final netWorthUptoLastYearData =
        ref.watch(netWorthProvider(uptoLastYearFilter));
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
        double totalWorth = currentMonthBalance;
        netWorthMap = data;
        for (var key in data.keys) {
          totalWorth += data[key];
        }
        netWorthValue = totalWorth;
        double totalWorthUptoLastMonth = uptoLastMonthBalance;
        for (var key in netWorthUptoLastMonth.keys) {
          totalWorthUptoLastMonth += data[key];
        }
        double totalWorthUptoLastYear = uptoLastYearBalance;
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
            hoverChild: Text(
              netWorthMap.toString(),
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
        totalExpenseValue = data;
        return SizedBox(
          // width: 200,
          // height: 100,
          child: KpiMetricCard(
            title: "Total Spent Amount",
            totalValue: data,
            uptoLastMonthValue: totalExpenseUptoLastMonth,
            uptoLastYearValue: totalExpenseUptoLastYear,
            hoverChild: Text(
              data.toString(),
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

    var totalIncomeCard = totalIncomeData.when(
      data: (data) {
        totalIncomeValue = data;
        return SizedBox(
          // width: 200,
          // height: 150,
          // height: 100,
          child: KpiMetricCard(
            title: "Total Earned Amount",
            totalValue: data,
            uptoLastMonthValue: totalIncomeUptoLastMonth,
            uptoLastYearValue: totalIncomeUptoLastYear,
            hoverChild: Text(
              data.toString(),
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

    if (Responsive.isMediumScreen(context)) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Tooltip(
                message: netWorthMap.toString(),
                child: netWorthCard,
              ),
              totalExpenseCard,
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              totalIncomeCard,
              RadialGaugeChart(
                value: (netWorthValue == 0 || totalIncomeValue == 0)
                    ? 0
                    : (netWorthValue / totalIncomeValue) * 100,
              ),
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
          Tooltip(
            message: netWorthMap.toString(),
            child: netWorthCard,
          ),
          totalExpenseCard,
          totalIncomeCard,
          RadialGaugeChart(
            value: (netWorthValue == 0 || totalIncomeValue == 0)
                ? 0
                : (netWorthValue / totalIncomeValue) * 100,
          ),
        ],
      );
    }
  }
}
