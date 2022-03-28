import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuth implements IFireAuth {
  bool isLogged() {
    return FirebaseAuth.instance.currentUser != null ? true : false;
  }

  String getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : "";
  }

  String? getName() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.displayName : "";
  }

  Future<bool> setName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.updateProfile(displayName: name);
      return true;
    } else {
      return false;
    }
  }

  String? getEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email : "";
  }

  String? getPhotoUrl() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.photoURL : "";
  }

  Future<void> logout() async {
    // await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
