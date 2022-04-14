import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:flutter/material.dart'
    show
        Container,
        CrossAxisAlignment,
        DropdownButton,
        DropdownMenuItem,
        EdgeInsets,
        TextButton,
        FontWeight,
        Key,
        Row,
        Size,
        SizedBox,
        StatefulWidget,
        Text,
        TextStyle,
        Widget,
        required;
import 'package:get_it/get_it.dart';

class ChooseHabit extends StatefulWidget {
  ChooseHabit({Key key, @required this.competition, @required this.habits}) : super(key: key);

  final Competition competition;
  final List<Habit> habits;

  @override
  _ChooseHabitState createState() => _ChooseHabitState();
}

class _ChooseHabitState extends BaseState<ChooseHabit> {
  final PersonUseCase _personUseCase = GetIt.I.get<PersonUseCase>();
  final HabitUseCase _habitUseCase = GetIt.I.get<HabitUseCase>();
  final CompetitionUseCase _competitionUseCase = GetIt.I.get<CompetitionUseCase>();

  Habit selectedHabit;

  void acceptRequest() async {
    if (await _competitionUseCase.maximumNumberReachedByHabit(selectedHabit.id)) {
      showToast("O hábito já faz parte de $MAX_HABIT_COMPETITIONS competições.");
    } else {
      showLoading(true);
      List<DateTime> days =
          (await _habitUseCase.getDaysDone(selectedHabit.id, widget.competition.initialDate, DateTime.now().today))
              .absoluteResult()
              .map((e) => e.date)
              .toList();

      Competitor competitor = Competitor(
          name: _personUseCase.name,
          fcmToken: await _personUseCase.fcmToken,
          color: selectedHabit.colorCode,
          habitId: selectedHabit.id,
          uid: GetIt.I.get<IFireAuth>().getUid(),
          score: ScoreControl().scoreEarnedTotal(selectedHabit.frequency, days),
          you: true);
      _competitionUseCase.acceptCompetitionRequest(widget.competition.id, widget.competition, competitor).then((_) {
        showLoading(false);
        navigatePop(result: widget.competition);
      }).catchError(handleError);
    }
  }

  @override
  Widget build(_) {
    return BaseDialog(
      title: 'Escolha o hábito para competir',
      body: Container(
        margin: const EdgeInsets.only(right: 8, left: 8),
        child: DropdownButton<Habit>(
            value: selectedHabit,
            isExpanded: true,
            hint: const Text("Escolher o hábito"),
            items: widget.habits.map((habit) {
              return DropdownMenuItem(
                value: habit,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Rocket(size: const Size(30, 30), isExtend: true, color: AppColors.habitsColor[habit.colorCode]),
                    const SizedBox(width: 10),
                    Text(habit.habit),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedHabit = value;
              });
            }),
      ),
      action: <Widget>[
        TextButton(child: const Text('Cancelar'), onPressed: () => navigatePop()),
        TextButton(
            child: const Text('Competir', style: TextStyle(fontWeight: FontWeight.bold)), onPressed: acceptRequest),
      ],
    );
  }
}
