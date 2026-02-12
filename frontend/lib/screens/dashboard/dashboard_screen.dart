import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/sidebar_provider.dart';
import '../../theme/app_sizes.dart';
import '../dashboard/desktop_layout.dart';
import '../dashboard/mobile_layout.dart';
import '../../shared/responsive.dart';
import '../../providers/theme_provider.dart';
import '../../shared/widgets/responsive_wrapper.dart';
import 'widgets/side_bar.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoute = ref.watch(selectedRouteProvider);
    return Scaffold(
      appBar: context.isMobile
          ? AppBar(
              title: Text(selectedRoute.label),
              elevation: AppSizes.elevationMin,
            )
          : null,
      drawer: context.isMobile
          ? const Drawer(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppSizes.radiusSmall),
                  bottomRight: Radius.circular(AppSizes.radiusSmall),
                ),
              ),
              child: SideBar(showBorder: false),
            )
          : null,
      body: SelectionArea(
        child: ResponsiveWrapper(
          mobile: const MobileLayout(),
          desktop: const DesktopLayout(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
        child: Icon(
          Theme.of(context).brightness == Brightness.dark
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
        ),
      ),
    );
  }
}
