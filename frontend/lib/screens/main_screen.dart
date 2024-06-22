import 'package:flutter/material.dart';
import 'package:frontend/widgets/chart_sections.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:frontend/widgets/top_bar.dart';

import '../widgets/kpi_metrics_section.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TopBar(),
            Expanded(
              flex: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: SideBar(),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        KpiMetricsSection(),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.amber),
                        //     //  Colors.blue
                        //   ),
                        // ),
                        ChartsSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
