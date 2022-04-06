import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/constant/constants.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/model/data_state.dart';
import 'package:altitude/common/view/dialog/base_dialog.dart';
import 'package:altitude/common/view/generic/rocket.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/domain/models/competitor_entity.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/domain/usecases/competitions/accept_competition_request_usecase.dart';
import 'package:altitude/domain/usecases/competitions/max_competitions_by_habit_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_days_done_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:flutter/material.dart'
    show
        Container,
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
  const ChooseHabit({
    required this.competition,
    required this.habits,
    Key? key,
  }) : super(key: key);

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
  final IScoreService _scoreService = GetIt.I.get<IScoreService>();

  Habit? selectedHabit;

  Future<void> acceptRequest() async {
    if (await _maxCompetitionsByHabitUsecase
        .call(selectedHabit!.id)
        .resultComplete((data) => data, (error) => true)) {
      showToast(
        'O hábito já faz parte de $maxHabitCompetitions competições.',
      );
    } else {
      showLoading(true);
      List<DateTime?> days = (await _getDaysDoneUsecase
              .call(
                GetDaysDoneParams(
                  id: selectedHabit!.id,
                  start: widget.competition.initialDate,
                  end: DateTime.now().onlyDate,
                ),
              )
              .resultComplete((data) => data, (error) => throw error))
          .map((e) => e.date)
          .toList();

      Person? user = await _getUserDataUsecase
          .call(false)
          .resultComplete((data) => data, (error) => null);

      Competitor competitor = Competitor(
        name: user?.name ?? '',
        fcmToken: user?.fcmToken ?? '',
        color: selectedHabit!.colorCode,
        habitId: selectedHabit!.id,
        uid: GetIt.I.get<IFireAuth>().getUid(),
        score: _scoreService.scoreEarnedTotal(selectedHabit!.frequency, days),
        you: true,
      );
      _acceptCompetitionRequestUsecase
          .call(
        AcceptCompetitionRequestParams(
          competitionId: widget.competition.id,
          competition: widget.competition,
          competitor: competitor,
        ),
      )
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
          hint: const Text('Escolher o hábito'),
          items: widget.habits.map((habit) {
            return DropdownMenuItem(
              value: habit,
              child: Row(
                children: [
                  Rocket(
                    size: const Size(30, 30),
                    isExtend: true,
                    color: AppColors.habitsColor[habit.colorCode],
                  ),
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
          },
        ),
      ),
      action: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => navigatePop(),
        ),
        TextButton(
          child: const Text(
            'Competir',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: acceptRequest,
        ),
      ],
    );
  }
}
