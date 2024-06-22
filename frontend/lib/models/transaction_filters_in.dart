import 'package:equatable/equatable.dart';

class TransactionsFiltersIn extends Equatable {
  final List<String> excludeExpenses;
  final List<String> excludeIncomes;
  final DateTime startDate;
  final DateTime endDate;

  const TransactionsFiltersIn(
      {required this.excludeExpenses,
      required this.excludeIncomes,
      required this.startDate,
      required this.endDate});

  @override
  List<Object> get props =>
      [excludeExpenses, excludeIncomes, startDate, endDate];
}
