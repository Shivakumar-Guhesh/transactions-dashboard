import 'package:flutter/material.dart';

import 'package:frontend/widgets/multi_check_box_drop_down.dart';
import 'package:frontend/providers/transaction_data_provider.dart';

import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/selected_date_range_provider.dart';
import 'package:frontend/widgets/dark_mode_switch.dart';
import 'package:frontend/widgets/calendar_date_range_picker.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class TopBar extends ConsumerStatefulWidget {
  const TopBar({
    super.key,
  });

  @override
  ConsumerState<TopBar> createState() {
    return _TopBarState();
  }
}

class _TopBarState extends ConsumerState<TopBar> {
  bool showFilters = false;
  var shouldSavePreference = false;

  _toggleFilter() {
    setState(() {
      showFilters = !showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateState = ref.watch(selectedDateStateNotifier);
    final selectedCategoriesState = ref.read(selectedCategoriesStateNotifier);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Transaction Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.red,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        // backgroundColor: Theme.of(context).colorScheme.surface,
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
                        selectedDateState.formattedDates,
                        style: TextStyle(
                          // color: Colors.red,
                          color: Theme.of(context).colorScheme.onPrimary,
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
                    const DarkModeSwitch(),
                    IconButton(
                      onPressed: _toggleFilter,
                      icon: const Icon(Icons.filter_alt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showFilters)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            // color: Colors.red[200],
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const MultiCheckBoxDropDown(
                  type: TransactionType.expense,
                ),
                const MultiCheckBoxDropDown(
                  type: TransactionType.income,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: shouldSavePreference,
                        onChanged: (value) async {
                          if (value == true) {
                            await selectedCategoriesState
                                .savePreferencesToFile();
                          } else {
                            await selectedCategoriesState
                                .clearPreferencesFromFile();
                          }
                          setState(() {
                            shouldSavePreference = value!;
                          });
                        }),
                    const Text("Remember Preferences"),
                  ],
                ),
                ElevatedButton.icon(
                  label: const Text("Close"),
                  icon: const Icon(Icons.close),
                  onPressed: _toggleFilter,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
