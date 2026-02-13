import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/selected_route_provider.dart';
import '../constants/app_routes.dart';

class SidebarExpandedNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggleSideBar() {
    state = !state;
  }
}

final isSidebarExpandedProvider =
    NotifierProvider<SidebarExpandedNotifier, bool>(
      SidebarExpandedNotifier.new,
    );

final selectedRouteProvider = NotifierProvider<SelectedRouteNotifier, AppRoute>(
  SelectedRouteNotifier.new,
);
