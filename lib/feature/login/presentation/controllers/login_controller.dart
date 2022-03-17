import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/feature/login/domain/usecases/auth_google_usecase.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

@LazySingleton()
class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final AuthGoogleUsecase _authGoogleUsecase;

  _LoginControllerBase(this._authGoogleUsecase);

  Future<String?> loginFacebook() async {
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

  Future<String?> loginGoogle() async {
    return _authGoogleUsecase
        .call()
        .resultComplete((data) => data, ((error) => null));
  }
}
