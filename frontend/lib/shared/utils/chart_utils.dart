import 'dart:math';

class ChartUtils {
  static double calculateInterval(double max) {
    if (max <= 0) return 10;

    double target = max / 5;
    double exponent = (log(target) / log(10)).floorToDouble();
    double fraction = target / pow(10, exponent);

    double niceFraction;
    if (fraction < 1.5) {
      niceFraction = 1.0;
    } else if (fraction < 3.0) {
      niceFraction = 2.0;
    } else if (fraction < 7.0) {
      niceFraction = 5.0;
    } else {
      niceFraction = 10.0;
    }

    return niceFraction * pow(10, exponent);
  }

  static double calculateMaxY(double absoluteMax) {
    final double rawMax = absoluteMax == 0 ? 100 : absoluteMax * 1.1;
    final double interval = calculateInterval(rawMax);
    return (rawMax / interval).ceil() * interval;
  }
}
