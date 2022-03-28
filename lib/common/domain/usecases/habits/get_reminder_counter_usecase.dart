import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';

class GetReminderCounterUsecase extends BaseUsecase<NoParams, int> {
  final Memory _memory;
  final GetUserDataUsecase _getUserDataUsecase;

  GetReminderCounterUsecase(this._memory, this._getUserDataUsecase);

  @override
  Future<int> getRawFuture(NoParams params) async {
    Person person = (await _getUserDataUsecase.call(false)).absoluteResult();
    _memory.person?.reminderCounter += 1;
    return person.reminderCounter;
  }
}
