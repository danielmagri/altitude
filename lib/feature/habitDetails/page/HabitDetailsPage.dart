import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/core/bloc/model/LoadableData.dart';
import 'package:altitude/feature/editHabit/page/EditHabitPage.dart';
import 'package:altitude/feature/habitDetails/dialogs/EditAlarmDialog.dart';
import 'package:altitude/feature/habitDetails/dialogs/EditCueDialog.dart';
import 'package:altitude/feature/habitDetails/blocs/habitDetailsBloc.dart';
import 'package:altitude/feature/habitDetails/enums/BottomSheetType.dart';
import 'package:altitude/feature/habitDetails/widgets/calendarWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/competitionWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/coolDataWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/cueWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/headerWidget.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage(this.habitId, this.color);

  final int habitId;
  final int color;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  HabitDetailsBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = HabitDetailsBloc(widget.habitId, widget.color);

    bloc.showInitialTutorial(context);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Future<bool> onBackPress() {
    if (bloc.panelController.isPanelOpen()) {
      bloc.closeBottomSheet();
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _bottomSheetBuilder(BottomSheetType type) {
    switch (type) {
      case BottomSheetType.CUE:
        return EditCueDialog(bloc.habit, bloc.editCueCallback);
      case BottomSheetType.REMINDER:
        return EditAlarmDialog(bloc.habit, bloc.reminders, bloc.editAlarmCallback);
      default:
        return SizedBox();
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
          onPanelClosed: bloc.emptyBottomSheet,
          panel: StreamBuilder<BottomSheetType>(
            stream: bloc.bottomSheetStream,
            builder: (BuildContext context, AsyncSnapshot<BottomSheetType> snapshot) =>
                _bottomSheetBuilder(snapshot.data),
          ),
          body: SingleChildScrollView(
            controller: bloc.scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BackButton(color: bloc.habitColor),
                      Spacer(),
                      StreamBuilder<int>(
                        stream: bloc.reminderButtonStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return IconButton(
                              icon: Icon(
                                snapshot.data != 0 ? Icons.alarm_on : Icons.add_alarm,
                                size: 25,
                                color: bloc.habitColor,
                              ),
                              onPressed: () => bloc.openBottomSheet(BottomSheetType.REMINDER),
                            );
                          } else if (snapshot.hasError) {
                            return SizedBox();
                          } else {
                            return Skeleton(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 4, right: 8),
                            );
                          }
                        },
                      ),
                      StreamBuilder(
                        stream: bloc.habitStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return IconButton(
                              icon: Icon(Icons.edit, size: 25, color: bloc.habitColor),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) {
                                          return EditHabitPage(bloc.habit, bloc.frequency, bloc.reminders);
                                        },
                                        settings: RouteSettings(name: "Edit Habit Page")));
                              },
                            );
                          } else if (snapshot.hasError) {
                            return SizedBox();
                          } else {
                            return Skeleton(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 4, right: 8),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                HeaderWidget(bloc: bloc),
                Container(
                  margin: const EdgeInsets.only(top: 36, bottom: 4, left: 32, right: 32),
                  width: double.maxFinite,
                  height: 50,
                  child: StreamBuilder<LoadableData<bool>>(
                    stream: bloc.completeButtonStram,
                    builder: (BuildContext context, AsyncSnapshot<LoadableData<bool>> snapshot) {
                      if (snapshot.hasData) {
                        return RaisedButton(
                          color: snapshot.data.data ? bloc.habitColor : Colors.white,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 5.0,
                          onPressed: () {
                            if (!snapshot.data.data)
                              bloc.completeHabit(context, true, DateTime.now().today, DonePageType.Detail);
                          },
                          child: snapshot.data.loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: new AlwaysStoppedAnimation<Color>(
                                          snapshot.data.data ? Colors.white : bloc.habitColor)),
                                )
                              : Text(
                                  snapshot.data.data ? "HÁBITO COMPLETO!" : "COMPLETAR HÁBITO HOJE",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: snapshot.data.data ? Colors.white : bloc.habitColor,
                                      fontWeight: FontWeight.bold),
                                ),
                        );
                      } else if (snapshot.hasError) {
                        return SizedBox();
                      } else {
                        return Skeleton(
                          width: double.maxFinite,
                          height: 50,
                        );
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: StreamBuilder<Frequency>(
                    stream: bloc.frequencyTextStream,
                    builder: (BuildContext context, AsyncSnapshot<Frequency> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.frequencyText(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
                        );
                      } else if (snapshot.hasError) {
                        return SizedBox();
                      } else {
                        return Skeleton(
                          width: 200,
                          height: 20,
                        );
                      }
                    },
                  ),
                ),
                CueWidget(bloc: bloc),
                SizedBox(height: 16),
                CalendarWidget(bloc: bloc),
                SizedBox(height: 16),
                StreamBuilder<List<String>>(
                    stream: bloc.competitionListStream,
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.isEmpty ? CompetitionWidget(bloc: bloc) : SizedBox();
                      } else if (snapshot.hasError) {
                        return SizedBox();
                      } else {
                        return Skeleton(
                          width: double.maxFinite,
                          height: 130,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                        );
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
