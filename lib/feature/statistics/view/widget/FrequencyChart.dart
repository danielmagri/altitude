import 'dart:math' show min;
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/feature/statistics/model/FrequencyStatisticData.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart'
    show
        Alignment,
        AlignmentDirectional,
        Axis,
        BouncingScrollPhysics,
        BoxDecoration,
        BoxShape,
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
        TextStyle,
        Widget;

const double FREQUENCY_CHART_HEIGHT = 250;

class FrequencyChart extends StatelessWidget {
  FrequencyChart({Key? key, required this.list, this.selectedHabitId})
      : super(key: key);

  final List<FrequencyStatisticData>? list;
  final String? selectedHabitId;

  static const int linesCount = 8;
  static const List<String> weekday = const [
    "dom",
    "seg",
    "ter",
    "qua",
    "qui",
    "sex",
    "sáb"
  ];

  double get space => ((FREQUENCY_CHART_HEIGHT - 30) / (linesCount - 1) - 1);

  List<Widget> lines(BuildContext context) {
    List<Widget> lines;

    lines = List.generate(
        linesCount,
        (i) => Container(
            height: 1,
            color: AppTheme.of(context).statisticLine,
            margin: EdgeInsets.only(bottom: i == linesCount - 1 ? 0 : space)));

    lines.add(const SizedBox(height: 29));

    return lines;
  }

  @override
  Widget build(context) {
    return Container(
      height: FREQUENCY_CHART_HEIGHT,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: lines(context),
          ),
          ListView.builder(
              itemCount: list!.length,
              padding: const EdgeInsets.only(left: 8, right: 38),
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => FrequencyCircle(
                  data: list![index],
                  space: space,
                  selectedHabitId: selectedHabitId)),
          Container(
            color: AppTheme.of(context).materialTheme.backgroundColor,
            child: Column(
                children: weekday
                    .map((e) => Container(
                        height: space,
                        width: 30,
                        margin: const EdgeInsets.only(bottom: 1),
                        alignment: Alignment.center,
                        child: Text(e,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 11))))
                    .toList()),
          ),
        ],
      ),
    );
  }
}

class FrequencyCircle extends StatelessWidget {
  const FrequencyCircle(
      {Key? key, required this.data, required this.space, this.selectedHabitId})
      : super(key: key);

  final FrequencyStatisticData data;
  final double space;
  final String? selectedHabitId;

  List<Widget> _content(BuildContext context) {
    List<Widget> content = [];

    if (selectedHabitId == null) {
      data.weekdayDone.forEach((e) {
        double size = (space - 8) * min(e / 4, 1.1);
        int alpha = (255 * min(e / 4, 1)).toInt();
        content.add(Container(
            height: space,
            margin: const EdgeInsets.only(bottom: 1),
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.of(context).frequencyDot.withAlpha(alpha)),
            )));
      });
    } else {
      Habit? habit =
          data.habitsMap.keys.firstWhereOrNull((e) => e.id == selectedHabitId);
      if (habit != null) {
        data.habitsMap[habit]!.forEach((e) {
          double size = (space - 8) * min(e / 4, 1.1);
          int alpha = (255 * min(e / 4, 1)).toInt();
          content.add(Container(
              height: space,
              margin: const EdgeInsets.only(bottom: 1),
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: habit.color.withAlpha(alpha)),
              )));
        });
      }
    }

    content.add(SizedBox(
        height: 15,
        child: Text(data.monthText,
            style:
                const TextStyle(fontWeight: FontWeight.w300, fontSize: 11))));
    content.add(SizedBox(
        height: 15,
        child: Text(data.firstOfYear ? data.year.toString() : "",
            style:
                const TextStyle(fontWeight: FontWeight.w300, fontSize: 11))));

    return content;
  }

  @override
  Widget build(context) {
    return SizedBox(
        width: 28,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: _content(context),
        ));
  }
}
