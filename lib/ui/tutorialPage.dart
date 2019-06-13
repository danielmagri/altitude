import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit/ui/widgets/DotsIndicator.dart';
import 'package:habit/utils/Validator.dart';
import 'package:habit/main.dart';
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
                color: Colors.red,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 64),
                      child: Text(
                        "ADICIONAR HÁBITO",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            height: 225,
                            width: 225,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: new AssetImage('assets/addButton.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Crie um novo hábito clicando no botão \"+\"",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 64),
                      child: Text(
                        "FINALIZAR HÁBITO",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            height: 225,
                            width: 225,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: new AssetImage('assets/doneHabit.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Finalize o hábito do dia arrastando-o para a direita!",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.green,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 64),
                      child: Text(
                        "PONTUAÇÃO",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            height: 225,
                            width: 225,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: new AssetImage('assets/score.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.3))
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Ganhe pontos ao finalizar um hábito e um bônus ao completar o ciclo inteiro!",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.orange,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 64),
                      child: Text(
                        "Como podemos te chamar?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    Flexible(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          margin: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))],
                          ),
                          child: TextField(
                            controller: _nameTextController,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.words,
                            onEditingComplete: _nextTap,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration.collapsed(hintText: "Seu nome"),
                          ),
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
