import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/feature/competitions/domain/usecases/create_competition_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'create_competition_controller.g.dart';

@LazySingleton()
class CreateCompetitionController = _CreateCompetitionControllerBase
    with _$CreateCompetitionController;

abstract class _CreateCompetitionControllerBase with Store {
  final CreateCompetitionUsecase _createCompetitionUsecase;
  final MaxCompetitionsByHabitUsecase _maxCompetitionsByHabitUsecase;

  @observable
  Habit? selectedHabit;

  @observable
  ObservableList<Person> selectedFriends = ObservableList();

  late List<Habit> habits;

  _CreateCompetitionControllerBase(
      this._createCompetitionUsecase, this._maxCompetitionsByHabitUsecase);

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
        selectedFriends.map((person) => person.uid ?? "").toList();
    List<String> invitationsToken =
        selectedFriends.map((person) => person.fcmToken ?? "").toList();

    return (await _createCompetitionUsecase.call(
      CreateCompetitionParams(
          title: title,
          habit: selectedHabit!,
          invitations: invitations,
          invitationsToken: invitationsToken),
    ))
        .absoluteResult();
  }

  Future<bool> checkHabitCompetitionLimit() => _maxCompetitionsByHabitUsecase
      .call(selectedHabit!.id)
      .resultComplete((data) => data ?? true, (error) => true);
}