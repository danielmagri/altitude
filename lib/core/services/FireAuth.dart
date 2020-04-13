import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuth {
  Future<bool> isLogged() async {
    return await FirebaseAuth.instance.currentUser() != null ? true : false;
  }

  Future<String> getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user != null ? user.uid : "";
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
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
