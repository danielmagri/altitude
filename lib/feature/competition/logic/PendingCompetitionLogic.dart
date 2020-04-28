import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:mobx/mobx.dart';
part 'PendingCompetitionLogic.g.dart';

class PendingCompetitionLogic = _PendingCompetitionLogicBase with _$PendingCompetitionLogic;

abstract class _PendingCompetitionLogicBase with Store {
  DataState<ObservableList<Competition>> pendingCompetition = DataState();
  List<Competition> addedCompetitions = [];

  Future<void> fetchData() async {
    try {
      var _pendingCompetition = (await CompetitionsControl().getPendingCompetitions()).asObservable();

      CompetitionsControl().pendingCompetitionsStatus = _pendingCompetition.isNotEmpty;

      pendingCompetition.setData(_pendingCompetition);
    } catch (error) {
      pendingCompetition.setError(error);
      throw error;
    }
  }

  Future<bool> checkCreateCompetition() async {
    return (await CompetitionsControl().competitionsCount) < MAX_COMPETITIONS;
  }

  Future<List<Habit>> getAllHabits() async {
    return await HabitsControl().getAllHabits();
  }

  void acceptedCompetitionRequest(Competition competition) {
    pendingCompetition.data.removeWhere((item) => item.id == competition.id);
    addedCompetitions.add(competition);
    if (pendingCompetition.data.isEmpty) CompetitionsControl().pendingCompetitionsStatus = false;
  }

  Future<void> declineCompetitionRequest(String id) async {
    await CompetitionsControl().declineCompetitionRequest(id);
    pendingCompetition.data.removeWhere((item) => item.id == id);

    if (pendingCompetition.data.isEmpty) CompetitionsControl().pendingCompetitionsStatus = false;
  }
}
