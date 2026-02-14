class TransactionsFiltersRequest {
  final List<String> excludeExpenses;
  final List<String> excludeIncomes;
  final DateTime? startDate;
  final DateTime? endDate;

  TransactionsFiltersRequest({
    this.excludeExpenses = const [],
    this.excludeIncomes = const [],
    this.startDate,
    this.endDate,
  });

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return "$year$month$day";
  }

  Map<String, dynamic> toJson() {
    return {
      'exclude_expenses': excludeExpenses,
      'exclude_incomes': excludeIncomes,

      'start_date': _formatDate(startDate ?? DateTime(1)),
      'end_date': _formatDate(endDate ?? DateTime.now()),
    };
  }
}

class TransactionsDataResponse {
  final int transactionFactId;
  final int userId;
  final DateTime transactionDate;
  final String transaction;
  final String category;
  final String transactionType;
  final double amount;
  final String transactionMode;
  final String currency;
  final DateTime insrtTs;
  final String insrtUser;

  TransactionsDataResponse({
    required this.transactionFactId,
    required this.userId,
    required this.transactionDate,
    required this.transaction,
    required this.category,
    required this.transactionType,
    required this.amount,
    required this.transactionMode,
    required this.currency,
    required this.insrtTs,
    required this.insrtUser,
  });

  factory TransactionsDataResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsDataResponse(
      transactionFactId: json['transaction_fact_id'] as int,
      userId: json['user_id'] as int,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      transaction: json['transaction'] as String,
      category: json['category'] as String,
      transactionType: json['transaction_type'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionMode: json['transaction_mode'] as String,
      currency: json['currency'] as String,
      insrtTs: DateTime.parse(json['insrt_ts'] as String),
      insrtUser: json['insrt_user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_fact_id': transactionFactId,
      'user_id': userId,
      'transaction_date': transactionDate.toIso8601String().split('T')[0],
      'transaction': transaction,
      'category': category,
      'transaction_type': transactionType,
      'amount': amount,
      'transaction_mode': transactionMode,
      'currency': currency,
      'insrt_ts': insrtTs.toIso8601String(),
      'insrt_user': insrtUser,
    };
  }
}

class TransactionsDistinctValuesListResponse {
  final List<String> values;

  TransactionsDistinctValuesListResponse({required this.values});

  factory TransactionsDistinctValuesListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionsDistinctValuesListResponse(
      values: List<String>.from(json['values'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {'values': values};
}

class TransactionsTotalAmountResponse {
  final double total;

  TransactionsTotalAmountResponse({required this.total});

  factory TransactionsTotalAmountResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsTotalAmountResponse(
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'total': total};
}

class TransactionsGroupAmountResponse {
  final Map<String, double> groupAmount;

  TransactionsGroupAmountResponse({required this.groupAmount});

  factory TransactionsGroupAmountResponse.fromJson(Map<String, dynamic> json) {
    final rawMap = json['group_amount'] as Map<String, dynamic>;
    return TransactionsGroupAmountResponse(
      groupAmount: rawMap.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {'group_amount': groupAmount};
}
