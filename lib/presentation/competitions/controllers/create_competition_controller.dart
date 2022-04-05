import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/data_state.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/domain/usecases/competitions/create_competition_usecase.dart';
import 'package:altitude/domain/usecases/competitions/max_competitions_by_habit_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'create_competition_controller.g.dart';

@lazySingleton
class CreateCompetitionController = _CreateCompetitionControllerBase
    with _$CreateCompetitionController;

abstract class _CreateCompetitionControllerBase with Store {
  _CreateCompetitionControllerBase(
    this._createCompetitionUsecase,
    this._maxCompetitionsByHabitUsecase,
  );

  final CreateCompetitionUsecase _createCompetitionUsecase;
  final MaxCompetitionsByHabitUsecase _maxCompetitionsByHabitUsecase;

  @observable
  Habit? selectedHabit;

  @observable
  ObservableList<Person> selectedFriends = ObservableList();

  late List<Habit> habits;

  @action
  void selectHabit(Habit? value) {
    selectedHabit = value;
  }

  @action
  void addHabit(Habit value) {
    habits.add(value);
    selectedHabit = value;
  }

  @action
  void selectFriend(bool selected, Person friend) {
    selected ? selectedFriends.add(friend) : selectedFriends.remove(friend);
  }

  Future<Competition> createCompetition(String title) async {
    List<String> invitations =
        selectedFriends.map((person) => person.uid).toList();
    List<String> invitationsToken =
        selectedFriends.map((person) => person.fcmToken).toList();

    return _createCompetitionUsecase
        .call(
          CreateCompetitionParams(
            title: title,
            habit: selectedHabit!,
            invitations: invitations,
            invitationsToken: invitationsToken,
          ),
        )
        .resultComplete((data) => data, (error) => throw error);
  }

  Future<bool> checkHabitCompetitionLimit() => _maxCompetitionsByHabitUsecase
      .call(selectedHabit!.id!)
      .resultComplete((data) => data, (error) => true);
}
