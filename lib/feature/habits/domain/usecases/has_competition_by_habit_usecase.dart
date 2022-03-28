import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/base/base_usecase.dart';

class HasCompetitionByHabitUsecase extends BaseUsecase<String, bool> {
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  HasCompetitionByHabitUsecase(this._getCompetitionsUsecase);

  @override
  Future<bool> getRawFuture(String params) async {
    try {
      return (await _getCompetitionsUsecase(false))
          .absoluteResult()
          .where((e) => e.getMyCompetitor().habitId == params)
          .isNotEmpty;
    } catch (e) {
      return Future.value(false);
    }
  }
}
