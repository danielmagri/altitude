import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:mobx/mobx.dart';
part 'CreateCompetitionLogic.g.dart';

class CreateCompetitionLogic = _CreateCompetitionLogicBase with _$CreateCompetitionLogic;

abstract class _CreateCompetitionLogicBase with Store {
  @observable
  Habit selectedHabit;
  @observable
  ObservableList<Person> selectedFriends = ObservableList();

  List<Habit> habits;

  @action
  void selectHabit(Habit value) {
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

  Future<bool> checkHabitCompetitionLimit() async {
    //TODO:
    //return (await CompetitionsControl().listCompetitionsIds(selectedHabit.oldId)).length < MAX_HABIT_COMPETITIONS;
    return false;
  }

  Future<Competition> createCompetition(String title) {
    //TODO:
    // List<String> invitations = selectedFriends.map((person) => person.uid).toList();
    // List<String> invitationsToken = selectedFriends.map((person) => person.fcmToken).toList();

    // return CompetitionsControl().createCompetition(title, selectedHabit.oldId, invitations, invitationsToken);
  }
}
