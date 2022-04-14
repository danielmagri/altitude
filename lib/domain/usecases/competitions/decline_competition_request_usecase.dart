import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeclineCompetitionRequestUsecase extends BaseUsecase<String, void> {
  DeclineCompetitionRequestUsecase(this._competitionsRepository);

  final ICompetitionsRepository _competitionsRepository;

  @override
  Future<void> getRawFuture(String params) async {
    await _competitionsRepository.declineCompetitionRequest(params);
  }
}
