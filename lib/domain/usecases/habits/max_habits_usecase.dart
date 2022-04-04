import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/constant/constants.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MaxHabitsUsecase extends BaseUsecase<NoParams, bool> {
  MaxHabitsUsecase(this._habitsRepository);

  final IHabitsRepository _habitsRepository;

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
