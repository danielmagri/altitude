import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:cloud_functions/cloud_functions.dart' show CloudFunctions, CloudFunctionsException, HttpsCallableResult;
import 'package:altitude/core/services/FireMenssaging.dart';

class FireFunctions {
  Future<bool> newUser(String name, String email, int score) async {
    Person person = Person(name: name, email: email, score: score, fcmToken: await FireMessaging().getToken());

    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'newUser').call(person.toJson());
      return true;
    } catch (error) {
      handleError(error, from: "newUser");
      return false;
    }
  }

  Future<bool> setScore(int score, Map<String, int> competitions, Map<String, int> oldScores) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("score", () => score);
    map.putIfAbsent("competitions", () => competitions);
    map.putIfAbsent("old_scores", () => oldScores);

    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'updateUser').call(map);
      return true;
    } catch (error) {
      handleError(error, from: "setScore");
      return false;
    }
  }

  Future<bool> updateUser(List<String> competitions, {String name, int color}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("display_name", () => name);
    map.putIfAbsent("color", () => color);
    map.putIfAbsent("competitions", () => competitions);

    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'updateUser').call(map);
      return true;
    } catch (error) {
      handleError(error, from: "updateUser");
      return false;
    }
  }

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

  Future<void> friendRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'friendRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "friendRequest");
      throw error;
    }
  }

  Future<void> acceptRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'acceptRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "acceptRequest");
      throw error;
    }
  }

  Future<void> declineRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'declineRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "declineRequest");
      throw error;
    }
  }

  Future<void> cancelFriendRequest(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'cancelFriendRequest').call(person.toJson());
    } catch (error) {
      handleError(error, from: "cancelFriendRequest");
      throw error;
    }
  }

  Future<void> removeFriend(String uid) async {
    Person person = new Person(uid: uid);
    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'removeFriend').call(person.toJson());
    } catch (error) {
      handleError(error, from: "removeFriend");
      throw error;
    }
  }

  // Competition

  Future<String> createCompetition(String title, int initialDate, Competitor competitor, List<String> invitations,
      List<String> invitationsToken) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent(Competition.TITLE, () => title);
    map.putIfAbsent(Competition.INITIAL_DATE, () => initialDate);
    map.putIfAbsent(Competitor.NAME, () => competitor.name);
    map.putIfAbsent(Competitor.FCM_TOKEN, () => competitor.fcmToken);
    map.putIfAbsent(Competitor.SCORE, () => competitor.score);
    map.putIfAbsent(Competitor.COLOR, () => competitor.color);
    map.putIfAbsent("invitations", () => invitations);
    map.putIfAbsent("invitations_token", () => invitationsToken);

    try {
      HttpsCallableResult result =
          await CloudFunctions.instance.getHttpsCallable(functionName: 'createCompetition').call(map);

      return result.data;
    } catch (error) {
      handleError(error, from: "createCompetition");
      throw error;
    }
  }

  Future<bool> updateCompetition(String id, String title) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("title", () => title);

    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'updateCompetition').call(map);

      return true;
    } catch (error) {
      handleError(error, from: "updateCompetition");
      throw error;
    }
  }

  Future<bool> addCompetitor(String id, String name, List<String> invitations, List<String> invitationsToken) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("display_name", () => name);
    map.putIfAbsent("invitations", () => invitations);
    map.putIfAbsent("invitations_token", () => invitationsToken);

    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'addCompetitor').call(map);

      return true;
    } catch (error) {
      handleError(error, from: "addCompetitor");
      throw error;
    }
  }

  Future<bool> removeCompetitor(String id, String uidCompetitor) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent("id", () => id);
    map.putIfAbsent("uid", () => uidCompetitor);

    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'removeCompetitor').call(map);

      return true;
    } catch (error) {
      handleError(error, from: "removeCompetitor");
      throw error;
    }
  }

  Future<List<Competition>> getPendingCompetitions() async {
    // try {
    //   HttpsCallableResult result =
    //       await CloudFunctions.instance.getHttpsCallable(functionName: 'getPendingCompetitions').call();

    //   List data = result.data;

    //   return data.map((c) => Competition.fromLinkedJson(c)).toList();
    // } catch (error) {
    //   handleError(error, from: "getPendingCompetitions");
      return null;
    // }
  }

  Future<int> acceptCompetitionRequest(String id, String name, String fcmToken, int color, int score) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent(Competition.ID, () => id);
    map.putIfAbsent(Competitor.NAME, () => name);
    map.putIfAbsent(Competitor.FCM_TOKEN, () => fcmToken);
    map.putIfAbsent(Competitor.SCORE, () => score);
    map.putIfAbsent(Competitor.COLOR, () => color);

    try {
      HttpsCallableResult result =
          await CloudFunctions.instance.getHttpsCallable(functionName: 'acceptCompetitionRequest').call(map);

      return result.data;
    } catch (error) {
      handleError(error, from: "declineCompetitionRequest");
      throw error;
    }
  }

  Future<void> declineCompetitionRequest(String id) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent(Competition.ID, () => id);

    try {
      await CloudFunctions.instance.getHttpsCallable(functionName: 'declineCompetitionRequest').call(map);
    } catch (error) {
      handleError(error, from: "declineCompetitionRequest");
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
