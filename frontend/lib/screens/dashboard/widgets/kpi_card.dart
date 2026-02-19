import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/intl_constants.dart';
import '../../../models/kpi_metrics.dart';
import '../../../providers/kpi_providers.dart';
import '../../../schemas/transaction_schemas.dart';
import '../../../shared/widgets/small_copy_button.dart';
import '../../../theme/app_animations.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/app_theme.dart';

class KpiCard extends ConsumerWidget {
  final String title;
  final MetricFetcher fetcher;
  final TransactionsFiltersRequest filters;

  const KpiCard({
    super.key,
    required this.title,
    required this.fetcher,
    required this.filters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(
      kpiProvider((fetcher: fetcher, filters: filters)),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveWidth = (screenWidth * AppSizes.kpiCardWidthFactor).clamp(
      AppSizes.minKpiCardWidth,
      AppSizes.maxKpiCardWidth,
    );

    return Container(
      width: responsiveWidth,
      constraints: const BoxConstraints(minHeight: AppSizes.minKpiCardHeight),
      child: kpiAsync.when(
        data: (metrics) => _KpiCardContent(title: title, metrics: metrics),
        loading: () => const _KpiLoadingState(),
        error: (err, _) => _KpiErrorState(error: err.toString()),
      ),
    );
  }
}

class _KpiCardContent extends StatefulWidget {
  final String title;
  final KpiMetrics metrics;

  const _KpiCardContent({required this.title, required this.metrics});

  @override
  State<_KpiCardContent> createState() => _KpiCardContentState();
}

class _KpiCardContentState extends State<_KpiCardContent> {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isExpanded = false;

  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    super.dispose();
  }

  void _toggleBreakdown() {
    if (_isExpanded) {
      _hideBreakdown();
    } else {
      _showBreakdown();
    }
  }

  void _showBreakdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isExpanded = true);
  }

  void _hideBreakdown({bool notify = true}) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isExpanded = false;

      if (notify && mounted) {
        setState(() {});
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideBreakdown,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),

          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + AppSizes.spaceXXSmall),
              child: Material(
                elevation: AppSizes.elevationSmall,
                shadowColor: Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                color: Theme.of(context).colorScheme.surface,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.spaceMedium),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  ),
                  child: _BreakdownList(
                    metrics: widget.metrics,
                    format: (val) => compactSimpleCurrencyFormat.format(val),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTypography = theme.extension<AppTypography>();
    final semantic = theme.extension<SemanticColors>();

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: AppAnimations.durationFast,
          curve: AppAnimations.curveSpring,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: AppSizes.borderSmall,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title.toUpperCase(),
                      style: theme.textTheme.labelSmall,
                    ),
                    if (widget.metrics.breakdown != null)
                      _GhostIconButton(
                        icon: _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.more_horiz_rounded,
                        onPressed: _toggleBreakdown,
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _isHovered
                          ? currencyFormat.format(widget.metrics.current)
                          : compactSimpleCurrencyFormat.format(
                              widget.metrics.current,
                            ),
                      style: customTypography?.numberStyleLarge,
                    ),
                    if (_isHovered) ...[
                      const SizedBox(width: AppSizes.spaceXSmall),
                      SmallCopyButton(value: widget.metrics.current.toString()),
                    ],
                  ],
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ModernBadge(
                      value: widget.metrics.momPercentage,
                      label: "MoM",
                      semantic: semantic,
                    ),
                    _ModernBadge(
                      value: widget.metrics.yoyPercentage,
                      label: "YoY",
                      semantic: semantic,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernBadge extends StatelessWidget {
  final double value;
  final String label;
  final SemanticColors? semantic;
  const _ModernBadge({required this.value, required this.label, this.semantic});

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = isPositive
        ? (semantic?.success)
        : Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? semantic?.successContainer
            : Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "${isPositive ? '+' : ''}${value.toStringAsFixed(1)}% $label",
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

class _BreakdownList extends StatelessWidget {
  final KpiMetrics metrics;
  final String Function(double) format;
  const _BreakdownList({required this.metrics, required this.format});

  @override
  Widget build(BuildContext context) {
    final sortedEntries = metrics.breakdown!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sortedEntries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.key,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                  Text(
                    currencyFormat.format(e.value),
                    textAlign: TextAlign.right,
                    style: Theme.of(
                      context,
                    ).extension<AppTypography>()!.numberStyle,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GhostIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _GhostIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: AppSizes.iconMedium),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}

class _KpiLoadingState extends StatelessWidget {
  const _KpiLoadingState();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Theme.of(context).dividerColor),
    ),
    child: const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}

class _KpiErrorState extends StatelessWidget {
  final String error;
  const _KpiErrorState({required this.error});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Icon(Icons.error_outline, color: Colors.grey));
}
