import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FireAuth {
  Future<bool> isLogged() async {
    return await FirebaseAuth.instance.currentUser() != null ? true : false;
  }

  Future<String> getName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user != null ? user.displayName : "";
  }

  Future<bool> setName(String name) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = name;
      user.updateProfile(info);
      return true;
    } else {
      return false;
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

  Future<void> logout() async {
    await FacebookLogin().logOut();
    await FirebaseAuth.instance.signOut();
  }
}
