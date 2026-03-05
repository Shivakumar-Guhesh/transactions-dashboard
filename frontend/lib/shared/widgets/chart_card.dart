import 'package:flutter/material.dart';
import 'package:frontend/theme/app_sizes.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final Widget? legend;
  final VoidCallback? onExpand;

  const ChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.legend,
    this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (onExpand != null)
                  IconButton(
                    onPressed: onExpand,
                    icon: const Icon(Icons.fullscreen_rounded),
                    tooltip: "Expand Chart",
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceXXXSmall),
            Expanded(child: chart),
            if (legend != null) ...[
              const SizedBox(height: AppSizes.spaceSmall),
              legend!,
            ],
          ],
        ),
      ),
    );
  }
}
