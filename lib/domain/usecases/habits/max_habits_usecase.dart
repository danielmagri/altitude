import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/no_params.dart';

class MaxHabitsUsecase extends BaseUsecase<NoParams, bool> {
  final IHabitsRepository _habitsRepository;

  MaxHabitsUsecase(this._habitsRepository);

  @override
  Future<bool> getRawFuture(NoParams params) async {
    try {
      int length = (await _habitsRepository.getHabits(false)).length;

      return length >= MAX_HABITS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
