import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/core/base/base_state.dart';
import 'package:altitude/core/services/Database.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_local_notification.dart';
import 'package:flutter/material.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/model/result.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:get_it/get_it.dart';

class TransferDataDialog extends StatefulWidget {
  const TransferDataDialog({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _TransferDataDialogState createState() => _TransferDataDialogState();
}

class _TransferDataDialogState extends BaseState<TransferDataDialog> {
  final GetUserDataUsecase _getUserDataUsecase =
      GetIt.I.get<GetUserDataUsecase>();
  final GetHabitsUsecase _getHabitsUsecase = GetIt.I.get<GetHabitsUsecase>();
  final PersonUseCase _personUseCase = GetIt.I.get<PersonUseCase>();
  final HabitUseCase _habitUseCase = GetIt.I.get<HabitUseCase>();
  final ILocalNotification _localNotification =
      GetIt.I.get<ILocalNotification>();
  final IFireAnalytics _fireAnalytics = GetIt.I.get<IFireAnalytics>();

  double? progress;

  @override
  initState() {
    super.initState();
    setPersonData(widget.uid).then((value) {
      navigatePop(result: value ?? true);
    }).catchError((error) {
      handleError(error);
      navigatePop(result: false);
    });
  }

  Future setPersonData(String uid) async {
    try {
      if (!await DatabaseService().existDB()) {
        (await _personUseCase.createPerson()).result((data) {}, (error) async {
          await _personUseCase.logout();
          throw "Erro ao salvar os dados (1)";
        });
      } else {
        Result<Person> result = await _getUserDataUsecase.call(true);

        int score = 0;
        if (result.isError) {
          (await _personUseCase.createPerson()).result((data) {},
              (error) async {
            await _personUseCase.logout();
            throw "Erro ao salvar os dados (2)";
          });
        } else {
          Person person = (result as SuccessResult).data;
          score = (await _getHabitsUsecase.call(true)).result(
              ((data) => data.isEmpty
                      ? 0
                      : data.map((e) => e.score).reduce((a, b) => a! + b!)!)
                  as int Function(List<Habit>),
              (error) => 0);

          (await _personUseCase.createPerson(
                  level: LevelControl.getLevel(score),
                  score: score,
                  reminderCounter: 0,
                  friends: person.friends,
                  pendingFriends: person.pendingFriends))
              .result((data) {}, (error) async {
            await _personUseCase.logout();
            throw "Erro ao salvar os dados (3)";
          });
        }

        await _localNotification.removeAllNotification();

        List<Habit> habits = await DatabaseService().getAllHabits();
        int counter = 0;

        for (Habit habit in habits) {
          habit.frequency = await DatabaseService().getFrequency(habit.oldId);
          habit.reminder = await DatabaseService().getReminders(habit.oldId);

          List<String?> competitionsId =
              await DatabaseService().listCompetitionsIds(habitId: habit.oldId);
          List<DayDone> daysDone =
              await DatabaseService().getDaysDone(habit.oldId);
          habit.daysDone = daysDone.length;
          habit.score = ScoreControl().scoreEarnedTotal(
              habit.frequency, daysDone.map((e) => e.date).toList());

          score += habit.score!;

          await (await _habitUseCase.transferHabit(
                  habit, competitionsId, daysDone))
              .result((data) async {
            counter++;

            setState(() {
              progress = counter / habits.length;
            });

            await DatabaseService().deleteHabit(habit.oldId);
          }, (error) async {
            await _personUseCase.logout();
            throw "Erro ao salvar os dados (4)";
          });
        }

        await _habitUseCase.updateTotalScore(score);
      }

      await DatabaseService().deleteDB();
      _fireAnalytics.setUserId(uid);
      return true;
    } catch (e) {
      await _personUseCase.logout();
      throw "Erro ao salvar os dados (0)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
            backgroundColor: AppTheme.of(context).materialTheme.cardColor,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(children: [
                    const Text("Fazendo a transferência dos dados",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Color.fromARGB(255, 211, 211, 211),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange)),
                    const SizedBox(height: 16),
                    const Text("Carregando...."),
                    const SizedBox(height: 8),
                    const Text("Por favor não feche o app",
                        style: TextStyle(fontSize: 11)),
                    const SizedBox(height: 4),
                    const Text(
                        "Caso tenha algum problema na pontuação é possível recalcular na seção de configurações.",
                        style: TextStyle(fontSize: 11)),
                  ]),
                ),
              )
            ]));
  }
}
