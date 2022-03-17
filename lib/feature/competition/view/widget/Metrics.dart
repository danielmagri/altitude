import 'package:altitude/common/theme/app_theme.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        Border,
        BorderSide,
        BoxDecoration,
        BuildContext,
        Column,
        Container,
        EdgeInsets,
        Key,
        MainAxisAlignment,
        StatelessWidget,
        Text,
        Widget;

class Metrics extends StatelessWidget {
  Metrics({Key? key, required this.height}) : super(key: key);

  final double height;

  List<Widget> _metricList(BuildContext context) {
    List<Widget> widgets = [];
    var km = (height / 10) - 6;

    widgets.insert(0, _metricWidget(context, "0", 60));

    var h = 5;
    while (h <= km) {
      if (h <= 100) {
        widgets.insert(0, _metricWidget(context, h.toString(), 50));
      } else if (h <= 240) {
        widgets.insert(0, _metricWidget(context, h.toString(), 100));
      } else {
        widgets.insert(0, _metricWidget(context, h.toString(), 200));
      }

      if (h < 100) {
        h += 5;
      } else if (h < 240) {
        h += 10;
      } else {
        h += 20;
      }
    }

    return widgets;
  }

  Widget _metricWidget(BuildContext context, String value, double height) {
    return Container(
      height: height,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: AppTheme.of(context).drawerIcon.withOpacity(0.5)))),
      child: Text(value),
    );
  }

  @override
  Widget build(context) {
    return Container(
      height: height,
      width: 50,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _metricList(context)),
    );
  }
}
