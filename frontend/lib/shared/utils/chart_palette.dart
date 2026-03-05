import 'package:flutter/material.dart';

class ChartPalette {
  static const List<Color> _basePalette = [
    Color(0xFFEA4335),
    Color(0xFF4285F4),
    Color(0xFF34A853),
    Color(0xFF9334E6),
    Color(0xFFFBBC04),
    Color(0xFF12B5CB),
    Color(0xFFF06292),
    Color(0xFFFA7B17),
    Color(0xFF24C1E0),
    Color(0xFF81C995),
    Color(0xFFF28B82),
    Color(0xFF7BAAF7),
    Color(0xFFFDD663),
    Color(0xFFA142F4),
    Color(0xFF4ECB71),
    Color(0xFF202124),
    Color(0xFF80868B),
    Color(0xFFC48BFF),
    Color(0xFF27E1C1),
    Color(0xFFFF8A65),
  ];

  static final Map<String, Color> _labelColorMap = {};

  static Color getColorForLabel(String label) {
    if (_labelColorMap.containsKey(label)) {
      return _labelColorMap[label]!;
    }

    final index = _labelColorMap.length % _basePalette.length;
    final color = _basePalette[index];

    _labelColorMap[label] = color;
    return color;
  }

  static void resetPalette() => _labelColorMap.clear();
}
