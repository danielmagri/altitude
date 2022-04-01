import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class MaxCompetitionsUsecase extends BaseUsecase<NoParams, bool> {
  final ICompetitionsRepository _competitionsRepository;

  MaxCompetitionsUsecase(this._competitionsRepository);

  @override
  Future<bool> getRawFuture(NoParams params) async {
    try {
      int length =
          (await _competitionsRepository.getCompetitions(false)).length;

      return length >= MAX_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
