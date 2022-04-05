import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/constant/level_utils.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/common/model/result.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/domain/models/day_done_entity.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/domain/usecases/auth/logout_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/domain/usecases/habits/transfer_habit_usecase.dart';
import 'package:altitude/domain/usecases/user/create_person_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/domain/usecases/user/update_total_score_usecase.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_local_notification.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:altitude/infra/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TransferDataDialog extends StatefulWidget {
  const TransferDataDialog({required this.uid, Key? key}) : super(key: key);

  final String uid;

  @override
  _TransferDataDialogState createState() => _TransferDataDialogState();
}

class _TransferDataDialogState extends BaseState<TransferDataDialog> {
  final GetUserDataUsecase _getUserDataUsecase =
      GetIt.I.get<GetUserDataUsecase>();
  final GetHabitsUsecase _getHabitsUsecase = GetIt.I.get<GetHabitsUsecase>();
  final LogoutUsecase _logoutUsecase = GetIt.I.get<LogoutUsecase>();
  final CreatePersonUsecase _createPersonUsecase =
      GetIt.I.get<CreatePersonUsecase>();
  final ILocalNotification _localNotification =
      GetIt.I.get<ILocalNotification>();
  final IFireAnalytics _fireAnalytics = GetIt.I.get<IFireAnalytics>();
  final UpdateTotalScoreUsecase _updateTotalScoreUsecase =
      GetIt.I.get<UpdateTotalScoreUsecase>();
  final TransferHabitUsecase _transferHabitUsecase =
      GetIt.I.get<TransferHabitUsecase>();
  final IScoreService _scoreService = GetIt.I.get<IScoreService>();

  double? progress;

  @override
  void initState() {
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
        (await _createPersonUsecase.call(CreatePersonParams()))
            .result((data) {}, (error) async {
          await _logoutUsecase.call(NoParams());
          throw 'Erro ao salvar os dados (1)';
        });
      } else {
        Result<Person> result = await _getUserDataUsecase.call(true);

        int score = 0;
        if (result.isError) {
          (await _createPersonUsecase.call(CreatePersonParams()))
              .result((data) {}, (error) async {
            await _logoutUsecase.call(NoParams());
            throw 'Erro ao salvar os dados (2)';
          });
        } else {
          Person person = (result as SuccessResult).data;
          score = (await _getHabitsUsecase.call(true)).result(
            ((data) => data.isEmpty
                    ? 0
                    : data.map((e) => e.score).reduce((a, b) => a! + b!)!)
                as int Function(List<Habit>),
            (error) => 0,
          );

          (await _createPersonUsecase.call(
            CreatePersonParams(
              level: LevelUtils.getLevel(score),
              score: score,
              reminderCounter: 0,
              friends: person.friends,
              pendingFriends: person.pendingFriends,
            ),
          ))
              .result((data) {}, (error) async {
            await _logoutUsecase.call(NoParams());
            throw 'Erro ao salvar os dados (3)';
          });
        }

        await _localNotification.removeAllNotification();

        List<Habit> habits = await DatabaseService().getAllHabits();
        int counter = 0;

        for (Habit habit in habits) {
          habit.frequency = await DatabaseService().getFrequency(habit.oldId);
          habit.reminder = await DatabaseService().getReminders(habit.oldId);

          List<String> competitionsId =
              await DatabaseService().listCompetitionsIds(habitId: habit.oldId);
          List<DayDone> daysDone =
              await DatabaseService().getDaysDone(habit.oldId);
          habit.daysDone = daysDone.length;
          habit.score = _scoreService.scoreEarnedTotal(
            habit.frequency!,
            daysDone.map((e) => e.date).toList(),
          );

          score += habit.score!;

          await (await _transferHabitUsecase.call(
            TransferHabitParams(
              habit: habit,
              competitionsId: competitionsId,
              daysDone: daysDone,
            ),
          ))
              .result((_) async {
            counter++;

            setState(() {
              progress = counter / habits.length;
            });

            await DatabaseService().deleteHabit(habit.oldId);
          }, (error) async {
            await _logoutUsecase.call(NoParams());
            throw 'Erro ao salvar os dados (4)';
          });
        }

        await _updateTotalScoreUsecase.call(score);
      }

      await DatabaseService().deleteDB();
      _fireAnalytics.setUserId(uid);
      return true;
    } catch (e) {
      await _logoutUsecase.call(NoParams());
      throw 'Erro ao salvar os dados (0)';
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
              child: Column(
                children: [
                  const Text(
                    'Fazendo a transferência dos dados',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color.fromARGB(255, 211, 211, 211),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  const SizedBox(height: 16),
                  const Text('Carregando....'),
                  const SizedBox(height: 8),
                  const Text(
                    'Por favor não feche o app',
                    style: TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Caso tenha algum problema na pontuação é possível recalcular na seção de configurações.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
