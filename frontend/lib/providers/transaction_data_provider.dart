import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/transactions_api_service.dart';
import '../models/transaction_filters_in.dart';

// enum TransactionType { expense, income }

final apiServiceProvider =
    Provider<TransactionApiService>((ref) => TransactionApiService());
/* ========================================================================== */
/*                                 Future Provider                            */
/* ========================================================================== */

final incomeCategoriesProvider =
    FutureProvider((ref) => ref.read(apiServiceProvider).getIncomeCategories());
final expenseCategoriesProvider = FutureProvider(
    (ref) => ref.read(apiServiceProvider).getExpenseCategories());

final netWorthProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getNetWorth(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);

final totalExpenseProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getTotalExpense(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);

final totalIncomeProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getTotalIncome(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);
final catExpenseSumProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getCatExpenseSum(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);
final catIncomeSumProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getCatIncomeSum(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);
final modeExpenseSumProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getModeExpenseSum(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);
final modeIncomeSumProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getModeIncomeSum(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);
final monthlyBalanceProvider = FutureProvider.family(
  (ref, TransactionsFiltersIn arg) {
    return ref.read(apiServiceProvider).getMonthlyBalance(
        arg.excludeExpenses, arg.excludeIncomes, arg.startDate, arg.endDate);
  },
);

/* ========================================================================== */
/*                     REPEAT FOR ALL INITIAL GET REQUESTS                    */
/* ========================================================================== */
// final selectedCategoriesStateNotifier =
//     ChangeNotifierProvider((ref) => SelectedCategoriesState());

// class SelectedCategoriesState with ChangeNotifier {
//   List<String> _deSelectedExpenseCategories = [];

//   List<String> _deSelectedIncomeCategories = [];

//   Future<void> fetchAndSetList() async {
//     final sharedPrefs = await SharedPreferences.getInstance();
//     final incomes = sharedPrefs.getStringList("incomes") ?? [];
//     final expenses = sharedPrefs.getStringList("expenses") ?? [];

//     _deSelectedExpenseCategories = expenses;
//     _deSelectedIncomeCategories = incomes;
//     notifyListeners();
//   }

//   List<String> get deSelectedExpenses {
//     return _deSelectedExpenseCategories;
//   }

//   List<String> get deSelectedIncomes {
//     return _deSelectedIncomeCategories;
//   }

//   savePreferencesToFile() async {
//     final sharedPrefs = await SharedPreferences.getInstance();
//     sharedPrefs.setStringList("expenses", _deSelectedExpenseCategories);
//     sharedPrefs.setStringList("incomes", _deSelectedIncomeCategories);
//     // notifyListeners();
//   }

//   clearPreferencesFromFile() async {
//     final sharedPrefs = await SharedPreferences.getInstance();
//     sharedPrefs.remove("expenses");
//     sharedPrefs.remove("incomes");

//     // notifyListeners();
//   }

//   void addDeSelectedExpenseCategory(String category) {
//     _deSelectedExpenseCategories.add(category);
//     notifyListeners();
//   }

//   void addDeSelectedIncomeCategory(String category) {
//     _deSelectedIncomeCategories.add(category);
//     // incomes = sharedPrefs.getStringList("incomes") ?? [];
//     // _selectedIncomeCategories = output;
//     notifyListeners();
//   }

//   void removeDeSelectedExpenseCategory(String category) {
//     _deSelectedExpenseCategories.remove(category);

//     notifyListeners();
//   }

//   void removeDeSelectedIncomeCategory(String category) {
//     _deSelectedIncomeCategories.remove(category);

//     notifyListeners();
//   }
// }
