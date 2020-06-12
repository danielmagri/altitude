import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
part 'LoginLogic.g.dart';

class LoginLogic = _LoginLogicBase with _$LoginLogic;

abstract class _LoginLogicBase with Store {
  Future<bool> loginFacebook() async {
    var result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
        AuthResult fireResult = await FirebaseAuth.instance.signInWithCredential(credential);
        FireAnalytics().analytics.setUserId(fireResult.user.uid);
        if (!await FireFunctions()
            .newUser(fireResult.user.displayName, fireResult.user.email, SharedPref.instance.score)) {
          await UserControl().logout();
          throw "Erro ao salvar os dados";
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        return false;
        break;  
      case FacebookLoginStatus.error:
        throw result.errorMessage;
        break;
    }
    return true;
  }

  Future<bool> loginGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    GoogleSignInAccount result = await googleSignIn.signIn();
    if (result != null) {
      GoogleSignInAuthentication googleAuth = await result.authentication;
      AuthCredential credential =
          GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      AuthResult fireResult = await FirebaseAuth.instance.signInWithCredential(credential);
      FireAnalytics().analytics.setUserId(fireResult.user.uid);
      if (!await FireFunctions()
          .newUser(fireResult.user.displayName, fireResult.user.email, SharedPref.instance.score)) {
        await UserControl().logout();
        throw "Erro ao salvar os dados";
      }
      return true;
    } else {
      return false;
    }
  }
}
