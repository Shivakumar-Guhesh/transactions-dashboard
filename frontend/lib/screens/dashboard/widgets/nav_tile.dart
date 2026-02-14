import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_routes.dart';

import '../../../theme/app_animations.dart';
import '../../../theme/app_sizes.dart';
import '../../../providers/selected_route_provider.dart';

class NavTile extends ConsumerWidget {
  final AppRoute route;
  final bool isExpanded;

  const NavTile({super.key, required this.route, required this.isExpanded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoute = ref.watch(selectedRouteProvider);
    final bool isActive = selectedRoute == route;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXXSmall),
      child: InkWell(
        onTap: () {
          ref.read(selectedRouteProvider.notifier).setRoute(route);
          final scaffoldState = Scaffold.maybeOf(context);
          if (scaffoldState != null && scaffoldState.isDrawerOpen) {
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: AnimatedContainer(
          duration: AppAnimations.durationMedium,
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spaceSmall,
            horizontal: AppSizes.spaceSmall,
          ),
          decoration: BoxDecoration(
            color: isActive ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                route.icon,
                size: AppSizes.iconMedium,
                color: isActive ? theme.colorScheme.onPrimary : null,
              ),
              if (isExpanded) ...[
                const SizedBox(width: AppSizes.spaceMedium),
                Expanded(
                  child: Text(
                    route.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isActive ? theme.colorScheme.onPrimary : null,
                      fontWeight: isActive ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
