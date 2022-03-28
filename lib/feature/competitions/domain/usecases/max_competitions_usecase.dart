import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/core/base/base_usecase.dart';

class MaxCompetitionsUsecase extends BaseUsecase<NoParams, bool> {
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  MaxCompetitionsUsecase(this._getCompetitionsUsecase);

  @override
  Future<bool> getRawFuture(NoParams params) async {
    try {
      int length =
          (await _getCompetitionsUsecase.call(false)).absoluteResult().length;

      return length >= MAX_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
