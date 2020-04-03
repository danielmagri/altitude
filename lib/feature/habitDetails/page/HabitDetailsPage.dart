import 'package:altitude/common/enums/DonePageType.dart';
import 'package:altitude/common/services/SharedPref.dart';
import 'package:altitude/common/view/generic/Skeleton.dart';
import 'package:altitude/common/view/generic/TutorialDialog.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/habitDetails/dialogs/EditAlarmDialog.dart';
import 'package:altitude/feature/habitDetails/dialogs/EditCueDialog.dart';
import 'package:altitude/feature/habitDetails/enums/BottomSheetType.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/feature/habitDetails/widgets/calendarWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/competitionWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/coolDataWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/cueWidget.dart';
import 'package:altitude/feature/habitDetails/widgets/headerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:table_calendar/table_calendar.dart' show CalendarController;

class HabitDetailsPage extends StatefulWidget {
  HabitDetailsPage(this.habitId, this.color);

  final int habitId;
  final int color;

  @override
  _HabitDetailsPageState createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends BaseState<HabitDetailsPage> {
  ScrollController scrollController = ScrollController();
  PanelController panelController = PanelController();
  CalendarController calendarController = CalendarController();

  HabitDetailsLogic controller = GetIt.I.get<HabitDetailsLogic>();

  @override
  void initState() {
    super.initState();

    controller.fetchData(widget.habitId, widget.color);

    // bloc.showInitialTutorial(context);
  }

  void showInitialTutorial(BuildContext context) async {
    // if (!await SharedPref().getRocketTutorial()) {
    //   Timer.run(() async {
    //     await Future.delayed(Duration(milliseconds: 600));
    //     // scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    //     await navigateSmooth(
    //       context,
    //       TutorialWidget(
    //         focusAlignment: Alignment(-0.55, -0.6),
    //         focusRadius: 0.42,
    //         textAlignment: Alignment(0, 0.5),
    //         text: [
    //           TextSpan(
    //               text: "Esse é seu hábito em forma de foguete..",
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    //           TextSpan(text: "\nQuanto mais você completar seu hábito mais potente ele fica e mais longe vai!"),
    //           TextSpan(
    //               text: "\n\nSiga a frequência certinho para ir ainda mais longe!",
    //               style: TextStyle(fontWeight: FontWeight.w300)),
    //         ],
    //         hasNext: true,
    //       ),
    //     );
    //     // await scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    //     await navigateSmooth(
    //       context,
    //       TutorialWidget(
    //         focusAlignment: Alignment(0.0, -0.35),
    //         focusRadius: 0.45,
    //         textAlignment: Alignment(0, 0.51),
    //         text: [
    //           TextSpan(
    //               text: "No calendario você tem o controle de todos os dias feitos!",
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    //           TextSpan(text: "\n\nAo ficar pressionando um dia você consegue marcar como feito ou desmarcar."),
    //         ],
    //       ),
    //     );
    //   });
    //   SharedPref().setRocketTutorial(true);
    // }
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<HabitDetailsLogic>();
    scrollController.dispose();
    calendarController.dispose();
    super.dispose();
  }

  Future<bool> onBackPress() {
    if (panelController.isPanelOpen()) {
      closeBottomSheet();
      return Future.value(false);
    }
    return Future.value(true);
  }

  void completeHabit(bool add, DateTime date, DonePageType donePageType) {
    controller.setDoneHabit(add, date, donePageType).then((_) async {
      vibratePhone();
      if (donePageType == DonePageType.Calendar &&
          add &&
          await SharedPref().getAlarmTutorial() < 2 &&
          controller.reminders.data.isEmpty) {
        await Future.delayed(Duration(milliseconds: 600));
        scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        navigateSmooth(
          TutorialDialog(
            focusAlignment: Alignment(0.65, -0.85),
            focusRadius: 0.15,
            textAlignment: Alignment(0, 0),
            text: [
              TextSpan(
                  text: "Esqueceu de marcar como feito o hábito?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: "\n\nQue tal colocar um alarme, assim você será sempre lembrado a hora que desejar!"),
            ],
          ),
        );
        SharedPref().setAlarmTutorial();
      }
    }).catchError(handleError);
  }

  void openBottomSheet(BottomSheetType type) {
    controller.switchPanelType(type);
    panelController.open();
  }

  void closeBottomSheet() {
    controller.switchPanelType(BottomSheetType.NONE);
  }

  Widget _bottomSheetBuilder(BottomSheetType type) {
    switch (type) {
      case BottomSheetType.CUE:
        return const EditCueDialog();
      case BottomSheetType.REMINDER:
        return const EditAlarmDialog();
      default:
        panelController.close();
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: SlidingUpPanel(
          controller: panelController,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          backdropEnabled: true,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minHeight: 0,
          onPanelClosed: closeBottomSheet,
          panel: Observer(builder: (_) => _bottomSheetBuilder(controller.panelType)),
          body: SingleChildScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BackButton(color: controller.habitColor),
                      const Spacer(),
                      Observer(builder: (_) {
                        return controller.reminders.handleState(() {
                          return Skeleton(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 4, right: 8),
                          );
                        }, (data) {
                          return IconButton(
                            icon: Icon(
                              data.isNotEmpty ? Icons.alarm_on : Icons.add_alarm,
                              size: 25,
                              color: controller.habitColor,
                            ),
                            onPressed: () => openBottomSheet(BottomSheetType.REMINDER),
                          );
                        }, (error) {
                          return SizedBox();
                        });
                      }),
                      Observer(
                        builder: (_) {
                          return controller.habit.handleState(() {
                            return Skeleton(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 4, right: 8),
                            );
                          }, (data) {
                            return IconButton(
                              icon: Icon(Icons.edit, size: 25, color: controller.habitColor),
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) {
                                //           return EditHabitPage(controller.habit.data, bloc.frequency, bloc.reminders);
                                //         },
                                //         settings: RouteSettings(name: "Edit Habit Page")));
                              },
                            );
                          }, (error) {
                            return SizedBox();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                HeaderWidget(),
                Container(
                  margin: const EdgeInsets.only(top: 36, bottom: 4, left: 32, right: 32),
                  width: double.maxFinite,
                  height: 50,
                  child: Observer(
                    builder: (_) {
                      return controller.isHabitDone.handleStateLoadable(() {
                        return Skeleton(
                          width: double.maxFinite,
                          height: 50,
                        );
                      }, (data, loading) {
                        return RaisedButton(
                          color: data ? controller.habitColor : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 5.0,
                          onPressed: () {
                            if (!data) completeHabit(true, DateTime.now().today, DonePageType.Detail);
                          },
                          child: loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(data ? Colors.white : controller.habitColor)))
                              : Text(data ? "HÁBITO COMPLETO!" : "COMPLETAR HÁBITO HOJE",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: data ? Colors.white : controller.habitColor,
                                      fontWeight: FontWeight.bold)),
                        );
                      }, (error) {
                        return const SizedBox();
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Observer(
                    builder: (_) {
                      return controller.frequency.handleState(() {
                        return Skeleton(
                          width: 200,
                          height: 20,
                        );
                      }, (data) {
                        return Text(
                          data.frequencyText(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
                        );
                      }, (error) {
                        return const SizedBox();
                      });
                    },
                  ),
                ),
                CueWidget(openBottomSheet: openBottomSheet),
                const SizedBox(height: 16),
                CalendarWidget(calendarController: calendarController, completeHabit: completeHabit),
                const SizedBox(height: 16),
                Observer(builder: (_) {
                  return controller.competitions.handleState(() {
                    return Skeleton(
                      width: double.maxFinite,
                      height: 130,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                    );
                  }, (data) {
                    return data.isEmpty ? CompetitionWidget() : SizedBox();
                  }, (error) {
                    return const SizedBox();
                  });
                }),
                const SizedBox(height: 16),
                CoolDataWidget(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
