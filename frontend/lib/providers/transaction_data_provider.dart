import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/api.dart';

import 'package:frontend/models/transaction_filters_in.dart';

enum TransactionType { expense, income }

/* ========================================================================== */
/*                                 Future Provider                            */
/* ========================================================================== */
final apiProvider = Provider((ref) => TransactionDashboardApi());

final incomeCategoriesProvider =
    FutureProvider((ref) => ref.read(apiProvider).getIncomeCategories());
final expenseCategoriesProvider =
    FutureProvider((ref) => ref.read(apiProvider).getExpenseCategories());

final netWorthProvider =
    // FutureProvider((ref) => ref.read(apiProvider).getNetWorth([], []));
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref
      .read(apiProvider)
      .getNetWorth(arg.excludeExpenses, arg.excludeIncomes);
});

final totalExpenseProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref
      .read(apiProvider)
      .getTotalExpense(arg.excludeExpenses, arg.excludeIncomes);
});

final totalIncomeProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref
      .read(apiProvider)
      .getTotalIncome(arg.excludeExpenses, arg.excludeIncomes);
});
/* ========================================================================== */
/*                     REPEAT FOR ALL INITIAL GET REQUESTS                    */
/* ========================================================================== */
final selectedCategoriesStateNotifier =
    ChangeNotifierProvider((ref) => SelectedCategoriesState());

class SelectedCategoriesState with ChangeNotifier {
  // final List<String> expenseCategories = data.expenseCategories;

  // final List<String> _selectedExpenseCategories = [...data.expenseCategories];
  final List<String> _deSelectedExpenseCategories = [];

  // final List<String> incomeCategories = data.incomeCategories;
  // final List<String> incomeCategories = incomeProvider;

  // List<String> _selectedIncomeCategories = [...data.incomeCategories];
  final List<String> _deSelectedIncomeCategories = [];

  List<String> get deSelectedExpenses {
    // return _selectedExpenseCategories;
    return _deSelectedExpenseCategories;
  }

  List<String> get deSelectedIncomes {
    return _deSelectedIncomeCategories;
  }

  void addDeSelectedExpenseCategory(String category) {
    _deSelectedExpenseCategories.add(category);
    // _selectedExpenseCategories.add(category);
    notifyListeners();
  }

  void addDeSelectedIncomeCategory(String category) async {
    _deSelectedIncomeCategories.add(category);
    // _selectedIncomeCategories = output;
    notifyListeners();
  }

  void removeDeSelectedExpenseCategory(String category) {
    _deSelectedExpenseCategories.remove(category);
    notifyListeners();
  }

  void removeDeSelectedIncomeCategory(String category) {
    _deSelectedIncomeCategories.remove(category);
    notifyListeners();
  }
}
