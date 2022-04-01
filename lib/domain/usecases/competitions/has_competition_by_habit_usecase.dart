import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class HasCompetitionByHabitUsecase extends BaseUsecase<String, bool> {
  final ICompetitionsRepository _competitionsRepository;

  HasCompetitionByHabitUsecase(this._competitionsRepository);

  @override
  Future<bool> getRawFuture(String params) async {
    try {
      return await _competitionsRepository.getCompetitions(false).then((list) =>
          list.where((e) => e.getMyCompetitor().habitId == params).isNotEmpty);
    } catch (e) {
      return Future.value(false);
    }
  }
}
