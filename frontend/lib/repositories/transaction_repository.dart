import 'package:dio/dio.dart';

import '../schemas/transaction_schemas.dart';
import '../shared/dio_error_interceptor.dart';
import '../shared/http_client.dart';
import '../constants/api_constants.dart';

class TransactionRepository {
  final Dio _http = AppHttp().client;

  /* ========================= HELPER FUNCTIONS START ========================= */
  Future<double> _fetchTotalAmount({
    required String endpoint,
    required TransactionsFiltersRequest filters,
  }) async {
    try {
      final response = await _http.post(endpoint, data: filters.toJson());
      return TransactionsTotalAmountResponse.fromJson(response.data).total;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<Map<String, double>> _fetchGroupedAmount({
    required String endpoint,
    required TransactionsFiltersRequest filters,
  }) async {
    try {
      final response = await _http.post(endpoint, data: filters.toJson());

      return TransactionsGroupAmountResponse.fromJson(
        response.data,
      ).groupAmount;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<List<String>> _fetchDistinctValues({required String endpoint}) async {
    try {
      final response = await _http.get(
        endpoint,
        data: TransactionsFiltersRequest().toJson(),
      );
      return TransactionsDistinctValuesListResponse.fromJson(
        response.data,
      ).values;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /* ========================== HELPER FUNCTIONS END ========================== */
  Future<List<TransactionsDataResponse>> getTransactionsData({
    required TransactionsFiltersRequest filters,
  }) async {
    try {
      final response = await _http.post(
        ApiConstants.transactionsData,
        data: filters.toJson(),
      );
      return (response.data as List)
          .map((item) => TransactionsDataResponse.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /* =========================== TOTAL AMOUNT STARTS ========================== */

  Future<double> getTotalExpense({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchTotalAmount(
      endpoint: ApiConstants.totalExpense,
      filters: filters,
    );
  }

  Future<double> getTotalIncome({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchTotalAmount(
      endpoint: ApiConstants.totalIncome,
      filters: filters,
    );
  }

  /* ============================ TOTAL AMOUNT ENDS =========================== */

  /* ============================ GROUP SUM STARTS ============================ */

  Future<Map<String, double>> getLiquidAssetWorth({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.liquidAssetWorth,
      filters: filters,
    );
  }

  Future<Map<String, double>> getTotalAssetWorth({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.totalAssetWorth,
      filters: filters,
    );
  }

  Future<Map<String, double>> getCategoryExpenseSum({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.catExpenseSum,
      filters: filters,
    );
  }

  Future<Map<String, double>> getCategoryIncomeSum({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.catIncomeSum,
      filters: filters,
    );
  }

  Future<Map<String, double>> getModeExpenseSum({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.modeExpenseSum,
      filters: filters,
    );
  }

  Future<Map<String, double>> getModeIncomeSum({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.modeIncomeSum,
      filters: filters,
    );
  }

  Future<Map<String, double>> getMonthExpenseSum({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.monthExpenseSum,
      filters: filters,
    );
  }

  Future<Map<String, double>> getMonthIncomeSum({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.monthIncomeSum,
      filters: filters,
    );
  }

  Future<Map<String, double>> getMonthlyBalance({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchGroupedAmount(
      endpoint: ApiConstants.monthlyBalance,
      filters: filters,
    );
  }

  /* ============================= GROUP SUM ENDS ============================= */

  /* ======================== DISTINCT VALUE LIST START ======================= */

  Future<List<String>> getExpenseCategories() async {
    return _fetchDistinctValues(endpoint: ApiConstants.expenseCategories);
  }

  Future<List<String>> getIncomeCategories() async {
    return _fetchDistinctValues(endpoint: ApiConstants.incomeCategories);
  }

  /* ======================== DISTINCT VALUE LIST ENDS ======================== */
}
