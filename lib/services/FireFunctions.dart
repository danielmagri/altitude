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
}
