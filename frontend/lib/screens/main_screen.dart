import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/responsive.dart';
import '../widgets/chart_sections.dart';
import '../widgets/side_bar.dart';
import '../widgets/top_bar.dart';
import '../widgets/kpi_metrics_section.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});
  @override
  build(BuildContext context, WidgetRef ref) {
    return SelectionArea(
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 5,
        //   title: const TopBar(),
        // ),
        // backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            const TopBar(),
            // const TestTextStyle(),
            Expanded(
              flex: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!Responsive.isSmallScreen(context))
                    const Expanded(
                      child: SideBar(),
                    ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: KpiMetricsSection(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.pink,
                                  ),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: const ChartsSection(),
                              ),
                            ),
                          ],
                        ),
                      ),
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

class TestTextStyle extends StatelessWidget {
  const TestTextStyle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          "This is a text string.",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
