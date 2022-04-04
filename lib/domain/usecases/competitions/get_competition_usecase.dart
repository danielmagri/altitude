import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompetitionUsecase extends BaseUsecase<String, Competition> {
  GetCompetitionUsecase(this._competitionsRepository);

  final ICompetitionsRepository _competitionsRepository;

  @override
  Future<Competition> getRawFuture(String params) async {
    return _competitionsRepository.getCompetition(params);
  }
}
