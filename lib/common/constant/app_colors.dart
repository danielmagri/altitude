import 'dart:ui';

abstract class AppColors {
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

  // Light
  static const Color colorLightBackground = Color.fromARGB(255, 250, 250, 250);
  static const Color colorLightAccent = Color.fromARGB(255, 51, 51, 51);
  static const Color colorLightCloud = Color.fromARGB(255, 139, 216, 240);
  static const Color colorLightSky = Color.fromARGB(255, 139, 216, 240);
  static const Color colorLightSkyHighlight = Color.fromARGB(255, 78, 173, 176);
  static const Color colorLightShimmerBase = Color.fromARGB(255, 224, 224, 224);
  static const Color colorLightShimmerHighlight = Color.fromARGB(255, 245, 245, 245);
  static const Color colorLightDisableHabitCreation = Color.fromARGB(255, 158, 158, 158);
  static const Color colorLightChipSelected = Color.fromARGB(255, 51, 51, 51);
  static const Color colorLightDrawerIcon = Color.fromARGB(255, 0, 0, 0);
  static const Color colorLightLoading = Color.fromARGB(255, 0, 0, 0);
  static const Color colorLightStatisticLine = Color.fromARGB(255, 224, 224, 224);
  static const Color colorLightFrequencyDot = Color.fromARGB(255, 51, 51, 51);
  static const Color colorLightAlarmUnselectedCard = Color.fromARGB(255, 255, 255, 255);
  static const Color colorLightAlarmUnselectedText = Color.fromARGB(255, 0, 0, 0);

  // Dark
  static const Color colorDarkBackground = Color.fromARGB(255, 18, 18, 18);
  static const Color colorDarkAccent = Color.fromARGB(255, 39, 39, 39);
  static const Color colorDarkCloud = Color.fromARGB(255, 255, 255, 255);
  static const Color colorDarkSky = Color.fromARGB(255, 0, 0, 0);
  static const Color colorDarkSkyHighlight = Color.fromARGB(255, 249, 215, 28);
  static const Color colorDarkShimmerBase = Color.fromARGB(255, 40, 40, 40);
  static const Color colorDarkShimmerHighlight = Color.fromARGB(255, 90, 90, 90);
  static const Color colorDarkDisableHabitCreation = Color.fromARGB(255, 39, 39, 39);
  static const Color colorDarkChipSelected = Color.fromARGB(255, 255, 255, 255);
  static const Color colorDarkDrawerIcon = Color.fromARGB(255, 255, 255, 255);
  static const Color colorDarkLoading = Color.fromARGB(255, 255, 255, 255);
  static const Color colorDarkStatisticLine = Color.fromARGB(255, 50, 50, 50);
  static const Color colorDarkFrequencyDot = Color.fromARGB(255, 224, 224, 224);
  static const Color colorDarkAlarmUnselectedCard = Color.fromARGB(255, 39, 39, 39);
  static const Color colorDarkAlarmUnselectedText = Color.fromARGB(255, 255, 255, 255);
}
