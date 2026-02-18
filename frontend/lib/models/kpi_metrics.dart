class KpiMetrics {
  final double current;
  final double previousMonth;
  final double previousYear;
  final double momPercentage;
  final double yoyPercentage;
  final Map<String, double>? breakdown;

  KpiMetrics({
    required this.current,
    required this.previousMonth,
    required this.previousYear,
    required this.momPercentage,
    required this.yoyPercentage,
    this.breakdown,
  });

  factory KpiMetrics.calculate({
    required dynamic currentRaw,
    required dynamic prevMonthRaw,
    required dynamic prevYearRaw,
  }) {
    double sum(dynamic value) {
      if (value is Map<String, double>) {
        return value.values.fold(0.0, (prev, element) => prev + element);
      }
      return (value as num?)?.toDouble() ?? 0.0;
    }

    final currentVal = sum(currentRaw);
    final prevMonthVal = sum(prevMonthRaw);
    final prevYearVal = sum(prevYearRaw);
    return KpiMetrics(
      current: currentVal,
      previousMonth: prevMonthVal,
      previousYear: prevYearVal,
      momPercentage: _calculateChange(currentVal, prevMonthVal),
      yoyPercentage: _calculateChange(currentVal, prevYearVal),

      breakdown: currentRaw is Map<String, double> ? currentRaw : null,
    );
  }

  static double _calculateChange(double current, double previous) {
    if (previous == 0) return 0.0;
    return ((current - previous) / previous) * 100;
  }
}
