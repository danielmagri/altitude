import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:vibration/vibration.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key key, this.updateScreen, this.showSuggestionsDialog})
      : super(key: key);

  final Function updateScreen;
  final Function showSuggestionsDialog;

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController _calendarController;
  bool _editing = false;
  double _loadingOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime date, List events) {
    if (_editing) {
      setState(() {
        _loadingOpacity = 1.0;
      });

      DateTime day = new DateTime(date.year, date.month, date.day);
      bool add = events.length == 0 ? true : false;

      HabitsControl()
          .setHabitDoneAndScore(day, DataHabitDetail().habit.id,
              freq: DataHabitDetail().frequency, add: add)
          .then((earnedScore) {
        Vibration.hasVibrator().then((resp) {
          if (resp != null && resp == true) {
            Vibration.vibrate(duration: 100);
          }
        });

        DataHabitDetail().habit.score += earnedScore;
        if (add) {
          DataHabitDetail().habit.daysDone++;
        } else {
          DataHabitDetail().habit.daysDone--;
        }

        bool yesterday = DataHabitDetail()
            .daysDone
            .containsKey(day.subtract(Duration(days: 1)));
        bool tomorrow =
            DataHabitDetail().daysDone.containsKey(day.add(Duration(days: 1)));

        if (!add) {
          // Remover dia
          DataHabitDetail().daysDone.remove(day);
          if (yesterday) {
            DataHabitDetail().daysDone.update(
                day.subtract(Duration(days: 1)), (old) => [old[0], false]);
          }

          if (tomorrow) {
            DataHabitDetail()
                .daysDone
                .update(day.add(Duration(days: 1)), (old) => [false, old[1]]);
          }
        } else {
          // Adicionar dia
          DataHabitDetail()
              .daysDone
              .putIfAbsent(day, () => [yesterday, tomorrow]);
          if (yesterday) {
            DataHabitDetail().daysDone.update(
                day.subtract(Duration(days: 1)), (old) => [old[0], true]);
          }

          if (tomorrow) {
            DataHabitDetail()
                .daysDone
                .update(day.add(Duration(days: 1)), (old) => [true, old[1]]);
          }
        }
        _loadingOpacity = 0.0;
        widget.updateScreen();
      });
    }
  }

  void _onSwipeMonth(DateTime start, DateTime end, CalendarFormat format) {
    setState(() {
      _loadingOpacity = 1.0;
    });

    HabitsControl()
        .getDaysDone(DataHabitDetail().habit.id,
            startDate: start.subtract(Duration(days: 1)),
            endDate: end.add(Duration(days: 1)))
        .then((map) {
      setState(() {
        _loadingOpacity = 0.0;
        DataHabitDetail().daysDone = map;
      });
    });
  }

  Widget _todayDayBuilder(context, date, list) {
    return Container(
      child: Text(
        date.day.toString(),
      ),
      alignment: Alignment(0.0, 0.0),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: DataHabitDetail().getColor(), width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Stack(
        children: <Widget>[
          TableCalendar(
            calendarController: _calendarController,
            events: DataHabitDetail().daysDone,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            availableGestures: AvailableGestures.horizontalSwipe,
            initialCalendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: '',
            },
            onDaySelected: _onDaySelected,
            onVisibleDaysChanged: _onSwipeMonth,
            daysOfWeekStyle: DaysOfWeekStyle(dowTextBuilder: (date, locale) {
              switch (date.weekday) {
                case 1:
                  return "Seg";
                case 2:
                  return "Ter";
                case 3:
                  return "Qua";
                case 4:
                  return "Qui";
                case 5:
                  return "Sex";
                case 6:
                  return "Sáb";
                case 7:
                  return "Dom";
                default:
                  return "";
              }
            }),
            endDay: new DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .add(Duration(days: 1)),
            rowHeight: 40,
            headerStyle: HeaderStyle(
              formatButtonTextStyle: TextStyle().copyWith(fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: DataHabitDetail().getColor(),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            builders: CalendarBuilders(
                markersBuilder: (context, date, event, list) {
                  return <Widget>[
                    Container(
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: event[0] ? 0 : 5,
                            right: event[1] ? 0 : 5),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: event[0]
                                  ? Radius.circular(0)
                                  : Radius.circular(20),
                              right: event[1]
                                  ? Radius.circular(0)
                                  : Radius.circular(20)),
                          color: DataHabitDetail().getColor(),
                        ))
                  ];
                },
                selectedDayBuilder: (context, date, list) {
                  if (DateTime.now().difference(date) < Duration(days: 1)) {
                    return _todayDayBuilder(context, date, list);
                  } else {
                    return Container(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                            color:
                                date.weekday >= 6 ? Colors.red : Colors.black),
                      ),
                      alignment: Alignment(0.0, 0.0),
                    );
                  }
                },
                todayDayBuilder: _todayDayBuilder),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6, right: 52),
            alignment: Alignment.centerRight,
            child: FlatButton(
              color: _editing ? DataHabitDetail().getColor() : Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20)),
              onPressed: () {
                setState(() {
                  _editing = !_editing;
                });

                if (!_editing) {
                  widget.showSuggestionsDialog(suggestionsType.SET_ALARM);
                }
              },
              child: Text(
                _editing ? "Editando" : "Editar",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: _editing ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          _loadingOpacity < 0.05
              ? Container()
              : Positioned.fill(
                  child: Opacity(
                    opacity: _loadingOpacity,
                    child: Container(
                      color: Colors.white54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
