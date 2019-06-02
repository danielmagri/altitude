import 'package:flutter/material.dart';
import 'package:habit/utils/enums.dart';

abstract class CategoryColors {
  static const Color physicalPrimary = Color.fromARGB(255, 190, 60, 60);
  static const Color physicalSecundary = Color.fromARGB(255, 150, 50, 50);

  static const Color mentalPrimary = Color.fromARGB(255, 55, 55, 175);
  static const Color mentalSecundary = Color.fromARGB(255, 50, 50, 150);

  static const Color socialPrimary = Color.fromARGB(255, 56, 173, 72);
  static const Color socialSecundary = Color.fromARGB(255, 50, 147, 55);

  static Color getPrimaryColor(CategoryEnum category) {
    switch (category) {
      case CategoryEnum.PHYSICAL:
        return physicalPrimary;
      case CategoryEnum.MENTAL:
        return mentalPrimary;
      case CategoryEnum.SOCIAL:
        return socialPrimary;
    }
    return Color.fromARGB(255, 24, 24, 24);
  }

  static Color getSecundaryColor(CategoryEnum category) {
    switch (category) {
      case CategoryEnum.PHYSICAL:
        return physicalSecundary;
      case CategoryEnum.MENTAL:
        return mentalSecundary;
      case CategoryEnum.SOCIAL:
        return socialSecundary;
    }
    return Color.fromARGB(255, 24, 24, 24);
  }
}
