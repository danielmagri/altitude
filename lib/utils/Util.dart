import 'package:flutter/material.dart';
import 'package:habit/controllers/CompetitionsControl.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/model/Habit.dart';
import 'package:habit/model/Reminder.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/model/Frequency.dart';

abstract class Util {
  static void goDetailsPage(BuildContext context, int id, {bool pushReplacement = false}) async {
    Loading.showLoading(context);

    Habit data = await HabitsControl().getHabit(id);
    List<Reminder> reminders = await HabitsControl().getReminders(id);
    dynamic frequency = await HabitsControl().getFrequency(id);
    Map<DateTime, List> daysDone = await HabitsControl()
        .getDaysDone(id, startDate: getLastDayMonthBehind(DateTime.now()), endDate: DateTime.now());
    List<String> competitions = await CompetitionsControl().listCompetitionsIds(id);

    Loading.closeLoading(context);
    if (data != null && data.id != null && frequency != null && reminders != null) {
      DataHabitDetail().habit = data;
      DataHabitDetail().reminders = reminders;
      DataHabitDetail().frequency = frequency;
      DataHabitDetail().daysDone = daysDone;
      DataHabitDetail().competitions = competitions;

      if (pushReplacement) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return HabitDetailsPage();
        }));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) {
                  return HabitDetailsPage();
                },
                settings: RouteSettings(name: "Habit Details Page")));
      }
    }
  }

  static Future<dynamic> dialogNavigator(BuildContext context, dynamic dialog) async {
    return Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) =>
            new FadeTransition(
                opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
                child: child),
        pageBuilder: (BuildContext context, _, __) {
          return dialog;
        }));
  }

  /// Coleta a quatidade de dias a ser feito dentro de um ciclo.
  static int getTimesDays(dynamic frequency) {
    if (frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freqDayWeek = frequency;
      int sumDays = 0;
      if (freqDayWeek.monday == 1) sumDays++;
      if (freqDayWeek.tuesday == 1) sumDays++;
      if (freqDayWeek.wednesday == 1) sumDays++;
      if (freqDayWeek.thursday == 1) sumDays++;
      if (freqDayWeek.friday == 1) sumDays++;
      if (freqDayWeek.saturday == 1) sumDays++;
      if (freqDayWeek.sunday == 1) sumDays++;

      return sumDays;
    } else if (frequency.runtimeType == FreqWeekly) {
      FreqWeekly freqWeekly = frequency;

      return freqWeekly.daysTime;
    } else {
      return 0;
    }
  }

  /// Coleta o tamanho do ciclo em dias.
  static int getDaysCycle(dynamic frequency) {
    return 7;
  }

  /// Clareia a cor de acordo com o 'value' de 0 a 255
  static Color setWhitening(Color color, int value) {
    int r = color.red + value;
    int g = color.green + value;
    int b = color.blue + value;

    if (r > 255)
      r = 255;
    else if (r < 0) r = 0;
    if (g > 255)
      g = 255;
    else if (g < 0) g = 0;
    if (b > 255)
      b = 255;
    else if (b < 0) b = 0;

    return Color.fromARGB(color.alpha, r, g, b);
  }

  /// Retorna o ultimo dia do mês anterior
  static DateTime getLastDayMonthBehind(DateTime date) {
    return new DateTime(DateTime.now().year, DateTime.now().month, 1).subtract(Duration(days: 2));
  }
}
