import 'package:flutter/material.dart';

import '../../theme/app_sizes.dart';

class SideBar extends StatelessWidget {
  final bool showBorder;
  const SideBar({super.key, this.showBorder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: showBorder
            ? Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.spaceLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle_sharp,
                  size: AppSizes.fontXXLarge,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: AppSizes.spaceLarge),
                Text(
                  "Dashboard",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
          _SidebarItem(icon: Icons.dashboard, label: 'Dashboard'),
          _SidebarItem(icon: Icons.dataset, label: 'Transactions'),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SidebarItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).hintColor),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
