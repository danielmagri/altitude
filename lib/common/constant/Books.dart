import 'package:altitude/common/model/Book.dart';
import 'package:flutter/material.dart' show TextSpan, TextStyle, FontWeight;

const BOOKS = const [
  Book("Segredo revelado sobre os hábitos!", "Entenda de uma vez por todas porque você não consegue mudar seus hábitos.", [
    TextSpan(text: "O livro “O Poder do Hábito” do autor Charles Duhigg, que foi a inspiração do Altitude, revela o "),
    TextSpan(text: "segredo dos hábitos", style: const TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(
        text:
            " para você tomar o controle de sua vida rumo aos seus maiores desejos.\n\nQuer aprender de vez como usar seu cotidiano para alcançar "),
    TextSpan(text: "uma vida melhor", style: const TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(
        text:
            "?\n\nNós, do Altitude, te trazemos a oportunidade de comprar o livro com ótimo preço e ainda ajudar a nossa plataforma a "),
    TextSpan(text: "mudar a vida", style: const TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(text: " de muitas outras pessoas."),
  ]),
  Book("2 coisas que você precisa muito saber!", "A segunda vai transformar a maneira como enxergar seus hábitos.", [
    TextSpan(
        text:
            "Se você está usando o Altitude é sinal que também deseja criar novos hábitos e melhorar sua qualidade de vida, certo? Pois saiba que tenho "),
    TextSpan(text: "duas ótimas notícias para você!", style: const TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(text: "\n\nA primeira é que você já fez a parte mais difícil de todas: "),
    TextSpan(text: "dar o primeiro passo", style: const TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(
        text:
            " para a mudança quando começou a usar o Altitude.\n\nA segunda notícia é que para você conseguir uma mudança permanente dos hábitos, você precisa saber como eles realmente funcionam. Você não sabe? Calma, pra isso também temos uma solução: o livro “"),
    TextSpan(text: "O poder do hábito", style: const TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(text: "” explica tudo isso de forma muito simples e ainda te "),
    TextSpan(
        text: "ensina passo a passo como mudar qualquer hábito da sua vida",
        style: const TextStyle(fontWeight: FontWeight.bold)),
    TextSpan(text: ".\n\nSaiba mais acessando o livro pela Amazon no botão abaixo e comece a ler agora mesmo!"),
    TextSpan(
        text: "\n\nComprando por esse link você nos ajuda a manter nossa comunidade do Altitude!",
        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
  ]),
];
