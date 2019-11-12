import 'package:cloud_functions/cloud_functions.dart';
import 'package:habit/objects/Competition.dart';
import 'package:habit/objects/Competitor.dart';
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

  Future<bool> setScore(int score, Map<String, int> competitions) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("score", () => score);
    map.putIfAbsent("competitions", () => competitions);

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'updateUser')
          .call(map);
      return true;
    } on CloudFunctionsException catch (e) {
      print("updateUser: ${e.message}");
      return false;
    }
  }

  Future<bool> updateUser(List<String> competitions,
      {String name, int color}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("display_name", () => name);
    map.putIfAbsent("color", () => color);
    map.putIfAbsent("competitions", () => competitions);

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'updateUser')
          .call(map);
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

  Future<void> removeFriend(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'removeFriend')
          .call(person.toJson());
    } on CloudFunctionsException catch (e) {
      print("removeFriend: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("removeFriend: $e");
      return null;
    }
  }

  // Competition

  Future<String> createCompetition(String title, Competitor competitor,
      List<String> invitations, List<String> invitationsToken) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent(Competition.TITLE, () => title);
    map.putIfAbsent(Competitor.NAME, () => competitor.name);
    map.putIfAbsent(Competitor.SCORE, () => competitor.score);
    map.putIfAbsent(Competitor.COLOR, () => competitor.color);
    map.putIfAbsent("invitations", () => invitations);
    map.putIfAbsent("invitations_token", () => invitationsToken);

    try {
      HttpsCallableResult result = await CloudFunctions.instance
          .getHttpsCallable(functionName: 'createCompetition')
          .call(map);

      return result.data;
    } on CloudFunctionsException catch (e) {
      print("createCompetition: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("createCompetition: $e");
      throw e;
    }
  }

  Future<bool> updateCompetition(String id, String title) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("title", () => title);

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'updateCompetition')
          .call(map);

      return true;
    } on CloudFunctionsException catch (e) {
      print("updateCompetition: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("updateCompetition: $e");
      throw e;
    }
  }

  Future<Competition> getCompetitionDetail(String id) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("id", () => id);

    try {
      HttpsCallableResult result = await CloudFunctions.instance
          .getHttpsCallable(functionName: 'getCompetitionDetail')
          .call(map);

      print(result.data);
      return Competition.fromLinkedJson(result.data);
    } on CloudFunctionsException catch (e) {
      print("getCompetitionDetail: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("getCompetitionDetail: $e");
      throw e;
    }
  }

  Future<bool> addCompetitor(String id, String name, List<String> invitations,
      List<String> invitationsToken) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("display_name", () => name);
    map.putIfAbsent("invitations", () => invitations);
    map.putIfAbsent("invitations_token", () => invitationsToken);

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'addCompetitor')
          .call(map);

      return true;
    } on CloudFunctionsException catch (e) {
      print("addCompetitor: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("addCompetitor: $e");
      throw e;
    }
  }

  Future<bool> removeCompetitor(String id, String uidCompetitor) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("uid", () => uidCompetitor);

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'removeCompetitor')
          .call(map);

      return true;
    } on CloudFunctionsException catch (e) {
      print("removeCompetitor: ${e.message}");
      throw e;
    } on Exception catch (e) {
      print("removeCompetitor: $e");
      throw e;
    }
  }
}
