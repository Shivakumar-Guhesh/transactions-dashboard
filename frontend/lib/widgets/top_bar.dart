import 'package:flutter/material.dart';
import 'package:frontend/providers/selected_date_range_provider.dart';
import 'package:frontend/providers/theme_provider.dart';

import 'package:frontend/widgets/calendar_date_range_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class TopBar extends HookConsumerWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateState = ref.watch(selectedDateStateNotifier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(color: Colors.grey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(
            flex: 1,
            child: Text(
              "Transaction Dashboard",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[350],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    // backgroundColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CalendarDateRangePicker(),
                    ),
                  );
                },
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                  ),
                  Text(
                    // 'Show Dialog',
                    // '${DateFormat('yyyy-MM-dd').format(selectedDateState.selectedDateRange[0]!).toString()}'
                    // " : "
                    // '${DateFormat('yyyy-MM-dd').format(selectedDateState.selectedDateRange[1]!).toString()}',
                    selectedDateState.formattedDates,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //     onPressed: () {}, icon: const Icon(Icons.light_mode)),
                const DarkModeSwitch(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: .0),
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.filter_alt)),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.settings_rounded)),
              ],
            ),
          ),

          // Icon(Icons.light_mode)
        ],
      ),
    );
  }
}

class DarkModeSwitch extends HookConsumerWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: .0),
          child: Icon(
            appThemeState.isDarkModeEnabled
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
        ),
        Switch(
          value: appThemeState.isDarkModeEnabled,
          onChanged: (enabled) {
            if (enabled) {
              appThemeState.setDarkTheme();
            } else {
              appThemeState.setLightTheme();
            }
          },
        ),
      ],
    );
  }
}
