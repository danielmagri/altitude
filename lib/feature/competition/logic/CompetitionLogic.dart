import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/core/model/pair.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'CompetitionLogic.g.dart';

@LazySingleton()
class CompetitionLogic = _CompetitionLogicBase with _$CompetitionLogic;

abstract class _CompetitionLogicBase with Store {
  final PersonUseCase? _personUseCase;
  final HabitUseCase? _habitUseCase;
  final CompetitionUseCase? _competitionUseCase;

  _CompetitionLogicBase(this._personUseCase, this._habitUseCase, this._competitionUseCase);

  @observable
  bool pendingStatus = false;

  DataState<List<Person>> ranking = DataState();
  DataState<ObservableList<Competition>> competitions = DataState();

  Future<void> fetchData() async {
    checkPendingFriendsStatus();

    fetchCompetitions();

    (await _personUseCase!.rankingFriends()).result((value) async {
      Person me = (await _personUseCase!.getPerson()).absoluteResult();
      me.you = true;
      value.add(me);
      value.sort((a, b) => -a.score!.compareTo(b.score!));
      if (value.length > 3) {
        value.removeAt(3);
      }
      ranking.setData(value);
    }, (error) {
      ranking.setError(error);
    });
  }

  void fetchCompetitions() async {
    (await _competitionUseCase!.getCompetitions()).result((data) {
      competitions.setData(data.asObservable());
    }, (error) {
      competitions.setError(error);
    });
  }

  Future<Competition> getCompetitionDetails(String? id) async {
    return (await _competitionUseCase!.getCompetition(id)).absoluteResult();
  }

  @action
  void checkPendingFriendsStatus() {
    pendingStatus = _competitionUseCase!.pendingCompetitionsStatus;
  }

  Future<bool> checkCreateCompetition() => _competitionUseCase!.maximumNumberReached();

  Future<Pair<List<Habit>, List<Person>>> getCreationData() async {
    List habits = (await _habitUseCase!.getHabits()).absoluteResult();
    List friends = (await _personUseCase!.getFriends()).absoluteResult();

    return Pair(habits as List<Habit>, friends as List<Person>);
  }

  @action
  Future exitCompetition(Competition competition) async {
    (await _competitionUseCase!.removeCompetitor(competition)).result((data) {
      competitions.data!.removeWhere((element) => element.id == competition.id);
    }, (error) => throw error);
  }
}
