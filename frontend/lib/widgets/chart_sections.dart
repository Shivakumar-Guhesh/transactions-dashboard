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

final List<String> items = [
  "Category-wise Expense",
  "Category-wise Income",
  "Mode-wise Expense",
  "Mode-wise Income"
];

class ChartsSection extends ConsumerStatefulWidget {
  const ChartsSection({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChartsSectionState();
  }
}

class _ChartsSectionState extends ConsumerState<ChartsSection> {
  String selectedItem = items[0];

  void toggleSelected(String? currentSelection) {
    setState(
      () {
        if (currentSelection == null || currentSelection == items[0]) {
          selectedItem = items[0];
        } else if (currentSelection == items[1]) {
          selectedItem = items[1];
        } else if (currentSelection == items[2]) {
          selectedItem = items[2];
        } else if (currentSelection == items[3]) {
          selectedItem = items[3];
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

    Map<String, AsyncValue<Map<String, dynamic>>> summarizedDataForDonut = {};

    summarizedDataForDonut[items[0]] = catExpenseSumData;

    /* ========== ASSIGN summarizedDataForDonut for categoryDonutChart ========== */
    if (selectedItem == items[0]) {
      summarizedDataForDonut[selectedItem] = catExpenseSumData;
    } else if (selectedItem == items[1]) {
      summarizedDataForDonut[selectedItem] = catIncomeSumData;
    } else if (selectedItem == items[2]) {
      summarizedDataForDonut[selectedItem] = modeExpenseSumData;
    } else if (selectedItem == items[3]) {
      summarizedDataForDonut[selectedItem] = modeIncomeSumData;
    } else {
      selectedItem = items[0];
    }
    /* ===================== Based on DropDownMenuSelection ===================== */

    var categoryDonutChart = summarizedDataForDonut[selectedItem]!.when(
      data: (data) {
        /* ===== catExpenseSumData is [{category: category1, sum: sum1}...] ==== */
        /* ===== modeExpenseSumData is [{transaction_mode: mode1, sum: sum1}...] ==== */
        /* =========== UPDATING THE DATA LIST TO MAKE BOTH HAVE SAME KEYS =========== */

        // final keys = data[0].keys.toList();
        List<Map<String, dynamic>> dataWithUpdatedKeys = [];

        // dataWithUpdatedKeys = data.entries.map((entry) {
        //   return {entry.key: entry.value};
        // }).toList();
        data.forEach((key, value) {
          dataWithUpdatedKeys.add({'category': key, 'sum': value});
        });

        // for (var element in data) {
        //   dataWithUpdatedKeys
        //       .add({'category': element[keys[0]], 'sum': element['sum']});
        // }

        dataWithUpdatedKeys.sort((a, b) => b["sum"].compareTo(a["sum"]));
        List<String> categories = [];
        List<double> amounts = [];
        for (var expense in dataWithUpdatedKeys) {
          categories.add(expense['category'] as String);
        }
        for (var expense in dataWithUpdatedKeys) {
          amounts.add(expense['sum'].toDouble());
        }

        return SummarizedDonutChart(
          sliceData: dataWithUpdatedKeys,
          title: selectedItem,
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
            child: Stack(
              children: [
                categoryDonutChart,
                IntrinsicWidth(
                  // width: 250,
                  child: DropdownButtonFormField(
                    hint: Text(
                      selectedItem,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    focusColor: Colors.transparent,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    value: null,
                    onChanged: (i) {
                      toggleSelected(i);
                    },
                    items: items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: SizedBox(
                              height: kMinInteractiveDimension,
                              child: Text(item),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
