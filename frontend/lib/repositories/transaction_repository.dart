import 'package:dio/dio.dart';

import '../schemas/transaction_schemas.dart';
import '../shared/dio_error_interceptor.dart';
import '../shared/http_client.dart';
import '../constants/api_constants.dart';

class TransactionRepository {
  final Dio _http = AppHttp().client;

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

  Future<double> getLiquidAssetWorth({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchTotalAmount(
      endpoint: ApiConstants.liquidAssetWorth,
      filters: filters,
    );
  }

  Future<double> getTotalAssetWorth({
    required TransactionsFiltersRequest filters,
  }) async {
    return _fetchTotalAmount(
      endpoint: ApiConstants.totalAssetWorth,
      filters: filters,
    );
  }

  /* ============================ TOTAL AMOUNT ENDS =========================== */
}
