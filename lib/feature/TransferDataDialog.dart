import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/core/services/Database.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart';
import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/services/LocalNotification.dart';

class TransferDataDialog extends StatefulWidget {
  const TransferDataDialog({Key key, @required this.uid}) : super(key: key);

  final String uid;

  @override
  _TransferDataDialogState createState() => _TransferDataDialogState();
}

class _TransferDataDialogState extends BaseState<TransferDataDialog> {
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;
  final HabitUseCase _habitUseCase = HabitUseCase.getInstance;
  final CompetitionUseCase _competitionUseCase = CompetitionUseCase.getInstance;
  final SharedPref _sharedPref = SharedPref.instance;

  double progress;

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
          throw "Erro ao salvar os dados";
        });
      } else {
        Result<Person> result = await _personUseCase.getPerson(fromServer: true);

        if (result.isError) {
          (await _personUseCase.createPerson(
            level: LevelControl.getLevel(_sharedPref.score),
            score: _sharedPref.score,
            reminderCounter: 0,
          ))
              .result((data) {}, (error) async {
            await _personUseCase.logout();
            throw "Erro ao salvar os dados";
          });
        } else {
          Person person = (result as RSuccess).data;
          (await _personUseCase.createPerson(
                  level: LevelControl.getLevel(_sharedPref.score),
                  score: _sharedPref.score,
                  reminderCounter: 0,
                  friends: person.friends,
                  pendingFriends: person.pendingFriends))
              .result((data) {}, (error) async {
            await _personUseCase.logout();
            throw "Erro ao salvar os dados";
          });
        }

        await LocalNotification().removeAllNotification();

        List<Habit> habits = await DatabaseService().getAllHabits();
        List<Habit> newHabits = [];

        for (Habit habit in habits) {
          habit.frequency = await DatabaseService().getFrequency(habit.oldId);
          habit.reminder = await DatabaseService().getReminders(habit.oldId);

          await (await _habitUseCase.addHabit(habit)).result((data) async {
            newHabits.add(data);

            List<String> competitionsId = await DatabaseService().listCompetitionsIds(habitId: habit.oldId);

            for (String competitionId in competitionsId) {
              await (await _competitionUseCase.updateCompetitor(competitionId, data.id)).result((data) async {
                await DatabaseService().removeCompetition(competitionId);
              }, (error) async {
                await _personUseCase.logout();
                throw "Erro ao salvar os dados";
              });
            }

            await DatabaseService().deleteHabit(habit.oldId);
            progress = (newHabits.length / habits.length) / 0.5;
          }, (error) async {
            await _personUseCase.logout();
            throw "Erro ao salvar os dados";
          });
        }
      }

      FireAnalytics().analytics.setUserId(uid);
      return true;
    } catch (e) {
      await _personUseCase.logout();
      throw "Erro ao salvar os dados";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(children: [
                const Text("Fazendo a transferência dos dados",
                    style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.lightGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
                const SizedBox(height: 16),
                const Text("Carregando...."),
                const SizedBox(height: 8),
                const Text("Por favor não feche o app", style: TextStyle(fontSize: 12)),
              ]),
            ),
          )
        ]));
  }
}
