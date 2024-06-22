import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/api.dart';

import 'package:frontend/models/transaction_filters_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  return ref.read(apiProvider).getNetWorth(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});

final totalExpenseProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref.read(apiProvider).getTotalExpense(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});

final totalIncomeProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref.read(apiProvider).getTotalIncome(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});
final catExpenseSumProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref.read(apiProvider).getCatExpenseSum(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});
final catIncomeSumProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref.read(apiProvider).getCatIncomeSum(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});
final modeExpenseSumProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref.read(apiProvider).getModeExpenseSum(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});
final modeIncomeSumProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref.read(apiProvider).getModeIncomeSum(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});
final monthlyBalanceProvider =
    FutureProvider.family((ref, TransactionsFiltersIn arg) {
  return ref.read(apiProvider).getMonthlyBalance(
      arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
});

/* ========================================================================== */
/*                     REPEAT FOR ALL INITIAL GET REQUESTS                    */
/* ========================================================================== */
final selectedCategoriesStateNotifier =
    ChangeNotifierProvider((ref) => SelectedCategoriesState());

class SelectedCategoriesState with ChangeNotifier {
  // final List<String> expenseCategories = data.expenseCategories;

  // final List<String> _selectedExpenseCategories = [...data.expenseCategories];
  List<String> _deSelectedExpenseCategories = [];

  // final List<String> incomeCategories = data.incomeCategories;
  // final List<String> incomeCategories = incomeProvider;

  // List<String> _selectedIncomeCategories = [...data.incomeCategories];
  List<String> _deSelectedIncomeCategories = [];

  Future<void> fetchAndSetList() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final incomes = sharedPrefs.getStringList("incomes") ?? [];
    final expenses = sharedPrefs.getStringList("expenses") ?? [];
    // for (var category in incomes) {
    // addDeSelectedIncomeCategory(category);
    // }
    // for (var category in expenses) {
    // addDeSelectedExpenseCategory(category);
    // }
    _deSelectedExpenseCategories = expenses;
    _deSelectedIncomeCategories = incomes;
    notifyListeners();
  }

  List<String> get deSelectedExpenses {
    // return _selectedExpenseCategories;
    return _deSelectedExpenseCategories;
  }

  List<String> get deSelectedIncomes {
    return _deSelectedIncomeCategories;
  }

  savePreferencesToFile() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setStringList("expenses", _deSelectedExpenseCategories);
    sharedPrefs.setStringList("incomes", _deSelectedIncomeCategories);
    // notifyListeners();
  }

  clearPreferencesFromFile() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove("expenses");
    sharedPrefs.remove("incomes");

    // notifyListeners();
  }

  void addDeSelectedExpenseCategory(String category) {
    _deSelectedExpenseCategories.add(category);
    notifyListeners();
  }

  void addDeSelectedIncomeCategory(String category) {
    _deSelectedIncomeCategories.add(category);
    // incomes = sharedPrefs.getStringList("incomes") ?? [];
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
