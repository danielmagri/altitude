import 'package:altitude/domain/usecases/competitions/decline_competition_request_usecase.dart';
import 'package:altitude/domain/usecases/competitions/get_pending_competitions_usecase.dart';
import 'package:altitude/domain/usecases/competitions/max_competitions_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/core/model/failure.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/model/data_state.dart';
part 'pending_competition_controller.g.dart';

class PendingCompetitionController = _PendingCompetitionControllerBase
    with _$PendingCompetitionController;

abstract class _PendingCompetitionControllerBase with Store {
  final MaxCompetitionsUsecase _maxCompetitionsUsecase;
  final GetHabitsUsecase _getHabitsUsecase;
  final SharedPref _sharedPref;
  final GetPendingCompetitionsUsecase _getPendingCompetitionsUsecase;
  final DeclineCompetitionRequestUsecase _declineCompetitionRequestUsecase;

  _PendingCompetitionControllerBase(
      this._maxCompetitionsUsecase,
      this._getHabitsUsecase,
      this._sharedPref,
      this._getPendingCompetitionsUsecase,
      this._declineCompetitionRequestUsecase);

  DataState<ObservableList<Competition>> pendingCompetition = DataState();
  List<Competition> addedCompetitions = [];

  Future<void> fetchData() async {
    try {
      var _pendingCompetition = (await _getPendingCompetitionsUsecase
              .call(NoParams())
              .resultComplete((data) => data, (error) => throw error))
          .asObservable();

      _sharedPref.pendingCompetition = _pendingCompetition.isNotEmpty;

      pendingCompetition.setSuccessState(_pendingCompetition);
    } catch (error) {
      pendingCompetition.setErrorState(Failure.genericFailure(error));
      throw error;
    }
  }

  Future<bool> checkCreateCompetition() => _maxCompetitionsUsecase
      .call(NoParams())
      .resultComplete((data) => data, (error) => true);

  Future<List<Habit>> getAllHabits() async {
    return await _getHabitsUsecase
        .call(false)
        .resultComplete((data) => data, (error) => throw error);
  }

  void acceptedCompetitionRequest(Competition competition) {
    pendingCompetition.data!.removeWhere((item) => item.id == competition.id);
    addedCompetitions.add(competition);
    if (pendingCompetition.data!.isEmpty)
      _sharedPref.pendingCompetition = false;
  }

  Future declineCompetitionRequest(String id) async {
    return (await _declineCompetitionRequestUsecase.call(id)).result((data) {
      pendingCompetition.data!.removeWhere((item) => item.id == id);

      if (pendingCompetition.data!.isEmpty)
        _sharedPref.pendingCompetition = false;
    }, (error) => throw error);
  }
}
