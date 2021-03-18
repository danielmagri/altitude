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
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart'
    show
        Colors,
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

class ChooseHabit extends StatefulWidget {
  ChooseHabit({Key key, @required this.competition, @required this.habits}) : super(key: key);

  final Competition competition;
  final List<Habit> habits;

  @override
  _ChooseHabitState createState() => _ChooseHabitState();
}

class _ChooseHabitState extends BaseState<ChooseHabit> {
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;
  final HabitUseCase _habitUseCase = HabitUseCase.getInstance;
  final CompetitionUseCase _competitionUseCase = CompetitionUseCase.getInstance;

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
                  children: <Widget>[
                    Rocket(size: const Size(30, 30), isExtend: true, color: AppColors.habitsColor[habit.colorCode]),
                    const SizedBox(width: 10),
                    Text(habit.habit, style: const TextStyle(color: Colors.black)),
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
        TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.black)), onPressed: () => navigatePop()),
        TextButton(
            child: const Text('Competir', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            onPressed: acceptRequest),
      ],
    );
  }
}
