import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TransactionType { expense, income }

final selectedCategoriesStateNotifier =
    ChangeNotifierProvider((ref) => SelectedCategoriesState());

class SelectedCategoriesState with ChangeNotifier {
  List<String> _deSelectedExpenseCategories = [];

  List<String> _deSelectedIncomeCategories = [];

  Future<void> fetchAndSetList() async {
    // final sharedPrefs = await SharedPreferences.getInstance();
    final sharedPrefs = SharedPreferencesAsync();
    final incomes = await sharedPrefs.getStringList("incomes") ?? [];
    final expenses = await sharedPrefs.getStringList("expenses") ?? [];

    _deSelectedExpenseCategories = expenses;
    _deSelectedIncomeCategories = incomes;
    notifyListeners();
  }

  List<String> get deSelectedExpenses {
    return _deSelectedExpenseCategories;
  }

  List<String> get deSelectedIncomes {
    return _deSelectedIncomeCategories;
  }

  savePreferencesToFile() async {
    // final sharedPrefs = await SharedPreferences.getInstance();
    final sharedPrefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions());
    await sharedPrefs.setStringList("expenses", _deSelectedExpenseCategories);
    await sharedPrefs.setStringList("incomes", _deSelectedIncomeCategories);

    notifyListeners();
  }

  clearPreferencesFromFile() async {
    // final sharedPrefs = await SharedPreferences.getInstance();
    final sharedPrefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions());
    await sharedPrefs.remove("expenses");
    await sharedPrefs.remove("incomes");
    notifyListeners();
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
