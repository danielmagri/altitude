import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:habit/ui/editHabitPage.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/widgets/ClipShadowPath.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vibration/vibration.dart';

class HeaderBackgroundClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 20);
    path.quadraticBezierTo(size.width / 2, size.height - 45, size.width, size.height - 10);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget(
      {Key key,
      this.habit,
      this.frequency,
      this.fromAllHabits,
      this.score,
      this.previousScore,
      this.done,
      this.setDoneHabit,
      this.controller})
      : animation = IntTween(begin: previousScore, end: score)
            .animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
        super(key: key);

  final AnimationController controller;
  final Habit habit;
  final bool fromAllHabits;
  final dynamic frequency;
  final int score;
  final int previousScore;
  final bool done;
  final Function setDoneHabit;
  final Animation<int> animation;

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
          shadow: Shadow(blurRadius: 5, color: Colors.grey[500], offset: Offset(0.0, 1)),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 75.0,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  child: Align(alignment: Alignment(-1.0, 1.0), child: BackButton()),
                ),
                IconButton(icon: Icon(Icons.check), onPressed: done ? null : setDoneHabit),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return EditHabitPage(
                          habit: habit,
                          frequency: frequency,
                        );
                      }));
                    }),
              ]),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 90.0,
                    height: 90.0,
                    margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                    alignment: Alignment(0.0, 0.0),
                    child: Hero(
                      tag: fromAllHabits ? habit.id + 1000 : habit.id,
                      transitionOnUserGestures: true,
                      child: Icon(
                        Icons.fitness_center,
                        size: 40.0,
                      ),
                    ),
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: CategoryColors.getPrimaryColor(habit.category),
                        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))]),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            habit.habit,
                            softWrap: true,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                          ),
                          ScoreWidget(
                            animation: animation,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CueRewardWidget extends StatelessWidget {
  CueRewardWidget({Key key, this.cue, this.reward}) : super(key: key);

  final String cue;
  final String reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.0),
      child: Card(
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Deixa e meta", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.4)),
              Text("Meta: " + reward, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
              Text("Deixa: " + cue, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

class CoolDataWidget extends StatelessWidget {
  CoolDataWidget({Key key, this.initialDate, this.daysDone, this.cycles}) : super(key: key);

  final DateTime initialDate;
  final int daysDone;
  final int cycles;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.0),
      child: Card(
        elevation: 1.0,
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
              Text("Ciclos feitos: " + cycles.toString(),
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
        elevation: 1.0,
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
              builders: CalendarBuilders(markersBuilder: (context, date, event, list) {
                return <Widget>[
                  Container(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      alignment: Alignment(0.0, 0.0),
                      margin: EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ))
                ];
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
  HabitDetailsPage({Key key, this.habit, this.frequency, this.markedDays, this.fromAllHabits}) : super(key: key);

  final Habit habit;
  final dynamic frequency;
  final Map<DateTime, List> markedDays;
  final bool fromAllHabits;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> with TickerProviderStateMixin {
  AnimationController _controllerScore;

  int score;
  int previousScore = 0;
  Map<DateTime, List> markedDays;

  @override
  initState() {
    super.initState();

    score = widget.habit.score;
    markedDays = widget.markedDays;

    _controllerScore = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    animateScore();
  }

  @override
  void dispose() {
    _controllerScore.dispose();
    super.dispose();
  }

  void animateScore() {
    if (previousScore != score) {
      _controllerScore.reset();
      _controllerScore.forward().then((e) {
        previousScore = score;
      });
    }
  }

  bool hasDoneToday() {
    DateTime now = DateTime.now();
    if (widget.markedDays.containsKey(DateTime(now.year, now.month, now.day))) {
      return true;
    } else {
      return false;
    }
  }

  void setDoneHabit() {
    DataControl().setHabitDoneAndScore(widget.habit.id, widget.habit.cycle).then((earnedScore) {
      Vibration.vibrate();
      setState(() {
        score += earnedScore;
        markedDays.putIfAbsent(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), () => ['']);
      });
      animateScore();
    });
  }

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
            margin: EdgeInsets.only(top: 150.0),
            child: ListView(
              padding: EdgeInsets.only(top: 35.0, bottom: 10.0),
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Text(
                  frequencyText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w300, color: Colors.black54),
                ),
                CueRewardWidget(
                  cue: widget.habit.cue,
                  reward: widget.habit.reward,
                ),
                CoolDataWidget(
                  initialDate: widget.habit.initialDate != null ? widget.habit.initialDate : DateTime.now(),
                  daysDone: widget.habit.daysDone,
                  cycles: widget.habit.cycle,
                ),
                CalendarWidget(
                  markedDays: markedDays,
                ),
              ],
            ),
          ),
          Container(
            height: 190.0,
            width: double.maxFinite,
            child: HeaderWidget(
              habit: widget.habit,
              frequency: widget.frequency,
              fromAllHabits: widget.fromAllHabits,
              score: score,
              previousScore: previousScore,
              done: hasDoneToday(),
              setDoneHabit: setDoneHabit,
              controller: _controllerScore,
            ),
          ),
        ],
      ),
    );
  }
}
