import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/common/model/result.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/domain/usecases/competitions/remove_competitor_usecase.dart';
import 'package:altitude/domain/usecases/competitions/update_competition_usecase.dart';
import 'package:altitude/domain/usecases/friends/get_friends_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'competition_details_controller.g.dart';

@lazySingleton
class CompetitionDetailsController = _CompetitionDetailsControllerBase
    with _$CompetitionDetailsController;

abstract class _CompetitionDetailsControllerBase with Store {
  _CompetitionDetailsControllerBase(
    this._getFriendsUsecase,
    this._removeCompetitorUsecase,
    this._updateCompetitorUsecase,
  );

  final GetFriendsUsecase _getFriendsUsecase;
  final RemoveCompetitorUsecase _removeCompetitorUsecase;
  final UpdateCompetitionUsecase _updateCompetitorUsecase;

  @observable
  String? title = '';

  Competition? competition;

  Future<List<Person>> getFriends() async {
    return _getFriendsUsecase
        .call(NoParams())
        .resultComplete((data) => data, (error) => throw error);
  }

  Future leaveCompetition(String? id) {
    return _removeCompetitorUsecase.call(competition!);
  }

  @action
  Future changeTitle(String id, String newTitle) async {
    (await _updateCompetitorUsecase.call(
      UpdateCompetitionParams(
        competitionId: id,
        title: newTitle,
      ),
    ))
        .result(
      (data) {
        title = newTitle;
        return true;
      },
      (error) => throw error,
    );
  }
}
