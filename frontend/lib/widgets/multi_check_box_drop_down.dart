import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/selected_categories_provider.dart';
import '../providers/transaction_data_provider.dart';

class MultiCheckBoxDropDown extends ConsumerStatefulWidget {
  const MultiCheckBoxDropDown({required this.type, super.key});

  final TransactionType type;
  @override
  ConsumerState<MultiCheckBoxDropDown> createState() =>
      _MultiCheckBoxDropDownState();
}

class _MultiCheckBoxDropDownState extends ConsumerState<MultiCheckBoxDropDown> {
  late List<String> categories;
  late List<String> deSelectedCategories;

  @override
  build(BuildContext context) {
    AsyncValue<List<String>> categoryData;
    if (widget.type == TransactionType.expense) {
      categoryData = ref.watch(expenseCategoriesProvider);
    } else {
      categoryData = ref.watch(incomeCategoriesProvider);
    }
    // final incomeCategoryData = ref.watch(incomeCategoriesProvider);
    // final expenseCategoryData = ref.watch(expenseCategoriesProvider);
    final selectedCategoriesState = ref.watch(selectedCategoriesStateNotifier);
    if (widget.type == TransactionType.expense) {
      // categories = selectedCategoriesState.expenseCategories;
      // deSelectedCategories = selectedCategoriesState.selectedExpenses;
      deSelectedCategories = selectedCategoriesState.deSelectedExpenses;
    } else {
      // categories = selectedCategoriesState.incomeCategories;
      // categories = (await incomeCategoryData.value) as List<String>;
      // print(categories);
      deSelectedCategories = selectedCategoriesState.deSelectedIncomes;
    }

    return categoryData.when(data: (data) {
      // categories = data;

      categories = data;
      // selectedCategories = data as List<String>;

      // selectedCategoriesState.setSelectedIncomeCategories(data);
      return Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                // TextButton(onPressed: () {}, child: Text("SELECT ALL")),
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
                      return deSelectedCategories
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
                                      value: !deSelectedCategories.contains(e),
                                      onChanged: (isSelected) {
                                        if (isSelected!) {
                                          setState(
                                            () {
                                              if (widget.type ==
                                                  TransactionType.expense) {
                                                selectedCategoriesState
                                                    .removeDeSelectedExpenseCategory(
                                                        e);
                                              } else {
                                                selectedCategoriesState
                                                    .removeDeSelectedIncomeCategory(
                                                        e);
                                                // selectedCategoriesState
                                                //     .addDeSelectedIncomeCategory(
                                                //         e);
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
                                                    .addDeSelectedExpenseCategory(
                                                        e);
                                              } else {
                                                // selectedCategoriesState
                                                //     .removeDeSelectedIncomeCategory(
                                                //         e);
                                                selectedCategoriesState
                                                    .addDeSelectedIncomeCategory(
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
    }, error: (error, stackTrace) {
      return Text(error.toString());
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    // return Center(
    //   child: Column(
    //     children: [
    //       Stack(
    //         alignment: Alignment.centerLeft,
    //         children: [
    //           SizedBox(
    //             width: 200,
    //             child: DropdownButtonFormField(
    //               borderRadius: BorderRadius.circular(10),
    //               value: null,
    //               focusColor: Colors.transparent,
    //               decoration: InputDecoration(
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(5),
    //                 ),
    //               ),
    //               selectedItemBuilder: (context) {
    //                 return selectedCategories
    //                     .map(
    //                       (e) => DropdownMenuItem(
    //                         child: Container(),
    //                       ),
    //                     )
    //                     .toList();
    //               },
    //               items: categories
    //                   .map(
    //                     (e) => DropdownMenuItem(
    //                       value: e,
    //                       child: SizedBox(
    //                         height: kMinInteractiveDimension,
    //                         child: StatefulBuilder(
    //                           builder: (context, setState) {
    //                             return SizedBox(
    //                               height: kMinInteractiveDimension,
    //                               child: CheckboxListTile(
    //                                 value: selectedCategories.contains(e),
    //                                 onChanged: (isSelected) {
    //                                   if (isSelected!) {
    //                                     setState(
    //                                       () {
    //                                         if (widget.type ==
    //                                             TransactionType.expense) {
    //                                           selectedCategoriesState
    //                                               .addSelectedExpenseCategory(
    //                                                   e);
    //                                         } else {
    //                                           selectedCategoriesState
    //                                               .addSelectedIncomeCategory(e);
    //                                         }
    //                                         // selectedCategories.add(e);
    //                                       },
    //                                     );
    //                                   } else {
    //                                     setState(
    //                                       () {
    //                                         if (widget.type ==
    //                                             TransactionType.expense) {
    //                                           selectedCategoriesState
    //                                               .removeSelectedExpenseCategory(
    //                                                   e);
    //                                         } else {
    //                                           selectedCategoriesState
    //                                               .removeSelectedIncomeCategory(
    //                                                   e);
    //                                         }
    //                                         // selectedCategories.remove(e);
    //                                       },
    //                                     );
    //                                   }
    //                                 },
    //                                 title: Text(e.toString()),
    //                               ),
    //                             );
    //                           },
    //                           // child:
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                   .toList(),
    //               onChanged: (i) => {},
    //             ),
    //           ),
    //           IgnorePointer(
    //             child: Container(
    //               padding: const EdgeInsets.symmetric(horizontal: 10),
    //               child: Text("Selected ${widget.type.name}s"),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
