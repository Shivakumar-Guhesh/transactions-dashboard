import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/categories.dart' as data;

enum TransactionType { expense, income }

final selectedCategoriesStateNotifier =
    ChangeNotifierProvider((ref) => SelectedCategoriesState());

class SelectedCategoriesState extends ChangeNotifier {
  final List<String> expenseCategories = data.expenseCategories;

  final List<String> _selectedExpenseCategories = [...data.expenseCategories];

  final List<String> incomeCategories = data.incomeCategories;

  final List<String> _selectedIncomeCategories = [...data.incomeCategories];

  List<String> get selectedExpenses {
    return _selectedExpenseCategories;
  }

  List<String> get selectedIncomes {
    return _selectedIncomeCategories;
  }

  void addSelectedExpenseCategory(String category) {
    _selectedExpenseCategories.add(category);
    notifyListeners();
  }

  void addSelectedIncomeCategory(String category) {
    _selectedIncomeCategories.add(category);
    notifyListeners();
  }

  void removeSelectedExpenseCategory(String category) {
    _selectedExpenseCategories.remove(category);
    notifyListeners();
  }

  void removeSelectedIncomeCategory(String category) {
    _selectedIncomeCategories.remove(category);
    notifyListeners();
  }
}
