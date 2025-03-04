import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/selected_categories_provider.dart';
import '../utils/responsive.dart';
import './multi_check_box_drop_down.dart';
import '../providers/selected_date_range_provider.dart';
import './dark_mode_switch.dart';
import './calendar_date_range_picker.dart';

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
          // padding: const EdgeInsets.symmetric(horizontal: 8),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Stack(
                  children: [
                    Text(
                      Responsive.isSmallScreen(context)
                          ? "TD"
                          : "Transaction Dashboard\u2122",
                      style: TextStyle(
                        fontFamily: 'Plain_Black',
                        fontSize: 24,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      Responsive.isSmallScreen(context)
                          ? "TD"
                          : "Transaction Dashboard\u2122",
                      style: const TextStyle(
                        fontFamily: 'Plain_Black',
                        fontSize: 24,
                        // color: Theme.of(context).colorScheme.onPrimary,
                        color: Colors.white,
                        // color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              Responsive.isSmallScreen(context)
                  ? TextButton.icon(
                      label: const Text("Select the date"),
                      onPressed: () => showCalendarDialogOnPressed(context),
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.blue,
                      ),
                    )
                  : TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () => showCalendarDialogOnPressed(context),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const DarkModeSwitch(),
                  IconButton(
                    onPressed: _toggleFilter,
                    icon: const Icon(Icons.filter_alt),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showFilters)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            // color: Colors.red[200],
            color: Theme.of(context).colorScheme.surface,
            child: Flex(
              direction: Responsive.isSmallScreen(context)
                  ? Axis.vertical
                  : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const MultiCheckBoxDropDown(
                  type: TransactionType.expense,
                ),
                if (Responsive.isSmallScreen(context))
                  const SizedBox(
                    height: 10,
                  ),
                const MultiCheckBoxDropDown(
                  type: TransactionType.income,
                ),
                if (Responsive.isSmallScreen(context))
                  const SizedBox(
                    height: 10,
                  ),
                Row(
                  mainAxisAlignment: (Responsive.isSmallScreen(context))
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
                  children: [
                    Checkbox(
                      value: shouldSavePreference,
                      onChanged: (value) async {
                        if (value == true) {
                          await selectedCategoriesState.savePreferencesToFile();
                        } else {
                          await selectedCategoriesState
                              .clearPreferencesFromFile();
                        }
                        setState(
                          () {
                            shouldSavePreference = value!;
                          },
                        );
                      },
                    ),
                    const Text("Remember Preferences"),
                  ],
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  label: const Text("Close"),
                  icon: const Icon(Icons.close),
                  onPressed: _toggleFilter,
                ),
                if (Responsive.isSmallScreen(context))
                  const SizedBox(
                    height: 10,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Future<String?> showCalendarDialogOnPressed(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          // backgroundColor: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CalendarDateRangePicker(),
          ),
        );
      },
    );
  }
}
