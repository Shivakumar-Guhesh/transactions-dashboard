import 'package:flutter_riverpod/flutter_riverpod.dart';

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
