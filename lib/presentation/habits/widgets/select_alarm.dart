import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/ReminderDay.dart';
import 'package:altitude/common/view/dialog/TutorialDialog.dart';
import 'package:altitude/presentation/habits/controllers/add_habit_controller.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        ColorScheme,
        Column,
        Container,
        EdgeInsets,
        FontWeight,
        Hero,
        Icon,
        IconButton,
        Icons,
        InkWell,
        Key,
        Navigator,
        Padding,
        Row,
        State,
        StatefulWidget,
        Text,
        TextSpan,
        TextStyle,
        Theme,
        Widget,
        showTimePicker;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:altitude/common/extensions/navigator_extension.dart';

class SelectAlarm extends StatefulWidget {
  const SelectAlarm({Key? key}) : super(key: key);

  @override
  _SelectAlarmState createState() => _SelectAlarmState();
}

class _SelectAlarmState extends State<SelectAlarm> {
  final AddHabitController controller = GetIt.I.get<AddHabitController>();

  void showTutorial() {
    Navigator.of(context).smooth(
      TutorialDialog(
        hero: 'helpAlarm',
        texts: const [
          TextSpan(
            text:
                '  Caso queira, nós podemos te lembrar na hora e nos dias que desejar. ',
          ),
          TextSpan(
            text: 'Escolha quais dias deseja ser avisado e o horário.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void reminderTimeClick(BuildContext context) {
    showTimePicker(
      initialTime: controller.reminderTime!,
      context: context,
      builder: (context, child) {
        return Theme(
          data: AppTheme.of(context).materialTheme.copyWith(
                accentColor: controller.habitColor,
                primaryColor: controller.habitColor,
                colorScheme: AppTheme.isDark(context)
                    ? ColorScheme.dark(primary: controller.habitColor)
                    : ColorScheme.light(primary: controller.habitColor),
              ),
          child: child!,
        );
      },
    ).then(controller.selectReminderTime);
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Deseja ser lembrado?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              IconButton(
                icon: const Hero(
                  tag: 'helpAlarm',
                  child: Icon(Icons.help_outline),
                ),
                onPressed: showTutorial,
              )
            ],
          ),
          Observer(
            builder: (_) => Row(
              children: controller.reminderWeekday
                  .map(
                    (item) => ReminderDay(
                      day: item.title,
                      state: item.state,
                      color: controller.habitColor,
                      onTap: () => controller.selectReminderDay(
                        item.id,
                        !item.state,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: InkWell(
              onTap: () => reminderTimeClick(context),
              child: Observer(
                builder: (_) => Text.rich(
                  TextSpan(
                    style:
                        const TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                    children: [
                      TextSpan(
                        text: controller.timeText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' hrs'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
