import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/app_animations.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_theme.dart';

class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmer = theme.extension<ShimmerTheme>()!;

    return Shimmer.fromColors(
      period: AppAnimations.durationShimmer,
      baseColor: shimmer.base,
      highlightColor: shimmer.highlight,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceMedium),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: AppSizes.borderSmall,
          ),
        ),
      ),
    );
  }
}
