import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/selected_route_provider.dart';

import '../../theme/app_sizes.dart';
import '../dashboard/desktop_layout.dart';
import '../dashboard/mobile_layout.dart';
import '../../shared/responsive.dart';
import '../../shared/widgets/responsive_wrapper.dart';
import 'widgets/side_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isMobile
          ? AppBar(
              toolbarHeight: 0,
              title: Consumer(
                builder: (context, ref, child) {
                  final selectedRoute = ref.watch(selectedRouteProvider);
                  return Text(selectedRoute.label);
                },
              ),
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
    );
  }
}
