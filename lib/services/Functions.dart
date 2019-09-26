import 'package:cloud_functions/cloud_functions.dart';

class Functions {
  static const NAME = "display_name";
  static const EMAIL = "email";
  static const SCORE = "score";

  Future<bool> newUser(String name, String email, int score) async {
    Map data = {
      NAME: name,
      EMAIL: email,
      SCORE: score,
    };
    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'newUser')
          .call(data);
      return true;
    } on CloudFunctionsException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> updateUser({String name, int score}) async {
    Map data = {};
    if (name != null) {
      data.putIfAbsent(NAME, () => name);
    }
    if (score != null) {
      data.putIfAbsent(SCORE, () => score);
    }

    try {
      await CloudFunctions.instance
          .getHttpsCallable(functionName: 'updateUser')
          .call(data);
      return true;
    } on CloudFunctionsException catch (e) {
      print(e.message);
      return false;
    }
  }
}
