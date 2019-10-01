import 'package:cloud_functions/cloud_functions.dart';
import 'package:habit/objects/Person.dart';

class FireFunctions {

  Future<bool> newUser(String name, String email, int score) async {
    Person person = new Person(name: name, email: email, score: score);

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
}
