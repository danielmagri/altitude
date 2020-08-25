import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
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

  DataState<List<Person>> ranking = DataState();
  DataState<ObservableList<CompetitionPresentation>> competitions = DataState();

  Future<bool> get isLogged async => UserControl().isLogged();

  Future<void> fetchData() async {
    checkPendingFriendsStatus();

    fetchCompetitions();

    UserControl().rankingFriends().then((value) async {
      value.add(Person(
          name: UserControl().getName(),
          email: UserControl().getEmail(),
          score: ScoreControl().score,
          you: true));
      value.sort((a, b) => -a.score.compareTo(b.score));
      if (value.length > 3) {
        value.removeAt(3);
      }
      ranking.setData(value);
    }).catchError((error) {
      ranking.setError(error);
    });
  }

  void fetchCompetitions() {
    CompetitionsControl().fetchCompetitions().then((value) {
      competitions.setData(value.asObservable());
    }).catchError((error) {
      competitions.setError(error);
    });
  }

  @action
  void checkPendingFriendsStatus() {
    pendingStatus = CompetitionsControl().pendingCompetitionsStatus;
  }

  Future<bool> checkCreateCompetition() async {
    return (await CompetitionsControl().competitionsCount) < MAX_COMPETITIONS;
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
    var res = await CompetitionsControl().removeCompetitor(id, UserControl().getUid());
    if (res) competitions.data.removeWhere((element) => element.id == id);

    return res;
  }
}
