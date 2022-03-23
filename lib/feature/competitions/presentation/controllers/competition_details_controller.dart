import 'package:altitude/common/domain/usecases/friends/get_friends_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/feature/competitions/domain/usecases/remove_competitor_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/update_competition_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'competition_details_controller.g.dart';

@LazySingleton()
class CompetitionDetailsController = _CompetitionDetailsControllerBase
    with _$CompetitionDetailsController;

abstract class _CompetitionDetailsControllerBase with Store {
  final GetFriendsUsecase _getFriendsUsecase;
  final RemoveCompetitorUsecase _removeCompetitorUsecase;
  final UpdateCompetitionUsecase _updateCompetitorUsecase;

  _CompetitionDetailsControllerBase(this._getFriendsUsecase,
      this._removeCompetitorUsecase, this._updateCompetitorUsecase);

  @observable
  String? title = "";

  Competition? competition;

  Future<List<Person>> getFriends() async {
    return (await _getFriendsUsecase.call()).absoluteResult();
  }

  Future leaveCompetition(String? id) {
    return _removeCompetitorUsecase.call(competition);
  }

  @action
  Future changeTitle(String id, String newTitle) async {
    (await _updateCompetitorUsecase.call(UpdateCompetitionParams(
      competitionId: id,
      title: newTitle,
    )))
        .result((data) {
      title = newTitle;
      return true;
    }, (error) => throw error);
  }
}
