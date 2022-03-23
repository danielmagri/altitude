import 'package:altitude/common/domain/usecases/competitions/get_competition_usecase.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/domain/usecases/friends/get_friends_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/model/pair.dart';
import 'package:altitude/feature/competitions/domain/usecases/get_ranking_friends_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/remove_competitor_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'competition_controller.g.dart';

@LazySingleton()
class CompetitionController = _CompetitionControllerBase
    with _$CompetitionController;

abstract class _CompetitionControllerBase with Store {
  final GetHabitsUsecase _getHabitsUsecase;
  final GetRankingFriendsUsecase _getRankingFriendsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final GetCompetitionsUsecase _getCompetitionsUsecase;
  final GetCompetitionUsecase _getCompetitionUsecase;
  final MaxCompetitionsUsecase _maxCompetitionsUsecase;
  final RemoveCompetitorUsecase _removeCompetitorUsecase;
  final GetFriendsUsecase _getFriendsUsecase;
  final SharedPref _sharedPref;

  _CompetitionControllerBase(
      this._getHabitsUsecase,
      this._getRankingFriendsUsecase,
      this._getUserDataUsecase,
      this._getCompetitionsUsecase,
      this._getCompetitionUsecase,
      this._maxCompetitionsUsecase,
      this._sharedPref,
      this._removeCompetitorUsecase,
      this._getFriendsUsecase);

  @observable
  bool pendingStatus = false;

  DataState<List<Person>> ranking = DataState();
  DataState<ObservableList<Competition>> competitions = DataState();

  Future<void> fetchData() async {
    checkPendingFriendsStatus();

    fetchCompetitions();

    (await _getRankingFriendsUsecase.call(3)).result((value) async {
      Person me = (await _getUserDataUsecase.call(false)).absoluteResult();
      me.you = true;
      value.add(me);
      value.sort((a, b) => -a.score!.compareTo(b.score!));
      if (value.length > 3) {
        value.removeAt(3);
      }
      ranking.setSuccessState(value);
    }, (error) {
      ranking.setErrorState(error);
    });
  }

  void fetchCompetitions() async {
    (await _getCompetitionsUsecase.call(false)).result((data) {
      competitions.setSuccessState(data.asObservable());
    }, (error) {
      competitions.setErrorState(error);
    });
  }

  Future<Competition> getCompetitionDetails(String? id) async {
    return (await _getCompetitionUsecase.call(id)).absoluteResult();
  }

  @action
  void checkPendingFriendsStatus() {
    pendingStatus = _sharedPref.pendingCompetition;
  }

  Future<bool> checkCreateCompetition() => _maxCompetitionsUsecase
      .call()
      .resultComplete((data) => data ?? true, (error) => true);

  Future<Pair<List<Habit>, List<Person>>> getCreationData() async {
    List habits = (await _getHabitsUsecase.call()).absoluteResult();
    List friends = (await _getFriendsUsecase.call()).absoluteResult();

    return Pair(habits as List<Habit>, friends as List<Person>);
  }

  @action
  Future exitCompetition(Competition competition) async {
    (await _removeCompetitorUsecase.call(competition)).result((data) {
      competitions.data!.removeWhere((element) => element.id == competition.id);
    }, (error) => throw error);
  }
}
