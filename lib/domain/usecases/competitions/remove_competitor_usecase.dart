import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveCompetitorUsecase extends BaseUsecase<Competition, void> {
  final ICompetitionsRepository _competitionsRepository;

  RemoveCompetitorUsecase(this._competitionsRepository);

  @override
  Future<void> getRawFuture(Competition params) async {
    await _competitionsRepository.removeCompetitor(params);
  }
}
