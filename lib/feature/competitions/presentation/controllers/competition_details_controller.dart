import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'competition_details_controller.g.dart';

@LazySingleton()
class CompetitionDetailsController = _CompetitionDetailsControllerBase with _$CompetitionDetailsController;

abstract class _CompetitionDetailsControllerBase with Store {
  final PersonUseCase? personUseCase;
  final CompetitionUseCase? _competitionUseCase;

  @observable
  String? title = "";

  Competition? competition;

  _CompetitionDetailsControllerBase(this.personUseCase, this._competitionUseCase);

  Future<List<Person>> getFriends() async {
    return (await personUseCase!.getFriends()).absoluteResult();
  }

  Future leaveCompetition(String? id) {
    return _competitionUseCase!.removeCompetitor(competition);
  }

  @action
  Future changeTitle(String? id, String newTitle) async {
    (await _competitionUseCase!.updateCompetition(id, newTitle)).result((data) {
      title = newTitle;
      return true;
    }, (error) => throw error);
  }
}
