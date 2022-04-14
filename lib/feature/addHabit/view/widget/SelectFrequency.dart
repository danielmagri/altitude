import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/dialog/TutorialDialog.dart';
import 'package:altitude/feature/addHabit/enums/FrquencyType.dart';
import 'package:altitude/feature/addHabit/view/dialog/DayweekDialog.dart';
import 'package:altitude/feature/addHabit/view/dialog/WeeklyDialog.dart';
import 'package:flutter/material.dart'
    show
        AspectRatio,
        BorderRadius,
        BoxDecoration,
        BoxShadow,
        BuildContext,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Flexible,
        FontWeight,
        GestureDetector,
        Hero,
        Icon,
        IconButton,
        Icons,
        Key,
        MainAxisAlignment,
        Navigator,
        Padding,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        TextSpan,
        TextStyle,
        Widget,
        required,
        showDialog;
import 'package:altitude/core/extensions/NavigatorExtension.dart';

class SelectFrequency extends StatelessWidget {
  SelectFrequency({Key key, @required this.color, @required this.currentFrequency, @required this.selectFrequency})
      : super(key: key);

  final Frequency currentFrequency;
  final Color color;
  final Function(Frequency) selectFrequency;

  void showTutorial(BuildContext context) {
    Navigator.of(context).smooth(TutorialDialog(
      hero: "helpFrequency",
      texts: const [
        TextSpan(text: "  Quais dias ou quantas vezes na semana você deseja fazer o hábito?"),
        TextSpan(text: "\nSelecione qual opção achar melhor.", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ));
  }

  Widget frequencyCard(BuildContext context, FrequencyType type) {
    return Flexible(
      child: AspectRatio(
        aspectRatio: 1.3,
        child: GestureDetector(
          onTap: () {
            switch (type) {
              case FrequencyType.DAYWEEK:
                showDialog(
                    context: context,
                    builder: (_) => DayweekDialog(
                          color: color,
                          frequency: currentFrequency is DayWeek ? currentFrequency : null,
                        )).then((value) {
                  if (value is Frequency) selectFrequency(value);
                });
                break;
              case FrequencyType.WEEKLY:
                showDialog(
                    context: context,
                    builder: (_) => WeeklyDialog(
                          color: color,
                          frequency: currentFrequency is Weekly ? currentFrequency : null,
                        )).then((value) {
                  if (value is Frequency) selectFrequency(value);
                });
                break;
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: currentFrequency?.frequencyType() == type ? color : AppTheme.of(context).disableHabitCreationCard,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [const BoxShadow(blurRadius: 5, color: Colors.black38)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(type.title,
                    style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                      currentFrequency?.frequencyType() == type ? currentFrequency.frequencyText() : type.exampleText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: currentFrequency?.frequencyType() == type ? FontWeight.normal : FontWeight.w200)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text("Qual a frequência do hábito?",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            IconButton(
                icon: const Hero(tag: "helpFrequency", child: Icon(Icons.help_outline)),
                onPressed: () => showTutorial(context))
          ]),
          const SizedBox(height: 8),
          Row(children: [
            frequencyCard(context, FrequencyType.DAYWEEK),
            const SizedBox(width: 16),
            frequencyCard(context, FrequencyType.WEEKLY)
          ]),
        ],
      ),
    );
  }
}
