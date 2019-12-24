import 'package:flutter/material.dart';
import 'package:habit/services/SharedPref.dart';
import 'Util.dart';

abstract class AppColors {
  static const Color disableHabitCreation = Colors.grey;
  static Color colorHabitMix = Colors.black;
  static const Color sky = Color.fromARGB(255, 139, 216, 240);

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

  static Future<void> getColorMix() async {
    String rgb = await SharedPref().getColor();
    if (rgb != null && rgb.isNotEmpty) {
      List<String> splited = rgb.split(",");
      colorHabitMix = new Color.fromARGB(
          255, int.parse(splited[0]), int.parse(splited[1]), int.parse(splited[2]));
    }
  }

  static bool updateColorMix(List<int> colors) {
    int r = 0;
    int g = 0;
    int b = 0;
    for (int color in colors) {
      r += habitsColor[color].red;
      g += habitsColor[color].green;
      b += habitsColor[color].blue;
    }
    r = (r / colors.length).round();
    g = (g / colors.length).round();
    b = (b / colors.length).round();

    var newColor = Util.setWhitening(new Color.fromARGB(255, r, g, b), -110);

    if (newColor.red != colorHabitMix.red ||
        newColor.green != colorHabitMix.green ||
        newColor.blue != colorHabitMix.blue) {
      colorHabitMix = newColor;
      SharedPref().setColor(newColor.red, newColor.green, newColor.blue);
      return true;
    } else {
      return false;
    }
  }
}
