import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompetitionsUsecase extends BaseUsecase<bool, List<Competition>> {
  final ICompetitionsRepository _competitionsRepository;

  GetCompetitionsUsecase(this._competitionsRepository);

  @override
  Future<List<Competition>> getRawFuture(bool params) {
    return _competitionsRepository.getCompetitions(params);
  }
}
