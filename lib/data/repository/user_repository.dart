import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:injectable/injectable.dart';

abstract class IUserRepository {
  Future<Person> getUserData(bool fromServer);
  Future<void> updateFCMToken();
  Future<int> getReminderCounter();
  bool isLogged();
}

@Injectable(as: IUserRepository)
class UserRepository extends IUserRepository {
  final IFireMessaging _fireMessaging;
  final IFireDatabase _fireDatabase;
  final Memory _memory;
  final IFireAuth _fireAuth;

  UserRepository(
      this._memory, this._fireMessaging, this._fireDatabase, this._fireAuth);

  @override
  Future<Person> getUserData(bool fromServer) async {
    if (_memory.person == null || fromServer) {
      var data = await _fireDatabase.getPerson();
      data.photoUrl = _fireAuth.getPhotoUrl() ?? "";
      _memory.person = data;

      if (data.fcmToken != await _fireMessaging.getToken) {
        updateFCMToken();
      }

      return data;
    } else {
      return Future.value(_memory.person);
    }
  }

  @override
  Future<void> updateFCMToken() async {
    List<String> competitionsId =
        await _fireDatabase.getCompetitions().then((list) {
      _memory.competitions = list;
      return list.map((e) => e.id ?? '').toList();
    });

    final token = await _fireMessaging.getToken;

    await _fireDatabase.updateFcmToken(token, competitionsId);
    _memory.person?.fcmToken = token;
  }

  @override
  Future<int> getReminderCounter() async {
    Person person = await getUserData(false);
    _memory.person?.reminderCounter += 1;
    return person.reminderCounter;
  }

  @override
  bool isLogged() {
    return _fireAuth.isLogged();
  }
}
