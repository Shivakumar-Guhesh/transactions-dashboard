import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/desktop_layout.dart';
import '../screens/mobile_layout.dart';
import '../shared/responsive.dart';
import '../providers/theme_provider.dart';
import '../shared/widgets/responsive_wrapper.dart';
import 'widgets/side_bar.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: context.isDesktop
          ? null
          : AppBar(title: const Text('Dashboard'), elevation: 0),
      drawer: context.isDesktop
          ? null
          : const Drawer(child: SideBar(showBorder: false)),
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
