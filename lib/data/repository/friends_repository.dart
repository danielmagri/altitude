import 'package:altitude/domain/models/person_entity.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:injectable/injectable.dart';

abstract class IFriendsRepository {
  Future<List<Person>> getFriends();
  Future<List<Person>> searchEmail(
    String email,
    List<String?> userPendingFriends,
  );
  Future<void> removeFriend(String friendUid);
  Future<List<Person>> getRankingFriends(int length);
  Future<List<Person>> getPendingFriends();
  Future<String> sendFriendRequest(String friendUid);
  Future<void> declineRequest(String friendUid);
  Future<void> cancelRequest(String friendUid);
  Future<String> acceptRequest(String friendUid);
}

@Injectable(as: IFriendsRepository)
class FriendsRepository extends IFriendsRepository {
  FriendsRepository(this._fireDatabase, this._fireAnalytics, this._memory);

  final IFireDatabase _fireDatabase;
  final IFireAnalytics _fireAnalytics;
  final Memory _memory;

  @override
  Future<List<Person>> getFriends() async {
    return _fireDatabase.getFriendsDetails();
  }

  @override
  Future<List<Person>> searchEmail(
    String email,
    List<String?> userPendingFriends,
  ) {
    return _fireDatabase.searchEmail(email, userPendingFriends);
  }

  @override
  Future<void> removeFriend(String friendUid) {
    return _fireDatabase.removeFriend(friendUid);
  }

  @override
  Future<List<Person>> getRankingFriends(int length) {
    return _fireDatabase.getRankingFriends(length);
  }

  @override
  Future<List<Person>> getPendingFriends() {
    return _fireDatabase.getPendingFriends();
  }

  @override
  Future<String> sendFriendRequest(String friendUid) {
    _fireAnalytics.sendFriendRequest(false);
    return _fireDatabase.friendRequest(friendUid).then((token) async {
      if (_memory.person != null) {
        _memory.person!.pendingFriends.add(friendUid);
      }
      return token;
    });
  }

  @override
  Future<void> declineRequest(String friendUid) {
    _fireAnalytics.sendFriendResponse(false);
    return _fireDatabase.declineRequest(friendUid);
  }

  @override
  Future<void> cancelRequest(String friendUid) {
    _fireAnalytics.sendFriendRequest(true);
    return _fireDatabase.cancelFriendRequest(friendUid).then((value) {
      if (_memory.person != null) {
        _memory.person!.pendingFriends.remove(friendUid);
      }
    });
  }

  @override
  Future<String> acceptRequest(String friendUid) {
    _fireAnalytics.sendFriendResponse(true);
    return _fireDatabase.acceptRequest(friendUid).then((token) async {
      if (_memory.person != null) {
        _memory.person!.friends.add(friendUid);
      }
      return token;
    });
  }
}
