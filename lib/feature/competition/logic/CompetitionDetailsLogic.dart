import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:mobx/mobx.dart';
part 'CompetitionDetailsLogic.g.dart';

class CompetitionDetailsLogic = _CompetitionDetailsLogicBase with _$CompetitionDetailsLogic;

abstract class _CompetitionDetailsLogicBase with Store {
  final PersonUseCase personUseCase = PersonUseCase.getInstance;
  
  @observable
  String title = "";

  Future<List<Person>> getFriends() {
    return personUseCase.getFriends();
  }

  Future<bool> leaveCompetition(String id) async {
    return CompetitionsControl().removeCompetitor(id, personUseCase.uid);
  }

  @action
  Future<bool> changeTitle(String id, String newTitle) async {
    var result = await CompetitionsControl().updateCompetition(id, newTitle);
    if (result) title = newTitle;
    return result;
  }
}
