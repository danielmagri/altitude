import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateFCMTokenUsecase extends BaseUsecase<NoParams, void> {
  final IFireMessaging _fireMessaging;
  final IFireDatabase _fireDatabase;
  final Memory _memory;
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  UpdateFCMTokenUsecase(this._fireMessaging, this._fireDatabase, this._memory,
      this._getCompetitionsUsecase);

  @override
  Future<void> getRawFuture(NoParams params) async {
    List<String?> competitionsId = (await _getCompetitionsUsecase.call(true))
        .absoluteResult()
        .map((e) => e.id)
        .toList();
    final token = await _fireMessaging.getToken;

    await _fireDatabase.updateFcmToken(token, competitionsId);
    _memory.person?.fcmToken = token;
    return;
  }
}
