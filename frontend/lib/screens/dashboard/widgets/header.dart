import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/dashboard/widgets/profile_badge.dart';
import '../../../providers/sidebar_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../theme/app_sizes.dart';
import '../../../shared/responsive.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoute = ref.watch(selectedRouteProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Container(
      height: AppSizes.appBarHeight,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile
            ? AppSizes.spaceSmall
            : AppSizes.spaceLarge,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: AppSizes.borderSmall,
          ),
        ),
      ),
      child: Row(
        children: [
          if (context.isMobile) ...[
            _HeaderIconButton(
              icon: Icons.menu,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: AppSizes.spaceXSmall),
          ],
          Text(
            selectedRoute.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: isDark ? Icons.light_mode : Icons.dark_mode_outlined,
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          const SizedBox(width: AppSizes.spaceXSmall),
          const ProfileBadge(),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceXSmall),
        decoration: BoxDecoration(
          // color: _isHovered
          //     ? Theme.of(context).colorScheme.primary
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
