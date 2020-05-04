import 'package:flutter/material.dart';

abstract class Util {
  // static Future<bool> checkUpdatedVersion() async {
  //   return (await SharedPref().getVersion()) >= int.parse((await PackageInfo.fromPlatform()).buildNumber);
  // }

  /// Clareia a cor de acordo com o 'value' de 0 a 255
  static Color setWhitening(Color color, int value) {
    int r = color.red + value;
    int g = color.green + value;
    int b = color.blue + value;

    if (r > 255)
      r = 255;
    else if (r < 0) r = 0;
    if (g > 255)
      g = 255;
    else if (g < 0) g = 0;
    if (b > 255)
      b = 255;
    else if (b < 0) b = 0;

    return Color.fromARGB(color.alpha, r, g, b);
  }
}
