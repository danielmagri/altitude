import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCompetitionUsecase
    extends BaseUsecase<UpdateCompetitionParams, void> {
  UpdateCompetitionUsecase(this._competitionsRepository);

  final ICompetitionsRepository _competitionsRepository;

  @override
  Future<void> getRawFuture(UpdateCompetitionParams params) async {
    await _competitionsRepository.updateCompetition(
      params.competitionId,
      params.title,
    );
  }
}

class UpdateCompetitionParams {
  UpdateCompetitionParams({required this.competitionId, required this.title});

  final String competitionId;
  final String title;
}
