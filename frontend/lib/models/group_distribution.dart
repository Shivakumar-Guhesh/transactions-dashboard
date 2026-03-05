import '../constants/chart_constants.dart';

class GroupSegment {
  final String name;
  final double amount;
  final double percentage;

  GroupSegment({
    required this.name,
    required this.amount,
    required this.percentage,
  });
}

class GroupDistribution {
  final List<GroupSegment> segments;
  final double totalAmount;

  GroupDistribution({required this.segments, required this.totalAmount});

  factory GroupDistribution.fromRawMap(
    Map<String, double> rawData, {
    int maxSegments = maxPieChartSlices,
  }) {
    final double total = rawData.values.fold(0, (sum, item) => sum + item);

    if (total == 0) {
      return GroupDistribution(segments: [], totalAmount: 0);
    }

    final sortedEntries = rawData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<GroupSegment> processedSegments = [];

    if (sortedEntries.length <= maxSegments) {
      processedSegments = sortedEntries
          .map((e) => _createSegment(e.key, e.value, total))
          .toList();
    } else {
      final topEntries = sortedEntries.take(maxSegments - 1);
      processedSegments = topEntries
          .map((e) => _createSegment(e.key, e.value, total))
          .toList();
      final othersSum = sortedEntries
          .skip(maxSegments - 1)
          .fold(0.0, (sum, entry) => sum + entry.value);

      if (othersSum > 0) {
        processedSegments.add(_createSegment("Others", othersSum, total));
      }
    }

    return GroupDistribution(segments: processedSegments, totalAmount: total);
  }

  static GroupSegment _createSegment(String name, double amount, double total) {
    return GroupSegment(
      name: name,
      amount: amount,
      percentage: (amount / total) * 100,
    );
  }
}
