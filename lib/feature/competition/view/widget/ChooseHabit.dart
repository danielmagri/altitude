import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart'
    show
        Colors,
        Container,
        CrossAxisAlignment,
        DropdownButton,
        DropdownMenuItem,
        EdgeInsets,
        FlatButton,
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
  Habit selectedHabit;

  void acceptRequest() async {
    if ((await CompetitionsControl().listCompetitionsIds(selectedHabit.oldId)).length >= MAX_HABIT_COMPETITIONS) {
      showToast("O hábito já faz parte de $MAX_HABIT_COMPETITIONS competições.");
    } else {
      showLoading(true);
      CompetitionsControl()
          .acceptCompetitionRequest(
              widget.competition.id, widget.competition.title, widget.competition.initialDate, selectedHabit.oldId)
          .then((_) {
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
        FlatButton(child: const Text('Cancelar'), onPressed: () => navigatePop()),
        FlatButton(
            child: const Text('Competir', style: TextStyle(fontWeight: FontWeight.bold)), onPressed: acceptRequest),
      ],
    );
  }
}
