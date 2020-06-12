import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/model/Book.dart';
import 'package:flutter/material.dart'
    show Colors, EdgeInsets, FontWeight, Image, Padding, RichText, TextAlign, TextSpan, TextStyle;

var BOOKS = [
  Book(
      "O que você precisa saber para mudar seus hábitos",
      "assets/loop_smoke.png",
      4,
      [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(
                      text:
                          "   Você sabia que em 1900 escovar os dentes não era algo comum entre as pessoas? Apenas 7% da população dos Estados Unidos tinha o hábito da escovação. E foi nesse período que uma empresa dental teve uma "),
                  TextSpan(text: "ideia genial", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ", ela adicionou um ingrediente na pasta de dente e fez o número de pessoas que escovam os dentes pular para 65% em 10 anos! Qual foi o grande segredo?"),
                ]),
          ),
        ),
        Image.asset("assets/brush.png", width: 150),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(
                      text:
                          "   40% de tudo que fazemos no nosso dia são hábitos, ou seja, quase metade de nossas decisões são feitas em “piloto automático”. Isso serve para que seu cérebro poupe energia. Como até as coisas mais complexas, como dirigir um carro, com o tempo se tornam automáticas. Por isso aprender sobre os hábitos é algo determinante para mudar sua vida!"),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(text: "   Os hábitos podem ser divididos em 3 partes, que formam o "),
                  TextSpan(text: "loop do hábito", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ", elas são: o gatilho, a rotina e a recompensa."),
                ]),
          ),
        ),
        Image.asset("assets/loop.png", width: 200),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(text: "O "),
                  TextSpan(text: "gatilho", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " nada mais é do que um sinal que você dá ao cérebro para ele iniciar o hábito. Como colocar o livro ao lado da cama, arrumar tapete do alongamento."),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20, top: 20),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(text: "A "),
                  TextSpan(text: "rotina", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " é a ação que você toma ao ter o gatilho. Como acender a luz de um cômodo (mesmo a casa estando sem energia), checar as notificações ao pegar o celular."),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 20),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(text: "A "),
                  TextSpan(text: "recompensa", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " é o “prêmio” ou sensação que você tem ao realizar a tarefa, quanto melhor for o prêmio, mais forte será a força do hábito."),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(
                      text:
                          "    Voltando a história da pasta de dente, o ingrediente foi nada mais que o sabor que deixava a boca com frescor, fazendo com que as pessoas associassem o frescor com limpeza."),
                ]),
          ),
        ),
        Image.asset("assets/brush_with_toothpaste.png", width: 150),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(
                      text: "    Portanto, quem deseja criar um novo hábito não deve focar na rotina, mas sim na "),
                  TextSpan(
                      text: "conexão do gatilho com a recompensa", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: ". Com um gatilho certo e uma recompensa forte, criar novos hábitos será bem mais fácil."),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(
                      text:
                          "    E para mudar hábitos o segredo é o mesmo, o gatilho e a recompensa já estão criadas na sua cabeça, portanto basta "),
                  TextSpan(
                      text: "mudar a rotina que dará a mesma recompensa",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          ". Como por exemplo, o desejo de fumar (gatilho), que traz a recompensa de relaxamento é mantido, mas ao invés de fumar você pode fazer uma caminhada, comer algum alimento saudável, ou fazer algo que te traga a mesma recompensa."),
                ]),
          ),
        ),
        Image.asset("assets/loop_smoke.png", width: 200),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 32, top: 32),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.25, fontFamily: "Montserrat"),
                children: [
                  TextSpan(text: "    Quer "),
                  TextSpan(
                      text: "entender tudo que precisa saber sobre os hábitos",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          " e ainda ajudar a plataforma do Altitude? Compre o livro \"O poder do hábito\" pela botão abaixo na Amazon."),
                ]),
          ),
        ),
      ],
      "assets/o_poder_do_habito.jpg",
      BUY_BOOK)
];
