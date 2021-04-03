import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';

@service
@Injectable(as: IFireFunctions)
class FireFunctions implements IFireFunctions {
  Future sendNotification(String title, String body, String token) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('sendNotification')
          .call({"title": title, "body": body, "token": token});
    } catch (error) {
      _handleError(error, from: "sendNotification");
      return null;
    }
  }

  void _handleError(Object error, {String from = "Error"}) {
    if (error is FirebaseFunctionsException) {
      print("$from: ${error.message}");
    } else {
      print("$from: $error");
    }
  }
}
