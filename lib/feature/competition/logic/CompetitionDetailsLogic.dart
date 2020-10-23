import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:mobx/mobx.dart';
part 'CompetitionDetailsLogic.g.dart';

class CompetitionDetailsLogic = _CompetitionDetailsLogicBase with _$CompetitionDetailsLogic;

abstract class _CompetitionDetailsLogicBase with Store {
  final PersonUseCase personUseCase = PersonUseCase.getInstance;
  final CompetitionUseCase _competitionUseCase = CompetitionUseCase.getInstance;

  @observable
  String title = "";

  Competition competition;

  Future<List<Person>> getFriends() async {
    return (await personUseCase.getFriends()).absoluteResult();
  }

  Future leaveCompetition(String id) {
    return _competitionUseCase.removeCompetitor(competition);
  }

  @action
  Future changeTitle(String id, String newTitle) async {
    (await _competitionUseCase.updateCompetition(id, newTitle)).result((data) {
      title = newTitle;
      return true;
    }, (error) => throw error);
  }
}
