import 'package:flutter/material.dart';
import 'package:habit/ui/tutorialPage.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 16),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: BackButton(),
                ),
                Spacer(),
                Text(
                  "Ajuda",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.15,
                    fontFamily: "Montserrat"),
                children: <TextSpan>[
                  TextSpan(
                      text: "Pontuação",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  TextSpan(
                      text:
                          "\n A cada vez que você completa um hábito, é adicionado 1km na altitude do hábito e na altitude total. E a cada vez que você completar o ciclo inteiro (a quatidade de dias que definiu na frequência) você irá ganhar 10km de bônus."),
                  TextSpan(
                      text: "\n\nGatilho",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  TextSpan(
                      text:
                      "\n O gatilho do hábito é uma técnica utilizada para que você consiga criar a rotina do hábito, mais rapidamente no seu cérebro. Sempre antes de você fazer realmente o hábito tente criar alguma ação consciente antes, como calçar os sapatos de corrida, deixar livro do lado da cama, algo relacionado ao seu hábito. Dessa forma sempre que você fizer essa ação anterior você se sentirá mais motivado a fazer o hábito."),
                  TextSpan(
                      text: "\n\nCompetição",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  TextSpan(
                      text:
                      "\n Em breve."),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
