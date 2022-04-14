import 'package:altitude/common/enums/done_page_type.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/extensions/navigator_extension.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/view/dialog/tutorial_dialog.dart';
import 'package:altitude/common/view/generic/skeleton.dart';
import 'package:altitude/presentation/habits/controllers/habit_details_controller.dart';
import 'package:flutter/material.dart'
    show
        Alignment,
        Border,
        BorderRadius,
        BoxDecoration,
        BoxShape,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Colors,
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
        Radius,
        SizedBox,
        Stack,
        StatelessWidget,
        Text,
        TextSpan,
        TextStyle,
        Widget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart' show ObservableMap;
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({required this.completeHabit, Key? key})
      : controller = GetIt.I.get<HabitDetailsController>(),
        super(key: key) {
    _focusedDay = DateTime.now();
  }

  final HabitDetailsController controller;
  final Function(bool add, DateTime date, DonePageType donePageType)
      completeHabit;

  static DateTime _focusedDay = DateTime.now();

  void dayCalendarClick(DateTime selectedDay, DateTime focusedDay) {
    bool add = controller.calendarMonth.data?[selectedDay]?.isEmpty ?? true;

    completeHabit(add, selectedDay, DonePageType.calendar);
  }

  void calendarHelp(BuildContext context) {
    Navigator.of(context).smooth(
      const TutorialDialog(
        hero: 'helpCalendar',
        texts: [
          TextSpan(
            text:
                '  No calendário você tem o controle de todos os dias feitos!',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          TextSpan(
            text:
                '\n\nMantenha pressionado no dia desejado para marcar como feito ou desmarcar.',
          ),
        ],
      ),
    );
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
        border: Border.all(color: controller.habitColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return controller.calendarMonth.handleStateLoadableWithData(
          loading: (data) => data == null
              ? const Skeleton(
                  width: double.maxFinite,
                  height: 240,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                )
              : _calendar(data, true, context),
          success: (data) => _calendar(data, false, context),
        );
      },
    );
  }

  Widget _calendar(
    ObservableMap<DateTime, List<bool>> data,
    bool loading,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.maxFinite,
      child: Stack(
        children: <Widget>[
          TableCalendar<bool>(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime.now().onlyDate,
            eventLoader: (day) {
              return data[day] ?? <bool>[];
            },
            availableGestures: AvailableGestures.horizontalSwipe,
            availableCalendarFormats: const {
              CalendarFormat.month: '',
            },
            onDaySelected: dayCalendarClick,
            onDayLongPressed: dayCalendarClick,
            onPageChanged: (focusedDate) {
              _focusedDay = focusedDate;
              controller.calendarMonthSwipe(focusedDate);
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) {
                switch (date.weekday) {
                  case 1:
                    return 'Seg';
                  case 2:
                    return 'Ter';
                  case 3:
                    return 'Qua';
                  case 4:
                    return 'Qui';
                  case 5:
                    return 'Sex';
                  case 6:
                    return 'Sáb';
                  case 7:
                    return 'Dom';
                  default:
                    return '';
                }
              },
            ),
            rowHeight: 40,
            headerStyle: HeaderStyle(
              formatButtonTextStyle: const TextStyle().copyWith(fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: controller.habitColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            calendarBuilders: CalendarBuilders<bool>(
              markerBuilder: (context, date, event) {
                return event.isNotEmpty
                    ? Container(
                        child: Text(
                          date.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: event[0] ? 0 : 5,
                          right: event[1] ? 0 : 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            left: event[0]
                                ? const Radius.circular(0)
                                : const Radius.circular(20),
                            right: event[1]
                                ? const Radius.circular(0)
                                : const Radius.circular(20),
                          ),
                          color: controller.habitColor,
                        ),
                      )
                    : null;
              },
              selectedBuilder: (context, date, list) {
                if (DateTime.now().difference(date) < const Duration(days: 1)) {
                  return _todayDayBuilder(context, date, list);
                } else {
                  return Container(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: date.weekday >= 6 ? Colors.red : Colors.black,
                      ),
                    ),
                    alignment: const Alignment(0.0, 0.0),
                  );
                }
              },
              todayBuilder: _todayDayBuilder,
            ),
          ),
          Positioned(
            right: 40,
            top: 8,
            child: IconButton(
              icon: const Hero(
                tag: 'helpCalendar',
                child: Icon(Icons.help_outline),
              ),
              iconSize: 20,
              onPressed: () => calendarHelp(context),
            ),
          ),
          loading
              ? Positioned.fill(
                  child: Container(
                    color: AppTheme.of(context)
                        .materialTheme
                        .backgroundColor
                        .withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
