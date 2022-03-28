import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/infra/interface/i_score_service.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/view/dialog/BaseDialog.dart';
import 'package:altitude/common/view/generic/Rocket.dart';
import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/feature/competitions/domain/usecases/accept_competition_request_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/get_days_done_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart';
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
        Widget;
import 'package:get_it/get_it.dart';

class ChooseHabit extends StatefulWidget {
  ChooseHabit({Key? key, required this.competition, required this.habits})
      : super(key: key);

  final Competition competition;
  final List<Habit> habits;

  @override
  _ChooseHabitState createState() => _ChooseHabitState();
}

class _ChooseHabitState extends BaseState<ChooseHabit> {
  final MaxCompetitionsByHabitUsecase _maxCompetitionsByHabitUsecase =
      GetIt.I.get<MaxCompetitionsByHabitUsecase>();
  final GetUserDataUsecase _getUserDataUsecase =
      GetIt.I.get<GetUserDataUsecase>();
  final AcceptCompetitionRequestUsecase _acceptCompetitionRequestUsecase =
      GetIt.I.get<AcceptCompetitionRequestUsecase>();
  final GetDaysDoneUsecase _getDaysDoneUsecase =
      GetIt.I.get<GetDaysDoneUsecase>();
      final IScoreService _scoreService =
      GetIt.I.get<IScoreService>();

  Habit? selectedHabit;

  void acceptRequest() async {
    if (await _maxCompetitionsByHabitUsecase
        .call(selectedHabit!.id)
        .resultComplete((data) => data ?? true, (error) => true)) {
      showToast(
          "O hábito já faz parte de $MAX_HABIT_COMPETITIONS competições.");
    } else {
      showLoading(true);
      List<DateTime?> days = (await _getDaysDoneUsecase.call(GetDaysDoneParams(
              id: selectedHabit!.id,
              start: widget.competition.initialDate,
              end: DateTime.now().today)))
          .absoluteResult()
          .map((e) => e.date)
          .toList();

      Person? user = await _getUserDataUsecase
          .call(false)
          .resultComplete((data) => data, (error) => null);

      Competitor competitor = Competitor(
          name: user?.name,
          fcmToken: user?.fcmToken,
          color: selectedHabit!.colorCode,
          habitId: selectedHabit!.id,
          uid: GetIt.I.get<IFireAuth>().getUid(),
          score:
              _scoreService.scoreEarnedTotal(selectedHabit!.frequency!, days),
          you: true);
      _acceptCompetitionRequestUsecase
          .call(AcceptCompetitionRequestParams(
              competitionId: widget.competition.id ?? "",
              competition: widget.competition,
              competitor: competitor))
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
                  children: [
                    Rocket(
                        size: const Size(30, 30),
                        isExtend: true,
                        color: AppColors.habitsColor[habit.colorCode!]),
                    const SizedBox(width: 10),
                    Text(habit.habit!),
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
            child: const Text('Cancelar'), onPressed: () => navigatePop()),
        TextButton(
            child: const Text('Competir',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: acceptRequest),
      ],
    );
  }
}
