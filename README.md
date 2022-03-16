# Altitude

It's an app where you can add your habits to track them and participate in competitions with your friends.

> The app has been downloaded over 10,000 times on the Play Store

## Technologies

Project made with Flutter (v2.5), using:

- [mobx](https://pub.dev/packages/mobx) (State management)
- [get_it](https://pub.dev/packages/get_it) (Dependecy injections)
- [sqflite](https://pub.dev/packages/sqflite)
- [facebook](https://pub.dev/packages/flutter_facebook_login) / [google](https://pub.dev/packages/google_sign_in) login
- firebase ([auth](https://pub.dev/packages/firebase_auth_oauth), [analytics](https://pub.dev/packages/firebase_analytics), [messaging](https://pub.dev/packages/firebase_messaging), [crashlytics](https://pub.dev/packages/firebase_crashlytics))
- [mockito](https://pub.dev/packages/mockito) (Unit tests)

### Backend

Was used the firebase as backend, saving the data on Firestore and sending FCM notifications with Functions.


### Preview

You can get it on [Play Store](https://play.google.com/store/apps/details?id=com.magrizo.habit)
