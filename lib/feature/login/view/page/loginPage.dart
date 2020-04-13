import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/view/generic/Loading.dart';
import 'package:altitude/common/view/generic/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/common/services/FireFunctions.dart';
import 'package:altitude/utils/Color.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, @required this.isCompetitionPage}) : super(key: key);

  final bool isCompetitionPage;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String friendText =
      "Adicione seus amigos para acompanhar o progresso de cada um. E veja quem está na frente pelo Ranking de amigos!";
  static const String competitionText = "Crie competições com seus amigos para ver quem vai mais alto!";

  void loginWithFacebook() async {
    var result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        Loading.showLoading(context);
        AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

        try {
          AuthResult fireResult = await FirebaseAuth.instance.signInWithCredential(credential);

          if (!await FireFunctions()
              .newUser(fireResult.user.displayName, fireResult.user.email, SharedPref.instance.score)) {
            await UserControl().logout();
            Loading.closeLoading(context);
            showToast("Ocorreu um erro");
          } else {
            Loading.closeLoading(context);
            Navigator.pop(context, true);
          }
        } catch (error) {
          Loading.closeLoading(context);
          showToast("Ocorreu um erro");
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        showToast("Ocorreu um erro");
        break;
    }
  }

  void loginWithGoogle() async {
    GoogleSignIn googleSignIn = new GoogleSignIn();

    try {
      Loading.showLoading(context);
      var result = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await result.authentication;
      AuthCredential credential =
          GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      AuthResult fireResult = await FirebaseAuth.instance.signInWithCredential(credential);
      if (!await FireFunctions()
          .newUser(fireResult.user.displayName, fireResult.user.email, SharedPref.instance.score)) {
        await UserControl().logout();
        showToast("Ocorreu um erro");
        Loading.closeLoading(context);
      } else {
        Loading.closeLoading(context);
        Navigator.pop(context, true);
      }
    } catch (error) {
      Loading.closeLoading(context);
      showToast("Ocorreu um erro");
    }
  }

  Future<bool> onBackPress() async {
    Navigator.of(context).popUntil((route) => route.isFirst);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black.withOpacity(0.2),
            ),
            Center(
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Você precisa fazer o login\n para continuar...",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        widget.isCompetitionPage ? competitionText : friendText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, height: 1.25, color: AppColors.colorAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "..selecione por qual preferir",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: double.maxFinite,
                      child: RaisedButton(
                        color: Color.fromARGB(255, 59, 89, 152),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        onPressed: loginWithFacebook,
                        child: Text(
                          "Entrar com Facebook",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, left: 20, right: 20),
                      width: double.maxFinite,
                      child: RaisedButton(
                        color: Color.fromARGB(255, 218, 67, 54),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        onPressed: loginWithGoogle,
                        child: Text(
                          "Entrar com Google",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
