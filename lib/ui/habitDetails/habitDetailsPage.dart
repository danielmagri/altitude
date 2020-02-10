import 'package:altitude/core/bloc/BlocProvider.dart';
import 'package:altitude/enums/BlocProviderType.dart';
import 'package:altitude/model/Frequency.dart';
import 'package:altitude/ui/competition/competitionPage.dart';
import 'package:altitude/ui/dialogs/EditAlarmDialog.dart';
import 'package:altitude/ui/dialogs/EditCueDialog.dart';
import 'package:altitude/ui/editHabitPage.dart';
import 'package:altitude/ui/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:altitude/ui/habitDetails/widgets/calendarWidget.dart';
import 'package:altitude/ui/habitDetails/widgets/competitionWidget.dart';
import 'package:altitude/ui/habitDetails/widgets/coolDataWidget.dart';
import 'package:altitude/ui/habitDetails/widgets/cueWidget.dart';
import 'package:altitude/ui/habitDetails/widgets/headerWidget.dart';
import 'package:altitude/ui/widgets/generic/Skeleton.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  String frequencyText(Frequency frequency) {
    if (frequency is DayWeek) {
      String text = "";
      bool hasOne = false;

      if (frequency.monday == 1) {
        text += "Segunda";
        hasOne = true;
      }
      if (frequency.tuesday == 1) {
        if (hasOne) text += ", ";
        text += "Terça";
        hasOne = true;
      }
      if (frequency.wednesday == 1) {
        if (hasOne) text += ", ";
        text += "Quarta";
        hasOne = true;
      }
      if (frequency.thursday == 1) {
        if (hasOne) text += ", ";
        text += "Quinta";
        hasOne = true;
      }
      if (frequency.friday == 1) {
        if (hasOne) text += ", ";
        text += "Sexta";
        hasOne = true;
      }
      if (frequency.saturday == 1) {
        if (hasOne) text += ", ";
        text += "Sábado";
        hasOne = true;
      }
      if (frequency.sunday == 1) {
        if (hasOne) text += ", ";
        text += "Domingo";
      }
      return text;
    } else if (frequency is Weekly) {
      return frequency.daysCount().toString() + " vezes por semana";
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
                  child: StreamBuilder<Frequency>(
                    stream: bloc.frequencyDataStream,
                    builder: (BuildContext context, AsyncSnapshot<Frequency> snapshot) {
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