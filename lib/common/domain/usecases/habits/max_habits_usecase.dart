import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/common/base/base_usecase.dart';

class MaxHabitsUsecase extends BaseUsecase<NoParams, bool> {
  final GetHabitsUsecase _getHabitsUsecase;

  MaxHabitsUsecase(this._getHabitsUsecase);

  @override
  Future<bool> getRawFuture(NoParams params) async {
    try {
      int length =
          (await _getHabitsUsecase.call(false)).absoluteResult().length;

      return length >= MAX_HABITS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
