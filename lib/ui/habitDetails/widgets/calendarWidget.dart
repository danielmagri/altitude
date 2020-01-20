import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:habit/ui/widgets/generic/Skeleton.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit/datas/dataHabitDetail.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key, @required this.bloc, this.showSuggestionsDialog}) : super(key: key);

  final HabitDeatilsBloc bloc;
  final Function showSuggestionsDialog;

  void _onSwipeMonth(DateTime start, DateTime end, CalendarFormat format) {
    // HabitsControl()
    //     .getDaysDone(DataHabitDetail().habit.id,
    //         startDate: start.subtract(Duration(days: 1)), endDate: end.add(Duration(days: 1)))
    //     .then((map) {
    //   setState(() {

    //     DataHabitDetail().daysDone = map;
    //   });
    // });
  }

  Widget _todayDayBuilder(context, date, list) {
    return Container(
      child: Text(
        date.day.toString(),
      ),
      alignment: Alignment(0.0, 0.0),
      margin: EdgeInsets.all(5),
      decoration:
          BoxDecoration(shape: BoxShape.circle, border: Border.all(color: DataHabitDetail().getColor(), width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<DateTime, List>>(
      stream: bloc.daysDoneDataStream,
      builder: (BuildContext context, AsyncSnapshot<Map<DateTime, List>> snapshot) {
        if (!snapshot.hasData) {
          return Skeleton(
            width: double.maxFinite,
            height: 240,
            margin: EdgeInsets.symmetric(horizontal: 8),
          );
        } else {
          return Container(
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                TableCalendar(
                  calendarController: bloc.calendarController,
                  events: snapshot.data,
                  formatAnimation: FormatAnimation.slide,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  initialCalendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: '',
                  },
                  onDaySelected: bloc.dayCalendarClick,
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
                  endDay: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
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
                              margin:
                                  EdgeInsets.only(top: 5, bottom: 5, left: event[0] ? 0 : 5, right: event[1] ? 0 : 5),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    left: event[0] ? Radius.circular(0) : Radius.circular(20),
                                    right: event[1] ? Radius.circular(0) : Radius.circular(20)),
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
                              style: TextStyle(color: date.weekday >= 6 ? Colors.red : Colors.black),
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
                  child: StreamBuilder<bool>(
                    initialData: bloc.isEditingCalendar,
                    stream: bloc.editCalendarStream,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return FlatButton(
                        color: snapshot.data ? DataHabitDetail().getColor() : Colors.white,
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                        onPressed: bloc.editCalendarClick,
                        // onPressed: () {
                        //   setState(() {
                        //     _editing = !_editing;
                        //   });

                        //   if (!_editing) {
                        //     //widget.showSuggestionsDialog(suggestionsType.SET_ALARM);
                        //   }
                        // },
                        child: Text(
                          snapshot.data ? "Editando" : "Editar",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: snapshot.data ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                StreamBuilder<bool>(
                  initialData: false,
                  stream: bloc.loadingCalendarStream,
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.data) {
                      return Positioned.fill(
                        child: Container(
                          color: Colors.white54,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
