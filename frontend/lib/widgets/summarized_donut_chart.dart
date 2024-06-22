// import 'package:fl_chart_app/presentation/resources/app_resources.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
// import 'package:flutter/scheduler.dart';
import 'package:frontend/utils/chart_colors.dart';
import 'package:intl/intl.dart';

late List<Color> colors;

class SummarizedDonutChart extends ConsumerStatefulWidget {
  const SummarizedDonutChart(
      {required this.sliceData, this.title = 'Pie Chart', super.key});
  final List<Map<String, dynamic>> sliceData;
  final String title;
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
            (otherCategories['sum']! as double) + data[i]['sum'];
      }
    }

    data = data.sublist(0, 9);
    data.add(otherCategories);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final appThemeStateNotifierState = ref.read(appThemeStateNotifier);
    var isDarkModeEnabled = appThemeStateNotifierState.getIsDarkModeEnabled();

    if (!isDarkModeEnabled) {
      colors = lightCategoricalPalette;
    } else {
      colors = darkCategoricalPalette;
    }
    var sliceData = setData(widget.sliceData);
    return SizedBox(
      width: 650,
      height: 350,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 400,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(widget.title),
                PieChart(
                  PieChartData(
                    startDegreeOffset: 270,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedCategoryIndex = -1;
                            return;
                          }
                          touchedCategoryIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    // centerSpaceRadius: 40,
                    centerSpaceRadius: 120,
                    sections: slices(sliceData),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 450,
            width: 210,
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
                                : Theme.of(context).colorScheme.onBackground,
                            // : Colors.red,
                            fontWeight: (touchedCategoryIndex == index)
                                ? FontWeight.bold
                                : FontWeight.normal),
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
          // ),
        ],
      ),
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
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = isTouched ? 70.0 : 40.0;
      pieChartSlices.add(PieChartSectionData(
        color: colors[i],
        value: data[i]['sum'],
        // title: data[i]['category'],
        title: "${((data[i]['sum'] / totalAmount) * 100).toStringAsFixed(2)} %",
        radius: radius,
        titleStyle: TextStyle(
          color:
              colors[i].computeLuminance() < 0.5 ? Colors.white : Colors.black,
          fontSize: fontSize,
          // fontWeight: FontWeight.bold,
          // color: Colors.black,
        ),
      ));
    }

    return pieChartSlices;
  }
}
