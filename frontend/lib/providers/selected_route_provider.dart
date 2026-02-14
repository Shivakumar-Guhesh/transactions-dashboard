import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_routes.dart';

class SelectedRouteNotifier extends Notifier<AppRoute> {
  @override
  AppRoute build() {
    return AppRoute.dashboard;
  }

  void setRoute(AppRoute route) {
    state = route;
  }
}

final selectedRouteProvider = NotifierProvider<SelectedRouteNotifier, AppRoute>(
  SelectedRouteNotifier.new,
);
