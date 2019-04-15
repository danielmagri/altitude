import 'package:flutter/material.dart';

class HabitTab extends StatelessWidget {
  HabitTab({Key key, this.controller, this.onTap}) : super(key: key);

  final TextEditingController controller;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(0.0, 1.0),
            child: Text("Texto explicando sobre o hábito"),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment(-0.6, 0.6),
            child: Text(
              "Qual será seu hábito?",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              hintText: "Escreva aqui",
              filled: true,
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(30.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Text("Lista das sugestões"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                onTap(false);
              },
              child: const Text("VOLTAR"),
            ),
            RaisedButton(
              onPressed: () {
                onTap(true);
              },
              child: const Text("AVANÇAR"),
            ),
          ],
        ),
      ],
    );
  }
}
