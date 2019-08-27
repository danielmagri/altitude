import 'dart:ui';

import 'package:habit/utils/Color.dart';

abstract class LevelControl {
  static const List<String> _levelsText = [
    "Procrastinador",
    "Aprendiz",
    "Transformador",
    "Persistente",
    "Motivador",
    "Inspirador",
    "Nova pessoa",
    "Coach",
    "Mito",
    "Astronauta"
  ];

  static int getLevel(int score) {
    if (score >= 1500) {
      return 9;
    } else if (score >= 1000) {
      return 8;
    } else if (score >= 850) {
      return 7;
    } else if (score >= 650) {
      return 6;
    } else if (score >= 450) {
      return 5;
    } else if (score >= 350) {
      return 4;
    } else if (score >= 200) {
      return 3;
    } else if (score >= 100) {
      return 2;
    } else if (score >= 15) {
      return 1;
    } else {
      return 0;
    }
  }

  static int getMaxScore(int code) {
    switch (code) {
      case 0:
        return 0;
      case 1:
        return 15;
      case 2:
        return 100;
      case 3:
        return 200;
      case 4:
        return 350;
      case 5:
        return 450;
      case 6:
        return 650;
      case 7:
        return 850;
      case 8:
        return 1000;
      case 9:
        return 1500;
      default:
        return 0;
    }
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
