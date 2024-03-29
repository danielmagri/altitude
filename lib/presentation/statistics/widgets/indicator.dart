import 'package:altitude/presentation/statistics/models/habit_statistic_data.dart';
import 'package:flutter/material.dart'
    show
        Container,
        EdgeInsets,
        FontWeight,
        GestureDetector,
        Key,
        MainAxisSize,
        Padding,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;

class Indicator extends StatelessWidget {
  const Indicator({required this.data, Key? key, this.onClick})
      : super(key: key);

  final HabitStatisticData data;
  final Function(String?)? onClick;

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () => onClick!(data.id),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15,
              height: 15,
              color: data.habitColor,
            ),
            const SizedBox(width: 4),
            Text(
              data.habit!,
              style: TextStyle(
                fontWeight: data.selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
