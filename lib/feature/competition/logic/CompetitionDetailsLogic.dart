import 'package:altitude/common/controllers/CompetitionsControl.dart';
import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:mobx/mobx.dart';
part 'CompetitionDetailsLogic.g.dart';

class CompetitionDetailsLogic = _CompetitionDetailsLogicBase with _$CompetitionDetailsLogic;

abstract class _CompetitionDetailsLogicBase with Store {
  @observable
  String title = "";

  Future<List<Person>> getFriends() {
    return UserControl().getFriends();
  }

  Future<bool> leaveCompetition(String id) async {
    return CompetitionsControl().removeCompetitor(id, await UserControl().getUid());
  }

  @action
  Future<bool> changeTitle(String id, String newTitle) async {
    var result = await CompetitionsControl().updateCompetition(id, newTitle);
    if (result) title = newTitle;
    return result;
  }
}
