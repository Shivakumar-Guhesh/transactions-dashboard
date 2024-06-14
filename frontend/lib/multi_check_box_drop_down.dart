import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/selected_categories_provider.dart';

class MultiCheckBoxDropDown extends ConsumerStatefulWidget {
  const MultiCheckBoxDropDown({required this.type, super.key});

  final TransactionType type;
  @override
  ConsumerState<MultiCheckBoxDropDown> createState() =>
      _MultiCheckBoxDropDownState();
}

class _MultiCheckBoxDropDownState extends ConsumerState<MultiCheckBoxDropDown> {
  late List<String> categories;
  late List<String> selectedCategories;

  @override
  Widget build(BuildContext context) {
    final selectedCategoriesState = ref.watch(selectedCategoriesStateNotifier);
    if (widget.type == TransactionType.expense) {
      categories = selectedCategoriesState.expenseCategories;
      selectedCategories = selectedCategoriesState.selectedExpenses;
    } else {
      categories = selectedCategoriesState.incomeCategories;
      selectedCategories = selectedCategoriesState.selectedIncomes;
    }
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              SizedBox(
                width: 200,
                child: DropdownButtonFormField(
                  borderRadius: BorderRadius.circular(10),
                  value: null,
                  focusColor: Colors.transparent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  selectedItemBuilder: (context) {
                    return selectedCategories
                        .map(
                          (e) => DropdownMenuItem(
                            child: Container(),
                          ),
                        )
                        .toList();
                  },
                  items: categories
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: SizedBox(
                            height: kMinInteractiveDimension,
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return SizedBox(
                                  height: kMinInteractiveDimension,
                                  child: CheckboxListTile(
                                    value: selectedCategories.contains(e),
                                    onChanged: (isSelected) {
                                      if (isSelected!) {
                                        setState(
                                          () {
                                            if (widget.type ==
                                                TransactionType.expense) {
                                              selectedCategoriesState
                                                  .addSelectedExpenseCategory(
                                                      e);
                                            } else {
                                              selectedCategoriesState
                                                  .addSelectedIncomeCategory(e);
                                            }
                                            // selectedCategories.add(e);
                                          },
                                        );
                                      } else {
                                        setState(
                                          () {
                                            if (widget.type ==
                                                TransactionType.expense) {
                                              selectedCategoriesState
                                                  .removeSelectedExpenseCategory(
                                                      e);
                                            } else {
                                              selectedCategoriesState
                                                  .removeSelectedIncomeCategory(
                                                      e);
                                            }
                                            // selectedCategories.remove(e);
                                          },
                                        );
                                      }
                                    },
                                    title: Text(e.toString()),
                                  ),
                                );
                              },
                              // child:
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (i) => {},
                ),
              ),
              IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Selected ${widget.type.name}s"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
