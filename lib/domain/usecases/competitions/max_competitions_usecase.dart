import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class MaxCompetitionsUsecase extends BaseUsecase<NoParams, bool> {
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  MaxCompetitionsUsecase(this._getCompetitionsUsecase);

  @override
  Future<bool> getRawFuture(NoParams params) async {
    try {
      int length = (await _getCompetitionsUsecase
              .call(false)
              .resultComplete((data) => data, (error) => throw error))
          .length;

      return length >= MAX_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
