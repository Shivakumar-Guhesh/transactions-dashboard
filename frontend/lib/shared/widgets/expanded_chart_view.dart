import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_sizes.dart';
import '../responsive.dart';

mixin FullScreenChartMixin {
  void toggleFullScreen(BuildContext context, Widget chart) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, _, _) => _ExpandedChartOverlay(chart: chart),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _ExpandedChartOverlay extends StatelessWidget {
  final Widget chart;

  const _ExpandedChartOverlay({required this.chart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Center(
            child: Container(
              width: context.screenWidth * 0.95,
              height: context.screenHeight * 0.75,
              padding: const EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: AppSizes.borderSmall,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.1),
                    blurRadius: AppSizes.radiusLarge,
                    spreadRadius: AppSizes.radiusMedium,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_fullscreen_rounded),
                        tooltip: 'Exit Full Screen',
                      ),
                    ],
                  ),
                  Expanded(child: chart),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
