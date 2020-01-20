import 'package:flutter/material.dart';
import 'package:habit/core/bloc/BlocProvider.dart';
import 'package:habit/enums/BlocProviderType.dart';
import 'package:habit/ui/dialogs/EditAlarmDialog.dart';
import 'package:habit/ui/dialogs/EditCueDialog.dart';
import 'dart:ui';
import 'package:habit/ui/editHabitPage.dart';
import 'package:habit/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:habit/ui/habitDetails/widgets/headerWidget.dart';
import 'package:habit/model/Frequency.dart';
import 'package:habit/ui/habitDetails/widgets/cueWidget.dart';
import 'package:habit/ui/habitDetails/widgets/coolDataWidget.dart';
import 'package:habit/ui/habitDetails/widgets/calendarWidget.dart';
import 'package:habit/ui/widgets/generic/Skeleton.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:habit/ui/competition/competitionPage.dart';
import 'package:habit/ui/habitDetails/widgets/competitionWidget.dart';

class HabitDetailsPage extends StatelessWidget {
  HabitDetailsPage({Key key, @required this.bloc}) : super(key: key);

  final HabitDeatilsBloc bloc;

  static Widget newinstance(int habitId) {
    final bloc = HabitDeatilsBloc(habitId);
    return BlocProvider<HabitDeatilsBloc>(
      type: BlocProviderType.SingleAnimation,
      bloc: bloc,
      widget: HabitDetailsPage(bloc: bloc),
    );
  }

