import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/selected_date_range_provider.dart';
import '../utils/responsive.dart';

// TODO: Validate Dates before closing dialog

class CalendarDateRangePicker extends ConsumerWidget {
  const CalendarDateRangePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateState = ref.watch(selectedDateStateNotifier);
    final config = CalendarDatePicker2Config(
      rangeBidirectional: true,
      firstDate: DateTime.utc(1900, 01, 01),
      selectedRangeHighlightColor:
          Theme.of(context).colorScheme.tertiaryContainer,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Theme.of(context).colorScheme.tertiary,
      weekdayLabelTextStyle: TextStyle(
        // color: Theme.of(context).colorScheme.onSurface,
        color: Theme.of(context).colorScheme.onBackground,
        // color: Colors.indigo,
        fontSize: Responsive.isSmallScreen(context) ? 12 : 15,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: TextStyle(
        // color: Theme.of(context).colorScheme.onSurface,
        color: Colors.red,
        fontSize: Responsive.isSmallScreen(context) ? 9 : 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: Responsive.isSmallScreen(context) ? 12 : 15,
      ),
      disabledDayTextStyle: TextStyle(
        // color: Theme.of(context).colorScheme.onSurface,
        color: Colors.grey,
        fontSize: Responsive.isSmallScreen(context) ? 10 : 15,
      ),
      dayMaxWidth: Responsive.isSmallScreen(context) ? 30 : 40,
    );
    return Column(
      // direction:
      // Responsive.isSmallScreen(context) ? Axis.horizontal : Axis.vertical,
      // Responsive.isSmallScreen(context) ? Axis.vertical : Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        // const Text('Range Date Picker (With default value)'),
        const SizedBox(height: 20),
        Flex(
          direction: Responsive.isSmallScreen(context)
              ? Axis.vertical
              : Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  },
                ),
              ),
            ),
            SizedBox(
              height: Responsive.isSmallScreen(context)
                  ? 200
                  : (config.controlsHeight ?? 52) + (42 * (6 + 1)),
              width: 150,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // color: Theme.of(context).colorScheme.secondary,
                ),
                child: Flex(
                  // direction: Responsive.isSmallScreen(context)
                  //     ? Axis.horizontal
                  //     : Axis.vertical,
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      // decoration: BoxDecoration(color: Colors.purple[100]),
                      child: TextButton(
                        child: const Text(
                          "Clear Selection",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.onTertiary,
                              ),
                        ),
                        onPressed: () {
                          selectedDateState.setSelectedDates([]);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      // decoration: BoxDecoration(color: Colors.indigo[100]),
                      child: TextButton(
                        child: const Text(
                          "All Time",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate = DateTime.utc(1900, 01, 01);
                          selectedDateState.setSelectedDates(
                            [
                              startDate,
                              endDate,
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        child: const Text(
                          "Last 30 days",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate =
                              endDate.subtract(const Duration(days: 30));
                          selectedDateState.setSelectedDates(
                            [
                              startDate,
                              endDate,
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        child: const Text(
                          "Last 3 months",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate = DateTime(
                              endDate.year, endDate.month - 3, endDate.day);
                          selectedDateState.setSelectedDates(
                            [
                              startDate,
                              endDate,
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        child: const Text(
                          "Last 6 months",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate = DateTime(
                              endDate.year, endDate.month - 6, endDate.day);
                          selectedDateState.setSelectedDates(
                            [
                              startDate,
                              endDate,
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        child: const Text(
                          "Last year",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        onPressed: () {
                          DateTime endDate = DateTime.now();
                          DateTime startDate = DateTime(
                              endDate.year - 1, endDate.month, endDate.day);
                          selectedDateState.setSelectedDates(
                            [
                              startDate,
                              endDate,
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                selectedDateState.selectedDateRange,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
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
