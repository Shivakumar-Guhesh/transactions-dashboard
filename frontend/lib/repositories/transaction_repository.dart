import 'package:dio/dio.dart';

import '../schemas/transaction_schemas.dart';
import '../shared/dio_error_interceptor.dart';
import '../shared/http_client.dart';
import '../constants/api_constants.dart';

class TransactionRepository {
  final Dio _http = AppHttp().client;

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
}
