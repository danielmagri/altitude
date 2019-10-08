import 'package:cloud_functions/cloud_functions.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/services/FireMenssaging.dart';

class FireFunctions {
  Future<bool> newUser(String name, String email, int score) async {
    Person person = new Person(
        name: name,
        email: email,
        score: score,
        fcmToken: await FireMessaging().getToken());

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'newUser')
          .call(person.toJson());
      return true;
    } on CloudFunctionsException catch (e) {
      print("newUser: ${e.message}");
      return false;
    }
  }

  Future<bool> updateUser({String name, int score}) async {
    Person person = new Person(name: name, score: score);

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'updateUser')
          .call(person.toJson());
      return true;
    } on CloudFunctionsException catch (e) {
      print("updateUser: ${e.message}");
      return false;
    }
  }

  Future<List<Person>> getFriends() async {
    try {
      HttpsCallableResult result = await CloudFunctions.instance
          .getHttpsCallable(functionName: 'getFriends')
          .call();

      List data = result.data;

      return data.map((c) => Person.fromJson(c)).toList();
    } on CloudFunctionsException catch (e) {
      print("getFriends: ${e.message}");
      return null;
    } on Exception catch (e) {
      print("getFriends: $e");
      return null;
    }
  }

  Future<List<Person>> getPendingFriends() async {
    try {
      HttpsCallableResult result = await CloudFunctions.instance
          .getHttpsCallable(functionName: 'getPendingFriends')
          .call();

      List data = result.data;

      return data.map((c) => Person.fromJson(c)).toList();
    } on CloudFunctionsException catch (e) {
      print("getPendingFriends: ${e.message}");
      return null;
    } on Exception catch (e) {
      print("getPendingFriends: $e");
      return null;
    }
  }

  Future<List<Person>> searchEmail(String email) async {
    Person person = new Person(email: email);
    try {
      HttpsCallableResult result = await CloudFunctions.instance
          .getHttpsCallable(functionName: 'searchEmail')
          .call(person.toJson());

      List data = result.data;

      return data.map((c) => Person.fromJson(c)).toList();
    } on CloudFunctionsException catch (e) {
      print("searchEmail: ${e.message}");
      return null;
    } on Exception catch (e) {
      print("searchEmail: $e");
      return null;
    }
  }

  Future<void> friendRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'friendRequest')
          .call(person.toJson());

    } on CloudFunctionsException catch (e) {
      print("friendRequest: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("friendRequest: $e");
      return null;
    }
  }

  Future<void> acceptRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'acceptRequest')
          .call(person.toJson());

    } on CloudFunctionsException catch (e) {
      print("acceptRequest: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("acceptRequest: $e");
      return null;
    }
  }

  Future<void> declineRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'declineRequest')
          .call(person.toJson());

    } on CloudFunctionsException catch (e) {
      print("declineRequest: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("declineRequest: $e");
      return null;
    }
  }

  Future<void> cancelFriendRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'cancelFriendRequest')
          .call(person.toJson());

    } on CloudFunctionsException catch (e) {
      print("cancelFriendRequest: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("cancelFriendRequest: $e");
      return null;
    }
  }
}