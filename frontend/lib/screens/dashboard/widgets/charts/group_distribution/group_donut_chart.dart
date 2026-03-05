import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/intl_constants.dart';
import '../../../../../models/group_distribution.dart';
import '../../../../../shared/responsive.dart';
import '../../../../../shared/utils/chart_palette.dart';
import '../../../../../theme/app_animations.dart';
import '../../../../../theme/app_sizes.dart';

class GroupDonutChart extends StatefulWidget {
  final GroupDistribution data;

  const GroupDonutChart({super.key, required this.data});

  @override
  State<GroupDonutChart> createState() => _GroupDonutChartState();
}

class _GroupDonutChartState extends State<GroupDonutChart> {
  int touchedIndex = -1;
  final ScrollController _scrollController = ScrollController();

  void _scrollToIndex(int index) {
    if (index == -1 || !_scrollController.hasClients) return;

    const double itemHeight = AppSizes.inputHeight;
    final double viewportHeight = _scrollController.position.viewportDimension;
    final double targetOffset =
        (index * itemHeight) - (viewportHeight / 2) + (itemHeight / 2);

    _scrollController.animateTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: AppAnimations.durationMedium,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.data.segments
        .map((s) => ChartPalette.getColorForLabel(s.name))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Flex(
          direction: context.isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                        _scrollToIndex(touchedIndex);
                      });
                    },
                  ),
                  startDegreeOffset: 270,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0.5,
                  centerSpaceRadius: constraints.maxHeight * 0.35,
                  sections: _buildSections(palette),
                ),
                duration: AppAnimations.durationMedium,
                curve: AppAnimations.curveMain,
              ),
            ),
            const SizedBox(
              width: AppSizes.spaceMedium,
              height: AppSizes.spaceMedium,
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.data.segments.asMap().entries.map((entry) {
                    return MouseRegion(
                      onEnter: (_) => setState(() => touchedIndex = entry.key),
                      onExit: (_) => setState(() => touchedIndex = -1),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            touchedIndex = (touchedIndex == entry.key)
                                ? -1
                                : entry.key;
                          });
                        },
                        child: _LegendRow(
                          color: palette[entry.key],
                          segment: entry.value,
                          isHighlighted: touchedIndex == entry.key,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections(List<Color> palette) {
    return widget.data.segments.asMap().entries.map((entry) {
      final isTouched = entry.key == touchedIndex;
      final double radius = isTouched
          ? AppSizes.pieChartRadiusTouched
          : AppSizes.pieChartRadius;

      final color = palette[entry.key];

      return PieChartSectionData(
        color: color,
        value: entry.value.amount,
        title: '${entry.value.percentage.toStringAsFixed(0)}%',
        radius: radius,
        showTitle: true,
        titleStyle: TextStyle(
          fontSize: isTouched ? AppSizes.fontMedium : AppSizes.fontXSmall,
          fontWeight: FontWeight.bold,
          color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      );
    }).toList();
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final GroupSegment segment;
  final bool isHighlighted;

  const _LegendRow({
    required this.color,
    required this.segment,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isHighlighted
        ? (ThemeData.estimateBrightnessForColor(color) == Brightness.dark
              ? Colors.white
              : Colors.black)
        : Theme.of(context).textTheme.bodyMedium!.color!;

    return AnimatedContainer(
      duration: AppAnimations.durationFast,
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.spaceSmall,
        horizontal: AppSizes.spaceMedium,
      ),
      margin: const EdgeInsets.only(bottom: AppSizes.spaceXXSmall),
      decoration: BoxDecoration(
        color: isHighlighted ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: color,
                  blurRadius: AppSizes.borderXLarge,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.white : color,
              shape: BoxShape.circle,
              border: isHighlighted
                  ? null
                  : Border.all(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          const SizedBox(width: AppSizes.spaceMedium),
          Expanded(
            child: Text(
              segment.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlighted ? FontWeight.w900 : FontWeight.bold,
                color: textColor,
                fontSize: AppSizes.fontSmall,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isHighlighted)
            Text(
              currencyFormat.format(segment.amount),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: 0.5,
                fontSize: AppSizes.fontSmall,
              ),
            ),
        ],
      ),
    );
  }
}
