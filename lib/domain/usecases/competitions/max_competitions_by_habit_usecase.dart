import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/constant/constants.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MaxCompetitionsByHabitUsecase extends BaseUsecase<String, bool> {
  MaxCompetitionsByHabitUsecase(
    this._competitionsRepository,
    this._userRepository,
  );

  final ICompetitionsRepository _competitionsRepository;
  final IUserRepository _userRepository;

  @override
  Future<bool> getRawFuture(String params) async {
    try {
      var userUid = await _userRepository
          .getUserData(false)
          .then((value) => value.uid ?? '');

      int length = await _competitionsRepository.getCompetitions(false).then(
            (list) => list
                .where((e) => e.getMyCompetitor(userUid).habitId == params)
                .length,
          );

      return length >= MAX_HABIT_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
