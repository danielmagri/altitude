import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'LoginLogic.g.dart';

@LazySingleton()
class LoginLogic = _LoginLogicBase with _$LoginLogic;

abstract class _LoginLogicBase with Store {

  Future<String> loginFacebook() async {
    // var result = await FacebookLogin().logIn(['email', 'public_profile']);

    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
    //     UserCredential fireResult = await FirebaseAuth.instance.signInWithCredential(credential);
    //     return fireResult.user.uid;
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     return null;
    //     break;
    //   case FacebookLoginStatus.error:
    //     throw result.errorMessage;
    //     break;
    // }
    return null;
  }

  Future<String> loginGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount result = await googleSignIn.signIn();
    if (result != null) {
      GoogleSignInAuthentication googleAuth = await result.authentication;
      AuthCredential credential =
          GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      UserCredential fireResult = await FirebaseAuth.instance.signInWithCredential(credential);
      return fireResult.user.uid;
    } else {
      return null;
    }
  }

  
}
