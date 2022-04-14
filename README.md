# Altitude

Track your habits progress like a rocket taking off with this app, and create competitions with your friends to know who is better.

> The app has been downloaded over 10,000 times on the [Play Store](https://play.google.com/store/apps/details?id=com.magrizo.habit)

![screenshot1](https://play-lh.googleusercontent.com/4O9Mqp3sKbE8epAnOkBoUWI8zcXG0dzCpjWMOdOiy5zMGezBGs5UhvJsjNPkakA0nk8=w720-h310-rw)
![screenshot2](https://play-lh.googleusercontent.com/3OXiIqSeJUNG8flJPTZ3C9H0RHro9Bve-F7c7T1ivckaZevJ7o-w7GDzCY7uX7gMVA=w720-h310-rw)
![screenshot3](https://play-lh.googleusercontent.com/gEKXsGlip2jXYBV_ZELMDWJF2L1A07vn-zmnMmNWQuwH1YYhlCHvMLd1MxatCV_E7w=w720-h310-rw)

## Technologies

Project made with Flutter, using:

- [MobX](https://pub.dev/packages/mobx)
- [GetIt](https://pub.dev/packages/get_it)
- [facebook](https://pub.dev/packages/flutter_facebook_login) / [google](https://pub.dev/packages/google_sign_in) sign in
- Firebase ([auth](https://pub.dev/packages/firebase_auth_oauth), [analytics](https://pub.dev/packages/firebase_analytics), [messaging](https://pub.dev/packages/firebase_messaging), [crashlytics](https://pub.dev/packages/firebase_crashlytics))
- [DataState](https://pub.dev/packages/data_state_mobx)

## Architecture

| Folder | Description |
| ------ | ----------- |
| common | Shared files used by the entire application. |
| infra | Clean Architecture infra layer, handle access of external APIs. |
| data | Clean Architecture data layer, with the repositories that consume the endpoints and caches. |
| domain | Clean Architecture domain layer, with the models and usecases. |
| presentation | Clean Architecture presentation layer, responsible by the pages (with the controllers) and widgets. |

### Common

| Folder | Description |
| ------ | ----------- |
| base | Abstracts classes to create the base logic and methods of the layers (View, Usecase). |
| di | Main file to manage the dependency injection with Injectable. |
| inputs | Folder to centralize the text fields formatters and validators. |
| model | Generic and core models. |
| router | Hanlder navigation from pages. |
| theme | Light/Dark theme logic and values. |
| view | Generic and shared widgets. |

## Backend

Was used the firebase as backend, saving the data on Firestore and sending FCM notifications with Functions.

## Preview

You can get it on [Play Store](https://play.google.com/store/apps/details?id=com.magrizo.habit)
