import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPanelVisibleProvider extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggleFilterPanel() {
    state = !state;
  }
}

final isFilterPanelExpandedProvider =
    NotifierProvider<FilterPanelVisibleProvider, bool>(
      FilterPanelVisibleProvider.new,
    );
