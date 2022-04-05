import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class HasCompetitionByHabitUsecase extends BaseUsecase<String, bool> {
  HasCompetitionByHabitUsecase(
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
          .then((value) => value.uid);
      return await _competitionsRepository.getCompetitions(false).then(
            (list) => list
                .where((e) => e.getMyCompetitor(userUid).habitId == params)
                .isNotEmpty,
          );
    } catch (e) {
      return Future.value(false);
    }
  }
}
