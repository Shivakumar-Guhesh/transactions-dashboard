import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final selectedDateStateNotifier =
    ChangeNotifierProvider((ref) => SelectedDateRangeState());

class SelectedDateRangeState extends ChangeNotifier {
  List<DateTime?> selectedDateRange = [
    DateTime(2024, 5, 6),
    DateTime(2024, 5, 21),
  ];

  void setSelectedDates(List<DateTime?> dates) {
    selectedDateRange = dates;
    notifyListeners();
  }

  String get formattedDates {
    String output = "";
    if (selectedDateRange.length > 0 && selectedDateRange[0] != null) {
      output +=
          '${DateFormat('yyyy-MM-dd').format(selectedDateRange[0]!).toString()}'
          " : ";
    }
    if (selectedDateRange.length > 1 && selectedDateRange[1] != null) {
      output +=
          '${DateFormat('yyyy-MM-dd').format(selectedDateRange[1]!).toString()}';
    }
    return output;
  }
}
