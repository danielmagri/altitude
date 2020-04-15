import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/CompetitionPresentation.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/core/model/Pair.dart';
import 'package:mobx/mobx.dart';
part 'CompetitionLogic.g.dart';

class CompetitionLogic = _CompetitionLogicBase with _$CompetitionLogic;

abstract class _CompetitionLogicBase with Store {
  @observable
  bool pendingStatus = false;

  DataState<ObservableList<CompetitionPresentation>> competitions = DataState();

  Future<bool> get isLogged async => await UserControl().isLogged();

  Future<void> fetchData() async {
    try {
      var _competitions = (await CompetitionsControl().listCompetitions()).asObservable();

      checkPendingFriendsStatus();
      competitions.setData(_competitions);
    } catch (error) {
      competitions.setError(error);
    }
  }

  @action
  void checkPendingFriendsStatus() {
    pendingStatus = CompetitionsControl().getPendingCompetitionsStatus();
  }

  Future<bool> checkCreateCompetition() async {
    return (await CompetitionsControl().listCompetitions()).length < MAX_COMPETITIONS;
  }

  Future<Pair<List<Habit>, List<Person>>> getCreationData() async {
    List habits = await HabitsControl().getAllHabits();
    List friends = await UserControl().getFriends();

    return Pair(habits, friends);
  }

  Future<Competition> getCompetitionDetail(String id) async {
    return CompetitionsControl().getCompetitionDetail(id);
  }

  void updateCompetitionTitle(String id, String newTitle) {
    CompetitionsControl().updateCompetitionDB(id, newTitle);
  }

  @action
  Future<bool> exitCompetition(String id) async {
    var res = await CompetitionsControl().removeCompetitor(id, await UserControl().getUid());

    if (res) competitions.data.removeWhere((element) => element.id == id);

    return res;
  }
}
