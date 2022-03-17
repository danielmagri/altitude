import 'dart:ui' show Color;
import 'package:altitude/common/constant/app_colors.dart';

@deprecated
abstract class LevelControl {
  static const List<String> _levelsText = [
    "Procrastinador",
    "Novato",
    "Aprendiz",
    "Teimoso",
    "Motivador",
    "Inspirador",
    "Nova pessoa",
    "Coach",
    "Mito",
    "Astronauta"
  ];

  static const List<int> _levelsValue = [
    0,
    15,
    50,
    125,
    250,
    450,
    700,
    1000,
    1500,
    2500
  ];

  static int getLevel(int score) {
    if (score >= _levelsValue[9]) {
      return 9;
    } else if (score >= _levelsValue[8]) {
      return 8;
    } else if (score >= _levelsValue[7]) {
      return 7;
    } else if (score >= _levelsValue[6]) {
      return 6;
    } else if (score >= _levelsValue[5]) {
      return 5;
    } else if (score >= _levelsValue[4]) {
      return 4;
    } else if (score >= _levelsValue[3]) {
      return 3;
    } else if (score >= _levelsValue[2]) {
      return 2;
    } else if (score >= _levelsValue[1]) {
      return 1;
    } else {
      return 0;
    }
  }

  static int getMaxScore(int code) {
    return _levelsValue[code];
  }

  static String getLevelText(int score) {
    return _levelsText[getLevel(score)];
  }

  static String getLevelTextByCode(int code) {
    return _levelsText[code];
  }

  static String getLevelImagePath(int score) {
    switch (getLevel(score)) {
      case 0:
        return "assets/level/bronze0.png";
      case 1:
        return "assets/level/bronze1.png";
      case 2:
        return "assets/level/bronze2.png";
      case 3:
        return "assets/level/bronze3.png";
      case 4:
        return "assets/level/silver1.png";
      case 5:
        return "assets/level/silver2.png";
      case 6:
        return "assets/level/silver3.png";
      case 7:
        return "assets/level/gold1.png";
      case 8:
        return "assets/level/gold2.png";
      case 9:
        return "assets/level/gold3.png";
      default:
        return "assets/level/bronze0.png";
    }
  }

  static String getLevelImagePathByCode(int code) {
    switch (code) {
      case 0:
        return "assets/level/bronze0.png";
      case 1:
        return "assets/level/bronze1.png";
      case 2:
        return "assets/level/bronze2.png";
      case 3:
        return "assets/level/bronze3.png";
      case 4:
        return "assets/level/silver1.png";
      case 5:
        return "assets/level/silver2.png";
      case 6:
        return "assets/level/silver3.png";
      case 7:
        return "assets/level/gold1.png";
      case 8:
        return "assets/level/gold2.png";
      case 9:
        return "assets/level/gold3.png";
      default:
        return "assets/level/bronze0.png";
    }
  }

  static Color getLevelColor(int score) {
    switch (getLevel(score)) {
      case 0:
      case 1:
      case 2:
      case 3:
        return AppColors.levelsColor[0];
      case 4:
      case 5:
      case 6:
        return AppColors.levelsColor[1];
      case 7:
      case 8:
      case 9:
        return AppColors.levelsColor[2];
      default:
        return AppColors.levelsColor[0];
    }
  }

  static Color getLevelColorByCode(int code) {
    switch (code) {
      case 0:
      case 1:
      case 2:
      case 3:
        return AppColors.levelsColor[0];
      case 4:
      case 5:
      case 6:
        return AppColors.levelsColor[1];
      case 7:
      case 8:
      case 9:
        return AppColors.levelsColor[2];
      default:
        return AppColors.levelsColor[0];
    }
  }
}
