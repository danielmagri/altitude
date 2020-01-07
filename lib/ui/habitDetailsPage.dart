import 'package:flutter/material.dart';
import 'package:habit/enums/DonePageType.dart';
import 'dart:ui';
import 'package:habit/ui/editHabitPage.dart';
import 'package:habit/ui/widgets/ScoreTextAnimated.dart';
import 'package:habit/model/Frequency.dart';
import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/ui/widgets/generic/Toast.dart';
import 'package:vibration/vibration.dart';
import 'package:habit/ui/widgets/generic/Loading.dart';
import 'package:habit/ui/detailHabitWidget/cueWidget.dart';
import 'package:habit/ui/detailHabitWidget/coolDataWidget.dart';
import 'package:habit/ui/detailHabitWidget/calendarWidget.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/ui/dialogs/EditCueDialog.dart';
import 'package:habit/ui/dialogs/EditAlarmDialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:habit/ui/detailHabitWidget/SkyScene.dart';
import 'package:habit/utils/Util.dart';
import 'package:habit/ui/dialogs/tutorials/RocketPresentation.dart';
import 'package:habit/ui/dialogs/tutorials/AlarmPresentation.dart';
import 'package:habit/services/SharedPref.dart';
import 'package:habit/services/FireAnalytics.dart';
import 'competition/competitionPage.dart';
import 'detailHabitWidget/competitionWidget.dart';

