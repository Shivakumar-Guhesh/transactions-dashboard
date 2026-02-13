import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/filter_panel_provider.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_animations.dart';

class FilterPanel extends ConsumerWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(isFilterPanelExpandedProvider);

    return AnimatedSize(
      duration: AppAnimations.durationMedium,
      curve: AppAnimations.fastOutSlowIn,
      child: Container(
        height: isVisible ? null : 0,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: isVisible
                  ? Theme.of(context).dividerColor
                  : Colors.transparent,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceMedium),
          child: Wrap(
            spacing: AppSizes.spaceSmall,
            runSpacing: AppSizes.spaceSmall,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                label: Text("Filter 1"),
                icon: Icon(Icons.calendar_month),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                label: Text("Filter 2"),
                icon: Icon(Icons.arrow_drop_down),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                label: Text("Filter 3"),
                icon: Icon(Icons.check_box),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
