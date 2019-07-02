import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit/datas/dataHabitDetail.dart';

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 12),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(50), topRight: Radius.circular(50)),
                color: DataHabitDetail().getColor(),
                boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))]),
            child: Text("Dias feito",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          TableCalendar(
            events: DataHabitDetail().daysDone,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            availableGestures: AvailableGestures.horizontalSwipe,
            forcedCalendarFormat: CalendarFormat.month,
            rowHeight: 40,
            builders: CalendarBuilders(markersBuilder: (context, date, event, list) {
              return <Widget>[
                Container(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    alignment: Alignment(0.0, 0.0),
                    margin: EdgeInsets.only(top: 5, bottom: 5, left: event[0] ? 0 : 5, right: event[1] ? 0 : 5),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                          left: event[0] ? Radius.circular(0) : Radius.circular(20),
                          right: event[1] ? Radius.circular(0) : Radius.circular(20)),
                      color: DataHabitDetail().getColor(),
                    ))
              ];
            }, selectedDayBuilder: (context, date, list) {
              return Container(
                child: Text(
                  date.day.toString(),
                ),
                alignment: Alignment(0.0, 0.0),
              );
            }, todayDayBuilder: (context, date, list) {
              return Container(
                child: Text(
                  date.day.toString(),
                ),
                alignment: Alignment(0.0, 0.0),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, border: Border.all(color: DataHabitDetail().getColor(), width: 2)),
              );
            }),
            headerStyle: HeaderStyle(
              formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: DataHabitDetail().getColor(),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
