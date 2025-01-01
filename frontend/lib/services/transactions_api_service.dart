import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TransactionApiService {
  static const _baseUrl = "localhost";
  static const _port = 5000;

  Uri getUrl(String endpoint) {
    return Uri.http(
      "$_baseUrl:$_port",
      "/$endpoint",
    );
  }

  Future<List<String>> getIncomeCategories() async {
    var response = await http.get(getUrl("income_categories"));
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;

      final List<String> result = (json.decode(body) as List).cast();
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw "from api.dart line 37";
    }
  }

  Future<List<String>> getExpenseCategories() async {
    var response = await http.get(getUrl("expense_categories"));
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;

      final List<String> result = (json.decode(body) as List).cast();
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  Future<Map<String, dynamic>> getNetWorth(
      List<String> deselectedExpenses,
      List<String> deselectedIncomes,
      DateTime startDate,
      DateTime endDate) async {
    var response = await http.post(
      getUrl("net_worth"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;

      final Map<String, dynamic> result = json.decode(body);
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  getTotalExpense(
    List<String> deselectedExpenses,
    List<String> deselectedIncomes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await http.post(
      getUrl("total_expense"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;
      // final List<String> result = (json.decode(body) as List<String>).cast();

      final double result = json.decode(body);
      // print("$startDate : $endDate");
      // print(result);
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  Future<double> getTotalIncome(
    List<String> deselectedExpenses,
    List<String> deselectedIncomes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await http.post(
      getUrl("total_income"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;
      // final List<String> result = (json.decode(body) as List<String>).cast();
      final double result = json.decode(body);
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  Future<List<Map<String, dynamic>>> getCatExpenseSum(
    List<String> deselectedExpenses,
    List<String> deselectedIncomes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await http.post(
      getUrl("cat_expense_sum"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;
      final List<Map<String, dynamic>> result =
          (json.decode(body) as List).cast();
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  Future<List<Map>> getCatIncomeSum(
    List<String> deselectedExpenses,
    List<String> deselectedIncomes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await http.post(
      getUrl("cat_income_sum"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;
      final List<Map> result = (json.decode(body) as List).cast();
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  Future<List<Map>> getModeExpenseSum(
    List<String> deselectedExpenses,
    List<String> deselectedIncomes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await http.post(
      getUrl("mode_expense_sum"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;
      final List<Map> result = (json.decode(body) as List).cast();
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  Future<List<Map>> getModeIncomeSum(
    List<String> deselectedExpenses,
    List<String> deselectedIncomes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await http.post(
      getUrl("mode_income_sum"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;
      final List<Map> result = (json.decode(body) as List).cast();
      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }

  getMonthlyBalance(
    List<String> deselectedExpenses,
    List<String> deselectedIncomes,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var response = await http.post(
      getUrl("monthly_balance"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exclude_expenses': deselectedExpenses,
        'exclude_incomes': deselectedIncomes,
        'start_date': DateFormat("yyyyMMdd").format(startDate),
        'end_date': DateFormat("yyyyMMdd").format(endDate)
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      final body = response.body;
      final List<Map> result = (json.decode(body) as List).cast();

      return result;
    } else if (response.statusCode == 400) {
      throw BadRequestException();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException();
    }
  }
}

sealed class APIException implements Exception {
  APIException(this.message);
  final String message;
}

class InvalidApiKeyException extends APIException {
  InvalidApiKeyException() : super('Invalid API key');
}

class NoInternetConnectionException extends APIException {
  NoInternetConnectionException() : super('No Internet connection');
}

class BadRequestException extends APIException {
  BadRequestException() : super('400 Bad Request');
}

class UnauthorizedException extends APIException {
  UnauthorizedException() : super('401 Unauthorized Exception');
}

class ForbiddenException extends APIException {
  ForbiddenException() : super('403 Forbidden Exception');
}

class NotFoundException extends APIException {
  NotFoundException() : super('403 Not Found Exception');
}

class UnknownException extends APIException {
  UnknownException() : super('Some error occurred');
}
