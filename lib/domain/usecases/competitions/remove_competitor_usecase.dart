import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveCompetitorUsecase extends BaseUsecase<Competition, void> {
  RemoveCompetitorUsecase(this._competitionsRepository);

  final ICompetitionsRepository _competitionsRepository;

  @override
  Future<void> getRawFuture(Competition params) async {
    await _competitionsRepository.removeCompetitor(params);
  }
}
