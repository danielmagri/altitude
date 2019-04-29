import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/ui/widgets/ClipShadowPath.dart';
import 'package:table_calendar/table_calendar.dart';

class HeaderBackgroundClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 40);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, this.name, this.score}) : super(key: key);

  final String name;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipShadowPath(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/corrida.jpg'), fit: BoxFit.cover),
            ),
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.4)),
              ),
            ),
          ),
          clipper: HeaderBackgroundClip(),
          shadow: Shadow(blurRadius: 5, color: Colors.black.withOpacity(0.5)),
        ),
        Align(
          alignment: Alignment(-0.9, 0.9),
          child: Container(
            width: 100.0,
            height: 100.0,
            alignment: Alignment(0.0, 0.0),
            child: Text(
              "100%",
              style: TextStyle(fontSize: 20.0),
            ),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 250, 127, 114),
                boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))]),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.0),
          child: Text(
            name,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.75),
          child: Text(
            score.toString(),
            style: TextStyle(fontSize: 55.0, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment(-1.0, -0.7),
          child: BackButton(),
        ),
        Align(
          alignment: Alignment(0.98, -0.7),
          child: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
        )
      ],
    );
  }
}

class CoolDataWidget extends StatelessWidget {
  CoolDataWidget({Key key, this.initialDate, this.daysDone}) : super(key: key);

  final DateTime initialDate;
  final int daysDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.0),
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Informações Legais", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4)),
              Text(
                  "Começou em " +
                      initialDate.day.toString().padLeft(2, '0') +
                      "/" +
                      initialDate.month.toString().padLeft(2, '0') +
                      "/" +
                      initialDate.year.toString(),
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
              Text("Dias cumpridos: " + daysDone.toString(),
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  CalendarWidget({Key key, @required this.markedDays}) : super(key: key);

  final Map<DateTime, List> markedDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.0),
      child: Card(
        elevation: 3.0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              events: markedDays,
              formatAnimation: FormatAnimation.slide,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableGestures: AvailableGestures.horizontalSwipe,
              forcedCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                selectedColor: Colors.deepOrange[400],
                todayColor: Colors.deepOrange[200],
                markersPositionBottom: 15,
                markersMaxAmount: 1,
                markersColor: Colors.brown[700],
              ),
              builders: CalendarBuilders(markersBuilder: (context, date, list) {
                return Container(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    alignment: Alignment(0.0, 0.0),
                    margin: EdgeInsets.all(5.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ));
              }),
              headerStyle: HeaderStyle(
                formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.deepOrange[400],
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            )),
      ),
    );
  }
}

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage({Key key, this.habit, this.frequency, this.markedDays}) : super(key: key);

  final Habit habit;
  final dynamic frequency;
  final Map<DateTime, List> markedDays;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  String frequencyText() {
    if (widget.frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freq = widget.frequency;
      return (freq.monday == 1 ? "Segunda, " : "") +
          (freq.tuesday == 1 ? "Terça, " : "") +
          (freq.wednesday == 1 ? "Quarta, " : "") +
          (freq.thursday == 1 ? "Quinta, " : "") +
          (freq.friday == 1 ? "Sexta, " : "") +
          (freq.saturday == 1 ? "Sábado, " : "") +
          (freq.sunday == 1 ? "Domingo, " : "");
    } else if (widget.frequency.runtimeType == FreqWeekly) {
      FreqWeekly freq = widget.frequency;
      return freq.daysTime.toString() + " vezes por semana";
    } else if (widget.frequency.runtimeType == FreqRepeating) {
      FreqRepeating freq = widget.frequency;
      return freq.daysTime.toString() + " vezes em " + freq.daysCycle.toString() + " dias";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 180.0),
            child: ListView(
              padding: EdgeInsets.only(top: 35.0, bottom: 10.0),
              children: <Widget>[
                Text(
                  frequencyText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, color: Colors.black54),
                ),
                CoolDataWidget(
                  initialDate: widget.habit.initialDate != null ? widget.habit.initialDate : DateTime.now(),
                  daysDone: widget.habit.daysDone,
                ),
                CalendarWidget(markedDays: widget.markedDays,),
              ],
            ),
          ),
          Container(
            height: 220.0,
            width: double.maxFinite,
            child: HeaderWidget(
              name: widget.habit.habit,
              score: widget.habit.score,
            ),
          ),
        ],
      ),
    );
  }
}
