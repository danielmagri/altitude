import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
part 'LoginLogic.g.dart';

class LoginLogic = _LoginLogicBase with _$LoginLogic;

abstract class _LoginLogicBase with Store {
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;

  Future<bool> loginFacebook() async {
    var result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
        UserCredential fireResult = await FirebaseAuth.instance.signInWithCredential(credential);
        await setPersonData(fireResult.user.uid);
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
          GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      UserCredential fireResult = await FirebaseAuth.instance.signInWithCredential(credential);
      await setPersonData(fireResult.user.uid);
      return true;
    } else {
      return false;
    }
  }

  Future setPersonData(String uid) async {
    return (await _personUseCase.createPerson()).result((data) {
      FireAnalytics().analytics.setUserId(uid);
    }, (error) async {
      await _personUseCase.logout();
      throw "Erro ao salvar os dados";
    });
  }
}
