import 'package:altitude/core/base/BaseState.dart';
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
  static const String friendText =
      "Adicione seus amigos para acompanhar o progresso de cada um. E veja quem está na frente pelo Ranking de amigos!";
  // static const String competitionText = "Crie competições com seus amigos para ver quem vai mais alto!";

  LoginLogic controller = GetIt.I.get<LoginLogic>();
  @override
  void dispose() {
    GetIt.I.resetLazySingleton<LoginLogic>();
    super.dispose();
  }

  void loginWithFacebook() {
    showLoading(true);
    controller.loginFacebook().then((result) {
      showLoading(false);
      if (result) navigateRemoveUntil('home');
    }).catchError(handleError);
  }

  void loginWithGoogle() {
    showLoading(true);
    controller.loginGoogle().then((result) {
      showLoading(false);
      if (result) navigateRemoveUntil('home');
    }).catchError(handleError);
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Você precisa fazer o login\n para continuar...",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
          const SizedBox(height: 24),
          Container(
            width: double.maxFinite,
            child: Text(
              friendText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, height: 1.25, color: AppColors.colorAccent, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          const Text("..selecione por qual preferir",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: RaisedButton(
              color: Color.fromARGB(255, 59, 89, 152),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 13),
              onPressed: loginWithFacebook,
              child:
                  const Text("Entrar com Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
