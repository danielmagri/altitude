import 'package:altitude/common/base/base_state.dart';
import 'package:altitude/presentation/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState
    extends BaseStateWithController<LoginPage, LoginController> {
  void loginWithFacebook() {
    showLoading(true);
    controller.loginFacebook().then((uid) {
      showLoading(false);
      if (uid != null) navigateRemoveUntil('home');
    }).catchError(handleError);
  }

  void loginWithGoogle() {
    showLoading(true);
    controller.loginGoogle().then((uid) {
      showLoading(false);
      if (uid != null) navigateRemoveUntil('home');
    }).catchError(handleError);
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset('assets/logo_grande.png'),
            ),
            const Spacer(flex: 2),
            const SizedBox(
              width: double.maxFinite,
              child: Text(
                'Entre agora e mude seus hábitos de vez! Está esperando o que?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(flex: 2),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 59, 89, 152),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 13),
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.white24),
                  elevation: MaterialStateProperty.all(2),
                ),
                onPressed: loginWithFacebook,
                child: const Text(
                  'Entrar com Facebook',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, left: 20, right: 20),
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 218, 67, 54),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 13),
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.white24),
                  elevation: MaterialStateProperty.all(2),
                ),
                onPressed: loginWithGoogle,
                child: const Text(
                  'Entrar com Google',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
            InkWell(
              onTap: () {
                launch('https://altitude-4e5d4.firebaseapp.com/');
              },
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'termos de uso',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
