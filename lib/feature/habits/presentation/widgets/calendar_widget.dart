import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/dialog/TutorialDialog.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        Border,
        BoxDecoration,
        BoxShape,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Container,
        EdgeInsets,
        FontWeight,
        Hero,
        Icon,
        IconButton,
        Icons,
        Key,
        Navigator,
        Positioned,
        SizedBox,
        Stack,
        StatelessWidget,
        Text,
        TextSpan,
        TextStyle,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/extensions/NavigatorExtension.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key? key, required this.completeHabit})
      : controller = GetIt.I.get<HabitDetailsController>(),
        super(key: key);

  final HabitDetailsController controller;
  final Function(bool add, DateTime date, DonePageType donePageType)
      completeHabit;

  void dayCalendarClick(DateTime date, List events, List holidays) {
    DateTime day = DateTime(date.year, date.month, date.day);
    bool add = events.length == 0;

    completeHabit(add, day, DonePageType.Calendar);
  }

  void calendarHelp(BuildContext context) {
    Navigator.of(context).smooth(TutorialDialog(
      hero: "helpCalendar",
      texts: [
        TextSpan(
          text: "  No calendário você tem o controle de todos os dias feitos!",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        TextSpan(
          text:
              "\n\nMantenha pressionado no dia desejado para marcar como feito ou desmarcar.",
        ),
      ],
    ));
  }

  Widget _todayDayBuilder(context, date, list) {
    return Container(
      child: Text(
        date.day.toString(),
      ),
      alignment: const Alignment(0.0, 0.0),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: controller.habitColor, width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return controller.calendarMonth.handleStateReloadable(
          () => Skeleton(
            width: double.maxFinite,
            height: 240,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          (data, loading) => Container(
            width: double.maxFinite,
            child: Stack(
              children: <Widget>[
                // TableCalendar(
                //   events: data,
                //   formatAnimation: FormatAnimation.slide,
                //   startingDayOfWeek: StartingDayOfWeek.sunday,
                //   availableGestures: AvailableGestures.horizontalSwipe,
                //   initialCalendarFormat: CalendarFormat.month,
                //   availableCalendarFormats: const {
                //     CalendarFormat.month: '',
                //   },
                //   onDaySelected: dayCalendarClick,
                //   onDayLongPressed: dayCalendarClick,
                //   onVisibleDaysChanged: controller.calendarMonthSwipe,
                //   daysOfWeekStyle: DaysOfWeekStyle(dowTextBuilder: (date, locale) {
                //     switch (date.weekday) {
                //       case 1:
                //         return "Seg";
                //       case 2:
                //         return "Ter";
                //       case 3:
                //         return "Qua";
                //       case 4:
                //         return "Qui";
                //       case 5:
                //         return "Sex";
                //       case 6:
                //         return "Sáb";
                //       case 7:
                //         return "Dom";
                //       default:
                //         return "";
                //     }
                //   }),
                //   endDay: DateTime.now().today,
                //   rowHeight: 40,
                //   headerStyle: HeaderStyle(
                //     formatButtonTextStyle: TextStyle().copyWith(fontSize: 15.0),
                //     formatButtonDecoration: BoxDecoration(
                //       color: controller.habitColor,
                //       borderRadius: BorderRadius.circular(16.0),
                //     ),
                //   ),
                //   builders: CalendarBuilders(
                //       markersBuilder: (context, date, event, list) {
                //         return [
                //           Container(
                //               child: Text(
                //                 date.day.toString(),
                //                 style: TextStyle(color: Colors.white),
                //               ),
                //               alignment: Alignment.center,
                //               margin:
                //                   EdgeInsets.only(top: 5, bottom: 5, left: event[0] ? 0 : 5, right: event[1] ? 0 : 5),
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.horizontal(
                //                     left: event[0] ? Radius.circular(0) : Radius.circular(20),
                //                     right: event[1] ? Radius.circular(0) : Radius.circular(20)),
                //                 color: controller.habitColor,
                //               ))
                //         ];
                //       },
                //       selectedDayBuilder: (context, date, list) {
                //         if (DateTime.now().difference(date) < Duration(days: 1)) {
                //           return _todayDayBuilder(context, date, list);
                //         } else {
                //           return Container(
                //             child: Text(
                //               date.day.toString(),
                //               style: TextStyle(color: date.weekday >= 6 ? Colors.red : Colors.black),
                //             ),
                //             alignment: Alignment(0.0, 0.0),
                //           );
                //         }
                //       },
                //       todayDayBuilder: _todayDayBuilder),
                // ),
                Positioned(
                    right: 40,
                    top: 8,
                    child: IconButton(
                        icon: Hero(
                            tag: "helpCalendar",
                            child: Icon(Icons.help_outline)),
                        iconSize: 20,
                        onPressed: () => calendarHelp(context))),
                loading
                    ? Positioned.fill(
                        child: Container(
                          color: AppTheme.of(context)
                              .materialTheme
                              .backgroundColor
                              .withOpacity(0.5),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
