import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final selectedDateStateNotifier =
    ChangeNotifierProvider((ref) => SelectedDateRangeState());

class SelectedDateRangeState extends ChangeNotifier {
  List<DateTime?> selectedDateRange = [
    DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
    DateTime.now(),
  ];

  void setStartDate(DateTime startDate) {
    selectedDateRange = [];
    // selectedDateRange[0] = startDate;
    selectedDateRange.add(startDate);
    notifyListeners();
  }

  void setSelectedDates(List<DateTime?> dates) {
    selectedDateRange = dates;
    // var oldStartDate = selectedDateRange[0];
    // var oldEndDate = selectedDateRange[1];

    selectedDateRange = [];
    for (var date in dates) {
      selectedDateRange.add(date);
    }
    // selectedDateRange = dates;
    notifyListeners();
  }

  String get formattedDates {
    String output = "";
    if (selectedDateRange.isNotEmpty && selectedDateRange[0] != null) {
      output +=
          '${DateFormat('yyyy-MM-dd').format(selectedDateRange[0]!).toString()}'
          " : ";
    }
    if (selectedDateRange.length > 1 && selectedDateRange[1] != null) {
      output +=
          DateFormat('yyyy-MM-dd').format(selectedDateRange[1]!).toString();
    }
    return output;
  }
}
