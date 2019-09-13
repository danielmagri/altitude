import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Center(
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(
                  top: 32, left: 16, right: 16, bottom: 24),
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
                  SizedBox(height: 16),
                  Text(
                    "Você precisa fazer o login\n para continuar...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: double.maxFinite,
                    child: Text(
                      "Adicione seu amigos para acompanhar o progresso de cada um. E veja quem está na frente pelo Ranking de amigos!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "..selecione por qual preferir",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: RaisedButton(
                      color: Color.fromARGB(255, 59, 89, 152),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      onPressed: () {},
                      child: Text(
                        "Continue com Facebook",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 20, right: 20),
                    width: double.maxFinite,
                    child: RaisedButton(
                      color: Color.fromARGB(255, 218, 67, 54),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      onPressed: () {},
                      child: Text(
                        "Continue com Google",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
