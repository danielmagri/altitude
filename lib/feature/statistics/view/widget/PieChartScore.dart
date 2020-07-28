import 'package:altitude/feature/statistics/model/HabitStatisticData.dart';
import 'package:fl_chart/fl_chart.dart' show FlBorderData, PieChart, PieChartData, PieChartSectionData, PieTouchData;
import 'package:flutter/material.dart' show Color, FontWeight, Key, StatelessWidget, TextStyle, Widget, required;

class PieChartScore extends StatelessWidget {
  PieChartScore({Key key, @required this.data, this.onClick}) : super(key: key);

  final List<HabitStatisticData> data;
  final Function(int) onClick;

  @override
  Widget build(context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
          if (pieTouchResponse.touchedSectionIndex != null) {
            onClick(data[pieTouchResponse.touchedSectionIndex].id);
          }
        }),
        borderData: FlBorderData(show: false),
        sectionsSpace: 5,
        centerSpaceRadius: 0,
        sections: data
            .map((e) => PieChartSectionData(
                color: e.habitColor,
                value: e.porcentage,
                title: e.porcentage < 5 ? '' : '${e.porcentage.toInt()}%',
                radius: e.selected ? 100 : 90,
                titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xffffffff))))
            .toList(),
      ),
    );
  }
}
