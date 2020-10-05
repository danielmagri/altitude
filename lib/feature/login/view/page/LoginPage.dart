import 'package:altitude/core/base/BaseState.dart';
import 'package:altitude/feature/TransferDataDialog.dart';
import 'package:altitude/feature/login/logic/LoginLogic.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:altitude/utils/Color.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  final LoginLogic controller = GetIt.I.get<LoginLogic>();

  @override
  void dispose() {
    GetIt.I.resetLazySingleton<LoginLogic>();
    super.dispose();
  }

  void loginWithFacebook() {
    showLoading(true);
    controller.loginFacebook().then((uid) {
      showLoading(false);
      if (uid != null) savePersonData(uid);
    }).catchError(handleError);
  }

  void loginWithGoogle() {
    showLoading(true);
    controller.loginGoogle().then((uid) {
      showLoading(false);
      if (uid != null) savePersonData(uid);
    }).catchError(handleError);
  }

  void savePersonData(String uid) {
    showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return TransferDataDialog(uid: uid);
        }).then((value) {
      if (value) navigateRemoveUntil('home');
    }).catchError(handleError);
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset("assets/logo_grande.png"),
            ),
            const Spacer(flex: 2),
            Container(
              width: double.maxFinite,
              child: Text(
                "Texto do login aqui", //TODO:
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, height: 1.25, color: AppColors.colorAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(flex: 2),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: RaisedButton(
                color: const Color.fromARGB(255, 59, 89, 152),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                onPressed: loginWithFacebook,
                child: const Text("Entrar com Facebook",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, left: 20, right: 20),
              width: double.maxFinite,
              child: RaisedButton(
                color: Color.fromARGB(255, 218, 67, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                onPressed: loginWithGoogle,
                child:
                    const Text("Entrar com Google", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const Spacer(flex: 2),
            InkWell(
                onTap: () {
                  //TODO:
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text("termos de uso", style: const TextStyle(decoration: TextDecoration.underline)),
                ))
          ],
        ),
      ),
    );
  }
}
