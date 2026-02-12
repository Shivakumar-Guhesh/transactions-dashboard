import 'package:flutter/material.dart';

enum AppRoute {
  dashboard('Dashboard', Icons.bar_chart_rounded),
  transactions('Transactions', Icons.table_view_outlined);

  final String label;
  final IconData icon;

  const AppRoute(this.label, this.icon);
}
