import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFireAuth)
class FireAuth implements IFireAuth {
  @override
  bool isLogged() {
    return FirebaseAuth.instance.currentUser != null ? true : false;
  }

  @override
  String getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : '';
  }

  @override
  String? getName() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.displayName : '';
  }

  @override
  Future<bool> setName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.updateProfile(displayName: name);
      return true;
    } else {
      return false;
    }
  }

  @override
  String? getEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email : '';
  }

  @override
  String? getPhotoUrl() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.photoURL : '';
  }

  @override
  Future<void> logout() async {
    // await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
