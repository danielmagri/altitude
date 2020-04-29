import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color disableHabitCreation = Colors.grey;
  static Color colorAccent = Color.fromARGB(255, 51, 51, 51);
  static const Color sky = Color.fromARGB(255, 139, 216, 240);
  static const Color popupMenuButtonHome = Color.fromARGB(255, 130, 130, 130);

  static const List<Color> habitsColor = [
    Color.fromARGB(255, 244, 67, 54),
    Color.fromARGB(255, 244, 142, 52),
    Color.fromARGB(255, 250, 238, 0),
    Color.fromARGB(255, 76, 175, 80),
    Color.fromARGB(255, 34, 200, 234),
    Color.fromARGB(255, 0, 102, 204),
    Color.fromARGB(255, 152, 53, 152)
  ];

  static const List<String> habitsColorName = [
    "Vermelho",
    "Laranja",
    "Amarelo",
    "Verde",
    "Azul claro",
    "Azul escuro",
    "Roxo"
  ];

  static const List<Color> levelsColor = [
    Color.fromARGB(255, 205, 127, 50),
    Color.fromARGB(255, 192, 192, 192),
    Color.fromARGB(255, 255, 215, 0)
  ];
}
