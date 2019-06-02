import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/ui/widgets/DotsIndicator.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/main.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/controllers/DataPreferences.dart';

class TutorialPage extends StatefulWidget {
  TutorialPage({Key key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final _controller = new PageController();
  final _nameTextController = TextEditingController();

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void _nextTap() async {
    if (_controller.page < 2.9) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      String result = Validate.nameTextValidate(_nameTextController.text);

      if (result == null) {
        await DataPreferences().setName(_nameTextController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return MainPage();
          }));
      } else {
        Fluttertoast.showToast(
            msg: result,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Color.fromARGB(255, 220, 220, 220),
            textColor: Colors.black,
            fontSize: 16.0);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            children: <Widget>[
              Container(
                color: Color.fromARGB(255, 190, 60, 60),
                child: Text("Adicionar hábito"),
              ),
              Container(
                color: Color.fromARGB(255, 55, 55, 175),
                child: Text("Finalizar Hábito"),
              ),
              Container(
                color: Color.fromARGB(255, 56, 173, 72),
                child: Text("Pontuação"),
              ),
              Container(
                color: Color.fromARGB(255, 200, 200, 200),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          "Qual é seu nome?",
                          style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 180, 180, 180),
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.5))],
                        ),
                        child: TextField(
                          controller: _nameTextController,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.words,
                          onEditingComplete: _nextTap,
                          style: TextStyle(fontSize: 16.0),
                          decoration: InputDecoration.collapsed(
                              hintText: "Seu nome", hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ],
          ),
          new Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: new Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black26, width: 1)),
              ),
              child: Stack(
                children: <Widget>[
                  new Center(
                    child: new DotsIndicator(
                      controller: _controller,
                      itemCount: 4,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    height: 60,
                    child: FlatButton(
                      child: Text(
                        "Avançar",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      onPressed: _nextTap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
