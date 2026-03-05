import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group_distribution.dart';
import '../schemas/transaction_schemas.dart';
import 'repository_provider.dart';

final groupDistributionProvider = FutureProvider.autoDispose
    .family<GroupDistribution, TransactionsFiltersRequest>((
      ref,
      filters,
    ) async {
      final repo = ref.watch(transactionRepositoryProvider);

      final Map<String, double> rawData = await repo.getCategoryExpenseSum(
        filters: filters,
      );

      return GroupDistribution.fromRawMap(rawData);
    });
