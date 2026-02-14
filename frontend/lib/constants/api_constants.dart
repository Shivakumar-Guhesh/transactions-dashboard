class ApiConstants {
  static const String baseUrl = 'http://localhost:5000';

  /* ================================ ENDPOINTS =============================== */
  static const String expenseCategories = '/transactions/expense_categories';
  static const String incomeCategories = '/transactions/income_categories';

  static const String transactionsData = '/transactions/data';
  static const String totalExpense = '/transactions/total_expense';
  static const String totalIncome = '/transactions/total_income';
  static const String liquidAssetWorth = '/transactions/liquid_asset_worth';
  static const String totalAssetWorth = '/transactions/total_asset_worth';
  static const String catExpenseSum = '/transactions/cat_expense_sum';
  static const String catIncomeSum = '/transactions/cat_income_sum';
  static const String monthExpenseSum = '/transactions/month_expense_sum';
  static const String monthIncomeSum = '/transactions/month_income_sum';
  static const String modeExpenseSum = '/transactions/mode_expense_sum';
  static const String modeIncomeSum = '/transactions/mode_income_sum';
  static const String monthlyBalance = '/transactions/monthly_balance';

  /* ================================ timeouts ================================ */
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
