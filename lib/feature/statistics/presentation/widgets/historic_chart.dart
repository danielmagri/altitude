import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/feature/statistics/domain/models/historic_statistic_data.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart'
    show
        AlignmentDirectional,
        Axis,
        BouncingScrollPhysics,
        BuildContext,
        Column,
        Container,
        EdgeInsets,
        FontWeight,
        Key,
        ListView,
        MainAxisAlignment,
        MainAxisSize,
        SizedBox,
        Stack,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        Widget;

const double HISTORIC_CHART_HEIGHT = 200;

class HistoricChart extends StatelessWidget {
  HistoricChart({Key? key, required this.list, this.selectedHabitId})
      : maxDataValue = list
            .reduce((e1, e2) => e1.totalScore > e2.totalScore ? e1 : e2)
            .totalScore,
        super(key: key);

  final List<HistoricStatisticData> list;
  final String? selectedHabitId;
  final int maxDataValue;

  static const int linesCount = 6;

  List<Widget> lines(BuildContext context) {
    List<Widget> lines;
    double space = (HISTORIC_CHART_HEIGHT - 30) / (linesCount - 1);

    lines = List.generate(
        linesCount,
        (i) => Container(
            height: 1,
            color: AppTheme.of(context).statisticLine,
            margin:
                EdgeInsets.only(bottom: i == linesCount - 1 ? 0 : space - 1)));

    lines.add(const SizedBox(height: 29));

    return lines;
  }

  @override
  Widget build(context) {
    return Container(
      height: HISTORIC_CHART_HEIGHT,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: lines(context),
          ),
          ListView.builder(
              itemCount: list.length,
              padding: const EdgeInsets.only(left: 8, right: 38),
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => HistoricBar(
                  data: list[index],
                  multiplier: (HISTORIC_CHART_HEIGHT - 50) / maxDataValue,
                  selectedHabitId: selectedHabitId)),
        ],
      ),
    );
  }
}

class HistoricBar extends StatelessWidget {
  const HistoricBar(
      {Key? key,
      required this.data,
      required this.multiplier,
      this.selectedHabitId})
      : super(key: key);

  final HistoricStatisticData data;
  final double multiplier;
  final String? selectedHabitId;

  List<Widget> barWidget(BuildContext context) {
    List<Widget> list = [];

    if (data.totalScore == 0) {
      list.add(const SizedBox(width: 28));
    } else if (selectedHabitId == null) {
      list.add(Container(
          height: 16,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          color: AppTheme.of(context).materialTheme.backgroundColor,
          child:
              Text(data.totalScore.toString(), textAlign: TextAlign.center)));
      list.add(Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          margin: const EdgeInsets.only(top: 3),
          color: AppTheme.of(context).materialTheme.backgroundColor,
          child: Column(
              children: data.habitsMap.keys
                  .map((key) => Container(
                      color: key.color,
                      height: multiplier * data.habitsMap[key]!,
                      width: 20))
                  .toList())));
    } else {
      Habit? habit =
          data.habitsMap.keys.firstWhereOrNull((e) => e.id == selectedHabitId);

      if (habit != null) {
        int value = data.habitsMap[habit]!;

        list.add(Container(
            height: 16,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            color: AppTheme.of(context).materialTheme.backgroundColor,
            child: Text(value.toString(), textAlign: TextAlign.center)));
        list.add(Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            margin: const EdgeInsets.only(top: 3),
            color: AppTheme.of(context).materialTheme.backgroundColor,
            child: Container(
                color: habit.color, height: multiplier * value, width: 20)));
      } else {
        list.add(const SizedBox(width: 28));
      }
    }

    list.add(SizedBox(
        height: 15,
        child: Text(data.monthText,
            style:
                const TextStyle(fontWeight: FontWeight.w300, fontSize: 11))));
    list.add(SizedBox(
        height: 15,
        child: Text(data.firstOfYear ? data.year.toString() : "",
            style:
                const TextStyle(fontWeight: FontWeight.w300, fontSize: 11))));
    return list;
  }

  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: barWidget(context),
    );
  }
}
