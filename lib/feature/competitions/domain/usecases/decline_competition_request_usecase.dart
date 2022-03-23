import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class DeclineCompetitionRequestUsecase extends BaseUsecase<String, void> {
  final IFireDatabase _fireDatabase;

  DeclineCompetitionRequestUsecase(this._fireDatabase);

  @override
  Future<void> getRawFuture(String params) async {
    await _fireDatabase.declineCompetitionRequest(params);
  }
}
