import 'package:altitude/feature/statistics/domain/models/habit_statistic_data.dart';
import 'package:fl_chart/fl_chart.dart'
    show FlBorderData, FlTapUpEvent, PieChart, PieChartData, PieChartSectionData, PieTouchData;
import 'package:flutter/material.dart'
    show Color, FontWeight, Key, StatelessWidget, TextStyle, Widget;

class PieChartScore extends StatelessWidget {
  PieChartScore({Key? key, required this.data, this.onClick}) : super(key: key);

  final List<HabitStatisticData> data;
  final Function(String?)? onClick;

  @override
  Widget build(context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (touchEvent, pieTouchResponse) {
            final index = pieTouchResponse?.touchedSection?.touchedSectionIndex;
            if (index != null && touchEvent is FlTapUpEvent) {
              onClick?.call(data[index].id);
            }
          },
          enabled: true,
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 5,
        centerSpaceRadius: 0,
        sections: data
            .map((e) => PieChartSectionData(
                color: e.habitColor,
                value: e.porcentage,
                title: e.porcentage < 5 ? '' : '${e.porcentage.round()}%',
                radius: e.selected ? 100 : 90,
                titleStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff))))
            .toList(),
      ),
    );
  }
}