  void goCompetition(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return CompetitionPage();
        },
        settings: RouteSettings(name: "Competition Page")));
  }

  Future<bool> onBackPress() async {
    if (bloc.panelController.isPanelOpen()) {
      bloc.closeBottomSheet();
      return false;
    }
    return true;
  }

  Widget _bottomSheetBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.data) {
      case 0:
        return EditCueDialog(closeBottomSheet: bloc.closeBottomSheet);
      case 1:
        return EditAlarmDialog(closeBottomSheet: bloc.closeBottomSheet);
      default:
        return SizedBox();
    }
  }

  String frequencyText(dynamic frequency) {
    if (frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freq = frequency;
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
    } else if (frequency.runtimeType == FreqWeekly) {
      FreqWeekly freq = frequency;
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
          controller: bloc.panelController,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          backdropEnabled: true,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minHeight: 0,
          panel: StreamBuilder<int>(
            stream: bloc.bottomSheetStream,
            builder: _bottomSheetBuilder,
          ),
          body: SingleChildScrollView(
            controller: bloc.scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    BackButton(color: bloc.data.getColor()),
                    Spacer(),
                    IconButton(
                      icon: Icon(bloc.data.reminders.length != 0 ? Icons.alarm_on : Icons.alarm,
                          size: 25, color: bloc.data.getColor()),
                      onPressed: () => bloc.openBottomSheet(1),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 25, color: bloc.data.getColor()),
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
                HeaderWidget(bloc: bloc),
                Container(
                  margin: const EdgeInsets.only(top: 36, bottom: 4, left: 32, right: 32),
                  width: double.maxFinite,
                  child: StreamBuilder<Map<DateTime, List>>(
                    stream: bloc.daysDoneDataStream,
                    builder: (BuildContext context, AsyncSnapshot<Map<DateTime, List>> snapshot) {
                      if (!snapshot.hasData) {
                        return Skeleton(
                          width: double.maxFinite,
                          height: 40,
                        );
                      } else {
                        bool done = false;
                        DateTime now = DateTime.now();
                        if (snapshot.data.containsKey(DateTime(now.year, now.month, now.day))) {
                          done = true;
                        }
                        return RaisedButton(
                          color: done ? bloc.data.getColor() : Colors.white,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 5.0,
                          onPressed: () {
                            
                          }, //setDoneHabit,
                          child: Text(
                            done ? "HÁBITO COMPLETO!" : "COMPLETAR HÁBITO HOJE",
                            style: TextStyle(
                                fontSize: 16,
                                color: done ? Colors.white : bloc.data.getColor(),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: StreamBuilder<dynamic>(
                    stream: bloc.frequencyDataStream,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return Skeleton(
                          width: 200,
                          height: 20,
                        );
                      } else {
                        return Text(
                          frequencyText(snapshot.data),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
                        );
                      }
                    },
                  ),
                ),
                CueWidget(bloc: bloc),
                SizedBox(height: 16),
                CalendarWidget(
                  bloc: bloc, //updateScreen,
                  showSuggestionsDialog: () {}, //showSuggestionsDialog,
                ),
                SizedBox(height: 16),
                StreamBuilder<List<String>>(
                    stream: bloc.competitionDataStream,
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (!snapshot.hasData) {
                        return Skeleton(
                          width: double.maxFinite,
                          height: 130,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                        );
                      } else {
                        return snapshot.data.isEmpty
                            ? CompetitionWidget(
                                goCompetition: goCompetition,
                              )
                            : SizedBox();
                      }
                    }),
                SizedBox(height: 16),
                CoolDataWidget(bloc: bloc),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// enum suggestionsType { SET_ALARM }

// class HabitDetailsPage extends StatefulWidget {
//   HabitDetailsPage({Key key}) : super(key: key);

//   @override
//   _HabitDetailsPageState createState() => _HabitDetailsPageState();
// }

// class _HabitDetailsPageState extends State<HabitDetailsPage> with TickerProviderStateMixin {
//
//   

//   DataHabitDetail data = DataHabitDetail();

//   int _panelIndex = -1;
//   int previousScore = 0;

//   @override
//   initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!await SharedPref().getRocketTutorial()) {
//         Util.dialogNavigator(context, RocketPresentation());
//         SharedPref().setRocketTutorial(true);
//       }
//     });

//   }

//   void showSuggestionsDialog(suggestionsType suggestion) async {
//     if (suggestion == suggestionsType.SET_ALARM) {
//       int timesDisplayed = await SharedPref().getAlarmTutorial();
//       if (timesDisplayed < 2 && DataHabitDetail().reminders.length == 0) {
//         Util.dialogNavigator(context, AlarmPresentation());
//         _scrollController.animateTo(0,
//             duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//         SharedPref().setAlarmTutorial();
//       }
//     }
//   }

//   void updateScreen() {
//     setState(() {});
//     animateScore();
//   }

//   bool hasDoneToday() {
//     DateTime now = DateTime.now();
//     if (data.daysDone.containsKey(DateTime(now.year, now.month, now.day))) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void setDoneHabit() {
//     if (hasDoneToday()) {
//       showToast("Você já completou esse hábito hoje!");
//     } else {
//       Loading.showLoading(context);
//       DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

//       HabitsControl()
//           .setHabitDoneAndScore(today, data.habit.id, DonePageType.Detail)
//           .then((earnedScore) {
//         Loading.closeLoading(context);
//         Vibration.hasVibrator().then((resp) {
//           if (resp != null && resp == true) {
//             Vibration.vibrate(duration: 100);
//           }
//         });

//         bool before;
//         if (data.daysDone.length - 1 >= 0 &&
//             data.daysDone.containsKey(today.subtract(Duration(days: 1)))) {
//           data.daysDone.update(today.subtract(Duration(days: 1)), (old) => [old[0], true]);
//           before = true;
//         } else {
//           before = false;
//         }

//         setState(() {
//           data.habit.score += earnedScore;
//           data.daysDone.putIfAbsent(today, () => [before, false]);
//           data.habit.daysDone++;
//         });
//         animateScore();
//       });
//     }
//   }

//

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: onBackPress,
//       child: Scaffold(
//         body: SlidingUpPanel(
//           controller: _panelController,
//           borderRadius:
//               const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
//           backdropEnabled: true,
//           maxHeight: MediaQuery.of(context).size.height * 0.8,
//           minHeight: 0,
//           panel: _bottomSheetBuilder(),
//           body: SingleChildScrollView(
//             controller: _scrollController,
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 75,
//                   child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
//                     BackButton(color: data.getColor()),
//                     Spacer(),
//                     IconButton(
//                       icon: Icon(data.reminders.length != 0 ? Icons.alarm_on : Icons.alarm,
//                           size: 25, color: data.getColor()),
//                       onPressed: () => openBottomSheet(1),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.edit, size: 25, color: data.getColor()),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) {
//                                   return EditHabitPage();
//                                 },
//                                 settings: RouteSettings(name: "Edit Habit Page")));
//                       },
//                     ),
//                   ]),
//                 ),
//                 HeaderWidget(
//                   previousScore: previousScore,
//                   controllerScore: _controllerScore,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 36, bottom: 4, left: 32, right: 32),
//                   width: double.maxFinite,
//                   child: RaisedButton(
//                     color: hasDoneToday() ? data.getColor() : Colors.white,
//                     shape:
//                         new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     elevation: 5.0,
//                     onPressed: setDoneHabit,
//                     child: Text(
//                       hasDoneToday() ? "HÁBITO COMPLETO!" : "COMPLETAR HÁBITO HOJE",
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: hasDoneToday() ? Colors.white : data.getColor(),
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 20),
//                   child: Text(
//                     frequencyText(),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
//                   ),
//                 ),
//                 CueWidget(
//                   openBottomSheet: openBottomSheet,
//                 ),
//                 CalendarWidget(
//                   updateScreen: updateScreen,
//                   showSuggestionsDialog: showSuggestionsDialog,
//                 ),
//                 DataHabitDetail().competitions.isEmpty
//                     ? CompetitionWidget(
//                         goCompetition: goCompetition,
//                       )
//                     : SizedBox(),
//                 CoolDataWidget(),
//                 SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
