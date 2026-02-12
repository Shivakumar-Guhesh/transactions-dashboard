import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class SelectedRouteNotifier extends Notifier<AppRoute> {
  @override
  AppRoute build() => AppRoute.dashboard;

  void setRoute(AppRoute route) => state = route;
}

final selectedRouteProvider = NotifierProvider<SelectedRouteNotifier, AppRoute>(
  SelectedRouteNotifier.new,
);
