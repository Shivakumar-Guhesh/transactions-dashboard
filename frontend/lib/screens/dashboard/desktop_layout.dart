import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/sidebar_provider.dart';
import '../../theme/app_animations.dart';
import '../../theme/app_sizes.dart';
import 'widgets/main_content_area.dart';
import 'widgets/side_bar.dart';

class DesktopLayout extends ConsumerWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isSidebarExpandedProvider);

    final screenWidth = MediaQuery.of(context).size.width;

    final double expandedWidth = (screenWidth * AppSizes.sideBarWidthFactor)
        .clamp(AppSizes.minSideBarWidth, AppSizes.maxSideBarWidth);
    const double collapsedWidth = AppSizes.collapsedSideBarWidth;

    return Row(
      children: [
        AnimatedContainer(
          duration: AppAnimations.durationMedium,
          curve: AppAnimations.fastOutSlowIn,
          width: isExpanded ? expandedWidth : collapsedWidth,
          child: const SideBar(),
        ),
        const Expanded(child: const MainContentArea()),
      ],
    );
  }
}
