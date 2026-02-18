import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_provider.dart'; // <--- This was unused
import '../models/kpi_metrics.dart';
import '../schemas/transaction_schemas.dart';

typedef MetricFetcher =
    Future<dynamic> Function({required TransactionsFiltersRequest filters});

final kpiProvider = FutureProvider.autoDispose
    .family<
      KpiMetrics,
      ({MetricFetcher fetcher, TransactionsFiltersRequest filters})
    >((ref, arg) async {
      ref.watch(transactionRepositoryProvider);

      final fetcher = arg.fetcher;
      final currentFilters = arg.filters;

      final results = await Future.wait([
        fetcher(filters: currentFilters),
        fetcher(filters: currentFilters.lastMonth()),
        fetcher(filters: currentFilters.lastYear()),
      ]);

      return KpiMetrics.calculate(
        currentRaw: results[0],
        prevMonthRaw: results[1],
        prevYearRaw: results[2],
      );
    });
