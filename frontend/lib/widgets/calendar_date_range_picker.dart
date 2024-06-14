import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/selected_date_range_provider.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarDateRangePicker extends ConsumerWidget {
  const CalendarDateRangePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateState = ref.watch(selectedDateStateNotifier);
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.blue[800],
      weekdayLabelTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const Text('Range Date Picker (With default value)'),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: (config.controlsHeight ?? 52) + (42 * (6 + 1)),
              child: Container(
                decoration: const BoxDecoration(color: Colors.brown),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.purple[100]),
                      child: TextButton(
                        child: const Text("Clear Selection"),
                        onPressed: () {
                          selectedDateState.setSelectedDates([]);
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.indigo[100]),
                      child: TextButton(
                        child: const Text("Last 7 days"),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate =
                              endDate.subtract(const Duration(days: 7));
                          selectedDateState.setSelectedDates([
                            startDate,
                            endDate,
                          ]);
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: TextButton(
                        child: const Text("Last 30 days"),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate =
                              endDate.subtract(const Duration(days: 30));
                          selectedDateState.setSelectedDates([
                            startDate,
                            endDate,
                          ]);
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.green),
                      child: TextButton(
                        child: const Text("Last 3 months"),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate = DateTime(
                              endDate.year, endDate.month - 3, endDate.day);
                          selectedDateState.setSelectedDates([
                            startDate,
                            endDate,
                          ]);
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.yellow),
                      child: TextButton(
                        child: const Text("Last 6 months"),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate = DateTime(
                              endDate.year, endDate.month - 6, endDate.day);
                          selectedDateState.setSelectedDates([
                            startDate,
                            endDate,
                          ]);
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      child: TextButton(
                        child: const Text("Last year"),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate = DateTime(
                              endDate.year - 1, endDate.month, endDate.day);
                          selectedDateState.setSelectedDates([
                            startDate,
                            endDate,
                          ]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                width: 350,
                child: CalendarDatePicker2(
                    config: config,
                    // value: _rangeDatePickerValueWithDefaultValue,
                    value: selectedDateState.selectedDateRange,
                    onValueChanged: (dates) {
                      if (dates[0] != null && dates[dates.length - 1] != null) {
                        selectedDateState.setSelectedDates(dates);
                      }
                      // selectedDateState.setSelectedDates(dates);
                    }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Text(selectedDateState.selectedDateRange.toString()),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                  config.calendarType,
                  // _rangeDatePickerValueWithDefaultValue,
                  selectedDateState.selectedDateRange),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}
