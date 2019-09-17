import 'package:firebase_auth/firebase_auth.dart';
import 'DataPreferences.dart';

class AuthDataControl {
  Future<bool> isLogged() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user != null ? true : false;
  }

  Future<String> getName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user != null ? user.displayName : DataPreferences().getName();
  }
  Future<void> setName(String name) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = name;
      user.updateProfile(info);
    }
  }

  Future<String> getEmail() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user != null ? user.email : "";
  }

  Future<String> getPhotoUrl() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user != null ? user.photoUrl : "";
  }
}
