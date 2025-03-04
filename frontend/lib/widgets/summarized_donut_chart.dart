import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/theme_provider.dart';
import '../utils/chart_colors.dart';
import '../utils/responsive.dart';

late List<Color> colors;

class SummarizedDonutChart extends ConsumerStatefulWidget {
  const SummarizedDonutChart({
    required this.sliceData,
    required this.baseRadius,
    required this.selectedRadius,
    required this.baseLabelFontSize,
    required this.selectedLabelFontSize,
    this.title = 'Pie Chart',
    super.key,
  });
  final List<Map<String, dynamic>> sliceData;
  final String title;
  final double baseRadius;
  final double selectedRadius;
  final double baseLabelFontSize;
  final double selectedLabelFontSize;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SummarizedDonutChartState();
}

class _SummarizedDonutChartState extends ConsumerState<SummarizedDonutChart> {
  int touchedIndex = -1;
  int touchedCategoryIndex = -1;

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 2, // change it to get decimal places
    symbol: '₹ ',
  );

  List<Map<String, dynamic>> setData(List<Map<String, dynamic>> data) {
    var otherCategories = {'category': 'Others', 'sum': 0};
    for (var i = 9; i < data.length; i++) {
      if (otherCategories['sum'] != null) {
        otherCategories['sum'] =
            (otherCategories['sum']! as num) + data[i]['sum'];
      }
    }

    data = data.sublist(0, 9);
    data.add(otherCategories);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final appThemeStateNotifierState = ref.watch(appThemeStateNotifier);
    var isDarkModeEnabled = appThemeStateNotifierState.getIsDarkModeEnabled();

    if (!isDarkModeEnabled) {
      colors = lightCategoricalPalette;
    } else {
      colors = darkCategoricalPalette;
    }
    var sliceData = setData(widget.sliceData);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // direction:
      //     Responsive.isSmallScreen(context) ? Axis.vertical : Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: Responsive.isSmallScreen(context) ? 5 : 10,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.indigo,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: 270,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(
                          () {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedCategoryIndex = -1;
                              return;
                            }
                            touchedCategoryIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          },
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    // centerSpaceRadius: 40,
                    centerSpaceRadius:
                        Responsive.isSmallScreen(context) ? 50 : 120,
                    sections: slices(sliceData),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: ListView.builder(
              itemCount: sliceData.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // border: touchedCategoryIndex == index ? Border.all() : Border,
                    color: touchedCategoryIndex == index
                        ? colors[index]
                        : Colors.transparent,
                  ),
                  height: 350 / sliceData.length,
                  // color: colors[index],
                  // padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors[index],
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        sliceData[index]['category'],
                        style: TextStyle(
                          color: touchedCategoryIndex == index
                              ? (colors[index].computeLuminance() < 0.5
                                  ? Colors.white
                                  : Colors.black)
                              : null,
                          fontWeight: (touchedCategoryIndex == index)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (touchedCategoryIndex == index)
                        const SizedBox(
                          width: 10,
                        ),
                      if (touchedCategoryIndex == index)
                        Text(
                          indianRupeesFormat.format(sliceData[index]['sum']),
                          style: TextStyle(
                              color: (colors[index].computeLuminance() < 0.5
                                  ? Colors.white
                                  : Colors.black),
                              fontWeight: (touchedCategoryIndex == index)
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> slices(List<Map<String, dynamic>> data) {
    List<PieChartSectionData> pieChartSlices = [];
    double totalAmount = 0;
    for (var element in data) {
      totalAmount += element['sum'];
    }
    for (var i = 0; i < data.length; i++) {
      final isTouched = i == touchedCategoryIndex;
      final fontSize =
          isTouched ? widget.selectedLabelFontSize : widget.baseLabelFontSize;
      final radius = isTouched ? widget.selectedRadius : widget.baseRadius;
      pieChartSlices.add(
        PieChartSectionData(
          color: colors[i],
          value: data[i]['sum'],
          title:
              "${((data[i]['sum'] / totalAmount) * 100).toStringAsFixed(2)} %",
          radius: radius,
          titleStyle: TextStyle(
            color: colors[i].computeLuminance() < 0.5
                ? Colors.white
                : Colors.black,
            fontSize: fontSize,
            // fontWeight: FontWeight.bold,
            // color: Colors.black,
          ),
        ),
      );
    }

    return pieChartSlices;
  }
}