enum suggestionsType { SET_ALARM }

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage({Key key}) : super(key: key);

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> with TickerProviderStateMixin {
  PanelController _panelController = new PanelController();
  ScrollController _scrollController = new ScrollController();
  AnimationController _controllerScore;

  DataHabitDetail data = DataHabitDetail();

  int _panelIndex = -1;
  int previousScore = 0;

  @override
  initState() {
    super.initState();

    _controllerScore =
        AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await SharedPref().getRocketTutorial()) {
        Util.dialogNavigator(context, RocketPresentation());
        SharedPref().setRocketTutorial(true);
      }
    });

    animateScore();
  }

  @override
  void dispose() {
    _controllerScore.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void showSuggestionsDialog(suggestionsType suggestion) async {
    if (suggestion == suggestionsType.SET_ALARM) {
      int timesDisplayed = await SharedPref().getAlarmTutorial();
      if (timesDisplayed < 2 && DataHabitDetail().reminders.length == 0) {
        Util.dialogNavigator(context, AlarmPresentation());
        _scrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        SharedPref().setAlarmTutorial();
      }
    }
  }

  void animateScore() {
    if (previousScore != data.habit.score) {
      _controllerScore.reset();
      _controllerScore.forward().orCancel.whenComplete(() {
        previousScore = data.habit.score;
      });
    }
  }

  void updateScreen() {
    setState(() {});
    animateScore();
  }

  bool hasDoneToday() {
    DateTime now = DateTime.now();
    if (data.daysDone.containsKey(DateTime(now.year, now.month, now.day))) {
      return true;
    } else {
      return false;
    }
  }

  void setDoneHabit() {
    if (hasDoneToday()) {
      showToast("Você já completou esse hábito hoje!");
    } else {
      Loading.showLoading(context);
      DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      HabitsControl()
          .setHabitDoneAndScore(today, data.habit.id, DonePageType.Detail)
          .then((earnedScore) {
        Loading.closeLoading(context);
        Vibration.hasVibrator().then((resp) {
          if (resp != null && resp == true) {
            Vibration.vibrate(duration: 100);
          }
        });

        bool before;
        if (data.daysDone.length - 1 >= 0 &&
            data.daysDone.containsKey(today.subtract(Duration(days: 1)))) {
          data.daysDone.update(today.subtract(Duration(days: 1)), (old) => [old[0], true]);
          before = true;
        } else {
          before = false;
        }

        setState(() {
          data.habit.score += earnedScore;
          data.daysDone.putIfAbsent(today, () => [before, false]);
          data.habit.daysDone++;
        });
        animateScore();
      });
    }
  }

  Future<bool> onBackPress() async {
    if (_panelController.isPanelOpen()) {
      closeBottomSheet();
      return false;
    }

    return true;
  }

  void goCompetition() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) {
              return CompetitionPage();
            },
            settings: RouteSettings(name: "Competition Page")));
  }

  void openBottomSheet(int index) {
    if (index == 0) {
      FireAnalytics().sendReadCue();
      setState(() {
        _panelIndex = 0;
      });
      _panelController.open();
    } else if (index == 1) {
      setState(() {
        _panelIndex = 1;
      });
      _panelController.open();
    } else {
      setState(() {
        _panelIndex = -1;
      });
    }
  }

  void closeBottomSheet() {
    setState(() {});
    _panelController.close();
  }

  Widget _bottomSheetBuilder() {
    if (_panelIndex == 0) {
      return EditCueDialog(
        closeBottomSheet: closeBottomSheet,
      );
    } else if (_panelIndex == 1) {
      return EditAlarmDialog(
        closeBottomSheet: closeBottomSheet,
      );
    } else {
      return SizedBox();
    }
  }

  String frequencyText() {
    if (data.frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freq = data.frequency;
      String text = "";
      bool hasOne = false;

      if (freq.monday == 1) {
        text += "Segunda";
        hasOne = true;
      }
      if (freq.tuesday == 1) {
        if (hasOne) text += ", ";
        text += "Terça";
        hasOne = true;
      }
      if (freq.wednesday == 1) {
        if (hasOne) text += ", ";
        text += "Quarta";
        hasOne = true;
      }
      if (freq.thursday == 1) {
        if (hasOne) text += ", ";
        text += "Quinta";
        hasOne = true;
      }
      if (freq.friday == 1) {
        if (hasOne) text += ", ";
        text += "Sexta";
        hasOne = true;
      }
      if (freq.saturday == 1) {
        if (hasOne) text += ", ";
        text += "Sábado";
        hasOne = true;
      }
      if (freq.sunday == 1) {
        if (hasOne) text += ", ";
        text += "Domingo";
      }
      return text;
    } else if (data.frequency.runtimeType == FreqWeekly) {
      FreqWeekly freq = data.frequency;
      return freq.daysTime.toString() + " vezes por semana";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: SlidingUpPanel(
          controller: _panelController,
          borderRadius:
              const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          backdropEnabled: true,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minHeight: 0,
          panel: _bottomSheetBuilder(),
          body: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    BackButton(color: data.getColor()),
                    Spacer(),
                    IconButton(
                      icon: Icon(data.reminders.length != 0 ? Icons.alarm_on : Icons.alarm,
                          size: 25, color: data.getColor()),
                      onPressed: () => openBottomSheet(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 25, color: data.getColor()),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) {
                                  return EditHabitPage();
                                },
                                settings: RouteSettings(name: "Edit Habit Page")));
                      },
                    ),
                  ]),
                ),
                HeaderWidget(
                  previousScore: previousScore,
                  controllerScore: _controllerScore,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 36, bottom: 4, left: 32, right: 32),
                  width: double.maxFinite,
                  child: RaisedButton(
                    color: hasDoneToday() ? data.getColor() : Colors.white,
                    shape:
                        new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 5.0,
                    onPressed: setDoneHabit,
                    child: Text(
                      hasDoneToday() ? "HÁBITO COMPLETO!" : "COMPLETAR HÁBITO HOJE",
                      style: TextStyle(
                          fontSize: 16,
                          color: hasDoneToday() ? Colors.white : data.getColor(),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    frequencyText(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
                  ),
                ),
                CueWidget(
                  openBottomSheet: openBottomSheet,
                ),
                CalendarWidget(
                  updateScreen: updateScreen,
                  showSuggestionsDialog: showSuggestionsDialog,
                ),
                DataHabitDetail().competitions.isEmpty
                    ? CompetitionWidget(
                        goCompetition: goCompetition,
                      )
                    : SizedBox(),
                CoolDataWidget(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  HeaderWidget({Key key, this.previousScore, this.controllerScore}) : super(key: key);

  final int previousScore;
  final controllerScore;

  double _setRocketForce() {
    double force;
    int cycleDays = Util.getDaysCycle(DataHabitDetail().frequency);
    int timesDays = Util.getTimesDays(DataHabitDetail().frequency);
    List<DateTime> dates = DataHabitDetail().daysDone.keys.toList();

    int daysDoneLastCycle = dates
        .where((date) => date.isAfter(DateTime.now().subtract(Duration(days: cycleDays + 1))))
        .length;

    force = daysDoneLastCycle / timesDays;

    if (force > 1.3) force = 1.3;
    return force;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SkyScene(
              size: const Size(140, 140),
              color: DataHabitDetail().getColor(),
              force: _setRocketForce(),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  DataHabitDetail().habit.habit,
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 19),
                ),
                ScoreWidget(
                  color: DataHabitDetail().getColor(),
                  animation: IntTween(begin: previousScore, end: DataHabitDetail().habit.score)
                      .animate(
                          CurvedAnimation(parent: controllerScore, curve: Curves.fastOutSlowIn)),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
