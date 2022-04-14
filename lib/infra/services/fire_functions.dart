import 'dart:developer' show log;

import 'package:altitude/infra/interface/i_fire_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFireFunctions)
class FireFunctions implements IFireFunctions {
  @override
  Future<void> sendNotification(String title, String body, String token) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('sendNotification')
          .call({'title': title, 'body': body, 'token': token});
    } catch (error) {
      _handleError(error, from: 'sendNotification');
      return;
    }
  }

  void _handleError(Object error, {String from = 'Error'}) {
    if (error is FirebaseFunctionsException) {
      log('$from: ${error.message}');
    } else {
      log('$from: $error');
    }
  }
}
