import 'package:flutter/animation.dart';

class AppAnimations {
  // --- Durations ---
  static const Duration durationFast = Duration(milliseconds: 120); // Snappier
  static const Duration durationMedium = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // --- Premium Curves ---
  // easeOutExpo feels more "web-premium" than standard ease
  static const Curve curveMain = Curves.easeOutExpo;

  static const Curve curveSpring = Cubic(0.175, 0.885, 0.32, 1.1);
}
