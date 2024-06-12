import 'package:flutter/material.dart';
import 'package:frontend/data/categories.dart';
import 'package:frontend/widgets/drop_down_multi_checkbox.dart';
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
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TopBarState();
  }
}

class _TopBarState extends ConsumerState<TopBar> {
  bool showFilters = false;
  _toggleFilter() {
    setState(() {
      showFilters = !showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateState = ref.watch(selectedDateStateNotifier);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
            // height: 100,
            // width: 1000,
            width: double.infinity,
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // // TextButton(
                // //   style: TextButton.styleFrom(
                // //     backgroundColor: Colors.grey[350],
                // //     shape: RoundedRectangleBorder(
                // //       borderRadius: BorderRadius.circular(8),
                // //     ),
                // //   ),
                // //   onPressed: () => showDialog<String>(
                // //     context: context,
                // //     builder: (BuildContext context) {
                // //       return Dialog(
                // // child:
                // DropDownMultiCheckbox(
                //     selectedList: const [], listOFStrings: excludeExpenses),
                // // );
                // // },
                // // ),
                // // child: Text("Expenses"),
                // // ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[350],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: DropDownMultiCheckbox(
                            selectedList: expenseCategories,
                            listOFStrings: expenseCategories),
                      );
                    },
                  ),
                  child: Text("Expenses"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[350],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: DropDownMultiCheckbox(
                            selectedList: const [],
                            listOFStrings: expenseCategories),
                      );
                    },
                  ),
                  child: Text("Incomes"),
                ),
                Checkbox(value: true, onChanged: (value) {}),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
