import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class MaxCompetitionsByHabitUsecase extends BaseUsecase<String, bool> {
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  MaxCompetitionsByHabitUsecase(this._getCompetitionsUsecase);

  @override
  Future<bool> getRawFuture(String params) async {
    try {
      int length = (await _getCompetitionsUsecase(false))
          .absoluteResult()
          .where((e) => e.getMyCompetitor().habitId == params)
          .length;

      return length >= MAX_HABIT_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
