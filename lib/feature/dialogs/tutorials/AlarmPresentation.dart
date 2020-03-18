import 'package:flutter/material.dart';

class AlarmPresentation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                center: Alignment(0.59, -0.85),
                stops: [0.9, 1],
                radius: 0.15,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.2,
                      fontFamily: "Montserrat"),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Esqueceu de marcar como feito o hábito?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    TextSpan(
                        text:
                            "\n\nQue tal colocar um alarme, assim você será sempre lembrado a hora que desejar!"),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.85),
            child: SizedBox(
              width: 150,
              child: RaisedButton(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 5.0,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "fechar",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
