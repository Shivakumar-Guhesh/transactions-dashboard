import 'package:equatable/equatable.dart';

class TransactionsFiltersIn extends Equatable {
  final List<String> excludeExpenses;
  final List<String> excludeIncomes;

  const TransactionsFiltersIn(
      {required this.excludeExpenses, required this.excludeIncomes});

  @override
  List<Object> get props => [excludeExpenses, excludeIncomes];
}
