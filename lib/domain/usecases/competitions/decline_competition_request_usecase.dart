import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeclineCompetitionRequestUsecase extends BaseUsecase<String, void> {
  final IFireDatabase _fireDatabase;

  DeclineCompetitionRequestUsecase(this._fireDatabase);

  @override
  Future<void> getRawFuture(String params) async {
    await _fireDatabase.declineCompetitionRequest(params);
  }
}
