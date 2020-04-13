import 'package:altitude/common/view/generic/Toast.dart';
import 'package:altitude/core/view/BaseState.dart';
import 'package:altitude/feature/login/logic/LoginLogic.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:altitude/utils/Color.dart';

class LoginDialog extends StatefulWidget {
  LoginDialog({Key key, @required this.isCompetitionPage}) : super(key: key);

  final bool isCompetitionPage;

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends BaseState<LoginDialog> {
  static const String friendText =
      "Adicione seus amigos para acompanhar o progresso de cada um. E veja quem está na frente pelo Ranking de amigos!";
  static const String competitionText = "Crie competições com seus amigos para ver quem vai mais alto!";

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
      if (result) navigatePop(result: true);
    }).catchError((error) {
      showLoading(false);
      if (error is String)
        showToast(error);
      else
        showToast("Ocorreu um erro");
    });
  }

  void loginWithGoogle() {
    showLoading(true);
    controller.loginGoogle().then((result) {
      showLoading(false);
      if (result) navigatePop(result: true);
    }).catchError((error) {
      showLoading(false);
      if (error is String)
        showToast(error);
      else
        showToast("Ocorreu um erro");
    });
  }

  Future<bool> onBackPress() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Container(color: Colors.black.withOpacity(0.2)),
            Center(
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Você precisa fazer o login\n para continuar...",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                    const SizedBox(height: 24),
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        widget.isCompetitionPage ? competitionText : friendText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, height: 1.25, color: AppColors.colorAccent, fontWeight: FontWeight.bold),
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
                        child: const Text("Entrar com Google",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 8),
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
