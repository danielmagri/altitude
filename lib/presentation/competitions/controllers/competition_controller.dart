import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/common/model/pair.dart';
import 'package:altitude/common/model/result.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/domain/usecases/competitions/get_competition_usecase.dart';
import 'package:altitude/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/domain/usecases/competitions/max_competitions_usecase.dart';
import 'package:altitude/domain/usecases/competitions/remove_competitor_usecase.dart';
import 'package:altitude/domain/usecases/friends/get_friends_usecase.dart';
import 'package:altitude/domain/usecases/friends/get_ranking_friends_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:data_state_mobx/data_state.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'competition_controller.g.dart';

@lazySingleton
class CompetitionController = _CompetitionControllerBase
    with _$CompetitionController;

abstract class _CompetitionControllerBase with Store {
  _CompetitionControllerBase(
    this._getHabitsUsecase,
    this._getRankingFriendsUsecase,
    this._getUserDataUsecase,
    this._getCompetitionsUsecase,
    this._getCompetitionUsecase,
    this._maxCompetitionsUsecase,
    this._sharedPref,
    this._removeCompetitorUsecase,
    this._getFriendsUsecase,
  );

  final GetHabitsUsecase _getHabitsUsecase;
  final GetRankingFriendsUsecase _getRankingFriendsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final GetCompetitionsUsecase _getCompetitionsUsecase;
  final GetCompetitionUsecase _getCompetitionUsecase;
  final MaxCompetitionsUsecase _maxCompetitionsUsecase;
  final RemoveCompetitorUsecase _removeCompetitorUsecase;
  final GetFriendsUsecase _getFriendsUsecase;
  final SharedPref _sharedPref;

  @observable
  bool pendingStatus = false;

  DataState<List<Person>> ranking = DataState();
  DataState<ObservableList<Competition>> competitions = DataState();

  Future<void> fetchData() async {
    checkPendingFriendsStatus();

    fetchCompetitions();

    (await _getRankingFriendsUsecase.call(3)).result((value) async {
      Person me = await _getUserDataUsecase
          .call(false)
          .resultComplete((data) => data, (error) => throw error);
      me.you = true;
      value.add(me);
      value.sort((a, b) => -a.score.compareTo(b.score));
      if (value.length > 3) {
        value.removeAt(3);
      }
      ranking.setSuccessState(value);
    }, (error) {
      ranking.setErrorState(error);
    });
  }

  Future<void> fetchCompetitions() async {
    (await _getCompetitionsUsecase.call(false)).result((data) {
      competitions.setSuccessState(data.asObservable());
    }, (error) {
      competitions.setErrorState(error);
    });
  }

  Future<Competition> getCompetitionDetails(String id) async {
    return _getCompetitionUsecase
        .call(id)
        .resultComplete((data) => data, (error) => throw error);
  }

  @action
  void checkPendingFriendsStatus() {
    pendingStatus = _sharedPref.pendingCompetition;
  }

  Future<bool> checkCreateCompetition() => _maxCompetitionsUsecase
      .call(NoParams())
      .resultComplete((data) => data, (error) => true);

  Future<Pair<List<Habit>, List<Person>>> getCreationData() async {
    final habits = await _getHabitsUsecase
        .call(false)
        .resultComplete((data) => data, (error) => throw error);
    final friends = await _getFriendsUsecase
        .call(NoParams())
        .resultComplete((data) => data, (error) => throw error);

    return Pair(habits, friends);
  }

  @action
  Future exitCompetition(Competition competition) async {
    (await _removeCompetitorUsecase.call(competition)).result(
      (data) {
        competitions.data!
            .removeWhere((element) => element.id == competition.id);
      },
      (error) => throw error,
    );
  }
}
