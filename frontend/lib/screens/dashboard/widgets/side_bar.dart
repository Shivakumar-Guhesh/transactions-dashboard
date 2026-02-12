import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_routes.dart';
import '../../../providers/sidebar_provider.dart';
import '../../../theme/app_sizes.dart';
import '../../../shared/responsive.dart';

import 'nav_tile.dart';

class SideBar extends ConsumerWidget {
  final bool showBorder;
  const SideBar({super.key, this.showBorder = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = context.isMobile
        ? true
        : ref.watch(isSidebarExpandedProvider);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceSmall),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: showBorder && !context.isMobile
            ? Border(right: BorderSide(color: theme.colorScheme.outline))
            : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, isExpanded, theme),
            Divider(
              height: AppSizes.spaceXXXSmall,
              thickness: AppSizes.borderSmall,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSizes.spaceMedium),

            ...AppRoute.values.map(
              (route) => NavTile(route: route, isExpanded: isExpanded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool isExpanded,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceSmall),
      child: isExpanded
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: AppSizes.spaceXSmall),
                    Icon(
                      Icons.shield_outlined,
                      color: theme.colorScheme.primary,
                      size: AppSizes.iconLarge,
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Text("Tran Dash", style: theme.textTheme.headlineSmall),
                  ],
                ),
                if (!context.isMobile)
                  IconButton(
                    onPressed: () => ref
                        .read(isSidebarExpandedProvider.notifier)
                        .toggleSideBar(),
                    icon: const Icon(Icons.menu),
                  ),
              ],
            )
          : Column(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: theme.colorScheme.primary,
                  size: AppSizes.iconLarge,
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                if (!context.isMobile)
                  IconButton(
                    onPressed: () => ref
                        .read(isSidebarExpandedProvider.notifier)
                        .toggleSideBar(),
                    icon: const Icon(Icons.menu_outlined),
                  ),
              ],
            ),
    );
  }
}
