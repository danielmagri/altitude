import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:mobx/mobx.dart';
part 'PendingCompetitionLogic.g.dart';

class PendingCompetitionLogic = _PendingCompetitionLogicBase with _$PendingCompetitionLogic;

abstract class _PendingCompetitionLogicBase with Store {
  final CompetitionUseCase _competitionUseCase = CompetitionUseCase.getInstance;
  final HabitUseCase _habitUseCase = HabitUseCase.getInstance;

  DataState<ObservableList<Competition>> pendingCompetition = DataState();
  List<Competition> addedCompetitions = [];

  Future<void> fetchData() async {
    try {
      var _pendingCompetition = (await _competitionUseCase.getPendingCompetitions()).absoluteResult().asObservable();

      _competitionUseCase.pendingCompetitionsStatus = _pendingCompetition.isNotEmpty;

      pendingCompetition.setData(_pendingCompetition);
    } catch (error) {
      pendingCompetition.setError(error);
      throw error;
    }
  }

  Future<bool> checkCreateCompetition() => _competitionUseCase.maximumNumberReached();

  Future<List<Habit>> getAllHabits() async {
    return (await _habitUseCase.getHabits()).absoluteResult();
  }

  void acceptedCompetitionRequest(Competition competition) {
    pendingCompetition.data.removeWhere((item) => item.id == competition.id);
    addedCompetitions.add(competition);
    if (pendingCompetition.data.isEmpty) _competitionUseCase.pendingCompetitionsStatus = false;
  }

  Future declineCompetitionRequest(String id) async {
    return (await _competitionUseCase.declineCompetitionRequest(id)).result((data) {
      pendingCompetition.data.removeWhere((item) => item.id == id);

      if (pendingCompetition.data.isEmpty) _competitionUseCase.pendingCompetitionsStatus = false;
    }, (error) => throw error);
  }
}
