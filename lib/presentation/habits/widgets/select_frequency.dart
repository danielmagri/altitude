import 'package:altitude/common/extensions/navigator_extension.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/dialog/tutorial_dialog.dart';
import 'package:altitude/domain/enums/frquency_type.dart';
import 'package:altitude/presentation/habits/dialogs/dayweek_dialog.dart';
import 'package:altitude/presentation/habits/dialogs/weekly_dialog.dart';
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
        CrossAxisAlignment,
        DecoratedBox,
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
        showDialog;

class SelectFrequency extends StatelessWidget {
  const SelectFrequency({
    required this.color,
    required this.currentFrequency,
    required this.selectFrequency,
    Key? key,
  }) : super(key: key);

  final Frequency? currentFrequency;
  final Color color;
  final Function(Frequency) selectFrequency;

  void showTutorial(BuildContext context) {
    Navigator.of(context).smooth(
      const TutorialDialog(
        hero: 'helpFrequency',
        texts: [
          TextSpan(
            text:
                '  Quais dias ou quantas vezes na semana você deseja fazer o hábito?',
          ),
          TextSpan(
            text: '\nSelecione qual opção achar melhor.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget frequencyCard(BuildContext context, FrequencyType type) {
    return Flexible(
      child: AspectRatio(
        aspectRatio: 1.3,
        child: GestureDetector(
          onTap: () {
            switch (type) {
              case FrequencyType.dayweek:
                showDialog(
                  context: context,
                  builder: (_) => DayweekDialog(
                    color: color,
                    frequency: currentFrequency is DayWeek
                        ? currentFrequency as DayWeek?
                        : null,
                  ),
                ).then((value) {
                  if (value is Frequency) selectFrequency(value);
                });
                break;
              case FrequencyType.weekly:
                showDialog(
                  context: context,
                  builder: (_) => WeeklyDialog(
                    color: color,
                    frequency: currentFrequency is Weekly
                        ? currentFrequency as Weekly?
                        : null,
                  ),
                ).then((value) {
                  if (value is Frequency) selectFrequency(value);
                });
                break;
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: currentFrequency?.frequencyType() == type
                  ? color
                  : AppTheme.of(context).disableHabitCreationCard,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(blurRadius: 5, color: Colors.black38)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  type.title!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    currentFrequency?.frequencyType() == type
                        ? currentFrequency!.frequencyText()
                        : type.exampleText!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: currentFrequency?.frequencyType() == type
                          ? FontWeight.normal
                          : FontWeight.w200,
                    ),
                  ),
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
          Row(
            children: [
              const Text(
                'Qual a frequência do hábito?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              IconButton(
                icon: const Hero(
                  tag: 'helpFrequency',
                  child: Icon(Icons.help_outline),
                ),
                onPressed: () => showTutorial(context),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              frequencyCard(context, FrequencyType.dayweek),
              const SizedBox(width: 16),
              frequencyCard(context, FrequencyType.weekly)
            ],
          ),
        ],
      ),
    );
  }
}
