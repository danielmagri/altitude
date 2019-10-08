import 'package:firebase_messaging/firebase_messaging.dart';

class FireMessaging {
  void configure() {
    FirebaseMessaging().configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        });
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    return Future<void>.value();
  }

  Future<String> getToken() async {
    return await FirebaseMessaging().getToken();
  }
}
