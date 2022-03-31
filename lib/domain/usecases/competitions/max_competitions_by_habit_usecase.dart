import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/data_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MaxCompetitionsByHabitUsecase extends BaseUsecase<String, bool> {
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  MaxCompetitionsByHabitUsecase(this._getCompetitionsUsecase);

  @override
  Future<bool> getRawFuture(String params) async {
    try {
      int length = (await _getCompetitionsUsecase(false)
              .resultComplete((data) => data, (error) => throw error))
          .where((e) => e.getMyCompetitor().habitId == params)
          .length;

      return length >= MAX_HABIT_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
