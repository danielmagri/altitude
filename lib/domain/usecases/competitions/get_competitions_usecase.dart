import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompetitionsUsecase extends BaseUsecase<bool, List<Competition>> {
  GetCompetitionsUsecase(this._competitionsRepository);

  final ICompetitionsRepository _competitionsRepository;

  @override
  Future<List<Competition>> getRawFuture(bool params) {
    return _competitionsRepository.getCompetitions(params);
  }
}
