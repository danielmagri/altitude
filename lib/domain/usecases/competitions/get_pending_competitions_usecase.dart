import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPendingCompetitionsUsecase
    extends BaseUsecase<NoParams, List<Competition>> {
  GetPendingCompetitionsUsecase(this._competitionsRepository);

  final ICompetitionsRepository _competitionsRepository;

  @override
  Future<List<Competition>> getRawFuture(NoParams params) async {
    return _competitionsRepository.getPendingCompetitions();
  }
}
