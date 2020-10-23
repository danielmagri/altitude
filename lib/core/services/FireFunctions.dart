import 'package:altitude/common/model/Person.dart';
import 'package:cloud_functions/cloud_functions.dart' show CloudFunctions, CloudFunctionsException, HttpsCallableResult;

class FireFunctions {
  Future sendNotification(String title, String body, String token) async {
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'sendNotification')
          .call({"title": title, "body": body, "token": token});
    } catch (error) {
      handleError(error, from: "sendNotification");
      return null;
    }
  }

  @deprecated
  Future<List<Person>> getPendingFriends() async {
    try {
      HttpsCallableResult result =
          await CloudFunctions.instance.getHttpsCallable(functionName: 'getPendingFriends').call();

      List data = result.data;

      return data.map((c) => Person.fromJson(c)).toList();
    } catch (error) {
      handleError(error, from: "getPendingFriends");
      return null;
    }
  }

  @deprecated
  Future<void> friendRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'friendRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "friendRequest");
      throw error;
    }
  }

  @deprecated
  Future<void> acceptRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'acceptRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "acceptRequest");
      throw error;
    }
  }

  @deprecated
  Future<void> declineRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'declineRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "declineRequest");
      throw error;
    }
  }

  @deprecated
  Future<void> cancelFriendRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'cancelFriendRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "cancelFriendRequest");
      throw error;
    }
  }

  @deprecated
  Future<void> removeFriend(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'removeFriend').call(person.toJson());
    } catch (error) {
      handleError(error, from: "removeFriend");
      throw error;
    }
  }

  void handleError(Object error, {String from = "Error"}) {
    if (error is CloudFunctionsException) {
      print("$from: ${error.message}");
    } else {
      print("$from: $error");
    }
  }
}
