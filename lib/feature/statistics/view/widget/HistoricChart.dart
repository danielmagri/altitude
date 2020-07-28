import 'package:altitude/feature/statistics/model/HistoricStatisticData.dart';
import 'package:flutter/material.dart'
    show
        AlignmentDirectional,
        Axis,
        BouncingScrollPhysics,
        Colors,
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
        Theme,
        Widget,
        required;

const double HISTORIC_CHART_HEIGHT = 200;

class HistoricChart extends StatelessWidget {
  HistoricChart({Key key, @required this.list})
      : maxDataValue = list.reduce((e1, e2) => e1.totalScore > e2.totalScore ? e1 : e2).totalScore,
        super(key: key);

  final List<HistoricStatisticData> list;
  final int maxDataValue;

  static const int linesCount = 6;

  List<Widget> lines() {
    List<Widget> lines;
    double space = (HISTORIC_CHART_HEIGHT - 30) / (linesCount - 1);

    lines = List.generate(
        linesCount,
        (i) => Container(
            height: 1, color: Colors.grey[300], margin: EdgeInsets.only(bottom: i == linesCount - 1 ? 0 : space - 1)));

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
            children: lines(),
          ),
          ListView.builder(
              itemCount: list.length,
              padding: const EdgeInsets.only(left: 8, right: 38),
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  HistoricBar(data: list[index], multiplier: (HISTORIC_CHART_HEIGHT - 50) / maxDataValue)),
        ],
      ),
    );
  }
}

class HistoricBar extends StatelessWidget {
  const HistoricBar({Key key, @required this.data, @required this.multiplier}) : super(key: key);

  final HistoricStatisticData data;
  final double multiplier;

  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        data.totalScore == 0
            ? const SizedBox()
            : Container(
                height: 16,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                color: Theme.of(context).canvasColor,
                child: Text(data.totalScore.toString(), textAlign: TextAlign.center)),
        data.totalScore == 0
            ? const SizedBox(width: 28)
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                margin: const EdgeInsets.only(top: 3),
                color: Theme.of(context).canvasColor,
                child: Column(
                    children: data.habitsMap.keys
                        .map((key) =>
                            Container(color: key.habitColor, height: multiplier * data.habitsMap[key], width: 20))
                        .toList())),
        SizedBox(
            height: 15, child: Text(data.monthText, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 11))),
        SizedBox(
            height: 15,
            child: Text(data.firstOfYear ? data.year.toString() : "",
                style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 11))),
      ],
    );
  }
}
