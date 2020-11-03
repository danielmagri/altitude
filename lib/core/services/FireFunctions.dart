import 'package:cloud_functions/cloud_functions.dart' show CloudFunctions, CloudFunctionsException;

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

  void handleError(Object error, {String from = "Error"}) {
    if (error is CloudFunctionsException) {
      print("$from: ${error.message}");
    } else {
      print("$from: $error");
    }
  }
}
