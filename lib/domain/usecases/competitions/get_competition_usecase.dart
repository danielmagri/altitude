import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCompetitionUsecase extends BaseUsecase<String, Competition> {
  final ICompetitionsRepository _competitionsRepository;

  GetCompetitionUsecase(this._competitionsRepository);

  @override
  Future<Competition> getRawFuture(String params) async {
    return _competitionsRepository.getCompetition(params);
  }
}
